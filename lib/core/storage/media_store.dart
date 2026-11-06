import 'dart:io';
import 'dart:ui' as ui;

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../features/posts/domain/media_info.dart';
import '../../features/posts/domain/post.dart';
import '../media/media_probe.dart';

/// Owns attachment files. Files are copied into the app documents directory
/// and referenced by a relative path, because the absolute container path on
/// iOS can change between launches and updates.
class MediaStore {
  MediaStore._(this.root, this.probe);

  @visibleForTesting
  MediaStore.at(this.root, {this.probe = const MediaProbe()});

  final Directory root;
  final MediaProbe probe;
  static const folder = 'media';
  static const thumbFolder = 'media/thumbs';

  static Future<MediaStore> open() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, folder));
    await dir.create(recursive: true);
    await Directory(p.join(docs.path, thumbFolder)).create(recursive: true);
    return MediaStore._(docs, const MediaProbe());
  }

  File resolve(String relativePath) => File(p.join(root.path, relativePath));

  String relativePathFor(String id, String fileName) {
    final ext = p.extension(fileName).toLowerCase();
    return p.join(folder, '$id$ext');
  }

  /// Copies [source] into the store and returns a ready attachment, or null
  /// when the file type is not supported.
  Future<Attachment?> import(File source, {String? originalName}) async {
    final name = originalName ?? p.basename(source.path);
    final kind = AttachmentKind.fromExtension(p.extension(name));
    if (kind == null) return null;

    final id = const Uuid().v4();
    final rel = relativePathFor(id, name);
    final dest = resolve(rel);
    await source.copy(dest.path);

    final digest = await sha256.bind(dest.openRead()).first;
    final size = await dest.length();
    final mime = lookupMimeType(name) ?? 'application/octet-stream';

    final info = await probe.probe(dest);
    int? width = info?.displaySize?.$1, height = info?.displaySize?.$2;
    if (width == null && kind == AttachmentKind.image) {
      try {
        final buffer = await ui.ImmutableBuffer.fromFilePath(dest.path);
        final descriptor = await ui.ImageDescriptor.encoded(buffer);
        width = descriptor.width;
        height = descriptor.height;
        descriptor.dispose();
        buffer.dispose();
      } catch (_) {
        // Dimensions are optional; some formats can't be read without decoding.
      }
    }

    return Attachment(
      id: id,
      kind: kind,
      fileName: name,
      relativePath: rel,
      mimeType: mime,
      sizeBytes: size,
      sha256: digest.toString(),
      width: width,
      height: height,
      durationMs: info?.durationMs,
      mediaInfo: info,
      thumbRelativePath: await _makeThumbnail(id, kind, dest, atMs: _defaultFrameMs(info)),
    );
  }

  static int _defaultFrameMs(MediaInfo? info) {
    final d = info?.durationMs;
    if (d == null || d <= 0) return 0;
    return (d / 10).clamp(0, 1000).round();
  }

  String _thumbPathFor(String id, [int? atMs]) => p.join(thumbFolder, atMs == null ? '$id.jpg' : '$id-$atMs.jpg');

  Future<String?> _makeThumbnail(
    String id,
    AttachmentKind kind,
    File file, {
    int atMs = 0,
    bool versioned = false,
  }) async {
    if (kind != AttachmentKind.video && !(kind == AttachmentKind.document && p.extension(file.path) == '.pdf')) {
      return null;
    }
    final rel = _thumbPathFor(id, versioned ? atMs : null);
    final ok = await probe.thumbnail(file, resolve(rel), atMs: atMs);
    return ok ? rel : null;
  }

  /// Returns the attachment's preview frame, regenerating it when missing
  /// (after a restore, for example). Null for kinds without previews.
  Future<String?> ensureThumbnail(Attachment a) async {
    if (a.thumbRelativePath != null && await exists(a.thumbRelativePath!)) return a.thumbRelativePath;
    final file = resolve(a.relativePath);
    if (!await file.exists()) return null;
    return _makeThumbnail(a.id, a.kind, file, atMs: a.coverFrameMs ?? _defaultFrameMs(a.mediaInfo));
  }

  /// Renders the frame at [atMs] as the attachment's cover. A new file name
  /// per frame keeps image caches from showing the previous cover.
  Future<String?> coverFrame(Attachment a, int atMs) async {
    final old = a.thumbRelativePath;
    final rel = await _makeThumbnail(a.id, a.kind, resolve(a.relativePath), atMs: atMs, versioned: true);
    if (rel != null && old != null && old != rel) await delete(old);
    return rel;
  }

  /// Fills in media details for attachments imported before the probe existed.
  Future<Attachment> refreshInfo(Attachment a) async {
    if (a.mediaInfo != null) return a;
    final file = resolve(a.relativePath);
    if (!await file.exists()) return a;
    final info = await probe.probe(file);
    if (info == null) return a;
    final size = info.displaySize;
    return a.copyWith(mediaInfo: info, width: size?.$1, height: size?.$2, durationMs: info.durationMs);
  }

  Future<void> delete(String relativePath) async {
    final f = resolve(relativePath);
    if (await f.exists()) await f.delete();
  }

  Future<bool> exists(String relativePath) => resolve(relativePath).exists();

  /// Removes files no attachment refers to anymore.
  Future<int> removeOrphans(Set<String> referenced) async {
    var removed = 0;
    final dir = Directory(p.join(root.path, folder));
    if (!await dir.exists()) return 0;
    await for (final entity in dir.list()) {
      if (entity is! File) continue;
      final rel = p.join(folder, p.basename(entity.path));
      if (!referenced.contains(rel)) {
        await entity.delete();
        removed++;
      }
    }
    return removed;
  }
}
