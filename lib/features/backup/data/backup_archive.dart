import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:archive/archive_io.dart';
import 'package:path/path.dart' as p;

import '../../../core/utils/formatting.dart';
import '../../posts/domain/post.dart';

class BackupException implements Exception {
  const BackupException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// What a backup file holds, read without unpacking its media.
class BackupContents {
  const BackupContents({
    required this.file,
    required this.createdAt,
    required this.posts,
    required this.collections,
    required this.mediaEntries,
  });

  final File file;
  final DateTime createdAt;
  final List<Post> posts;
  final List<Collection> collections;

  /// Attachment sha256 → zip entry name.
  final Map<String, String> mediaEntries;

  /// Posts per creation day, newest day first.
  List<(DateTime, int)> get days {
    final counts = <DateTime, int>{};
    for (final post in posts) {
      final d = dayOf(post.createdAt);
      counts[d] = (counts[d] ?? 0) + 1;
    }
    return counts.entries.map((e) => (e.key, e.value)).toList()..sort((a, b) => b.$1.compareTo(a.$1));
  }
}

/// A Postcrate backup is one zip file anyone can store anywhere (Files, Google
/// Drive, iCloud Drive, a computer):
///
///   postcrate.json             every post and collection (format below)
///   media/SHA256.ext           each attachment once, named by content hash
///
/// Zipping and unzipping run in a background isolate so large videos never
/// block the UI, and files are streamed rather than loaded into memory.
abstract final class BackupArchive {
  static const format = 'postcrate.backup';
  static const version = 2;
  static const manifestName = 'postcrate.json';

  static String mediaEntry(Attachment a) => 'media/${a.sha256}${p.extension(a.fileName).toLowerCase()}';

  static String fileName(DateTime now) =>
      'Postcrate backup ${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}.zip';

  /// Writes a backup zip into [outDir] and returns it. [mediaPaths] maps zip
  /// entry names to absolute file paths on disk.
  static Future<File> write({
    required Directory outDir,
    required List<Post> posts,
    required List<Collection> collections,
    required Map<String, String> mediaPaths,
    DateTime? now,
  }) async {
    final created = now ?? DateTime.now();
    final manifest = jsonEncode({
      'format': format,
      'version': version,
      'createdAt': created.toUtc().toIso8601String(),
      'platform': Platform.operatingSystem,
      'posts': [for (final post in posts) post.toJson()],
      'collections': [for (final c in collections) c.toJson()],
    });
    final outPath = p.join(outDir.path, fileName(created));
    await Isolate.run(() async {
      final out = File(outPath);
      if (out.existsSync()) out.deleteSync();
      final encoder = ZipFileEncoder();
      encoder.create(outPath);
      final bytes = utf8.encode(manifest);
      encoder.addArchiveFile(ArchiveFile(manifestName, bytes.length, bytes));
      for (final e in mediaPaths.entries) {
        final f = File(e.value);
        // Photos and videos are already compressed; storing them is faster.
        if (f.existsSync()) await encoder.addFile(f, e.key, ZipFileEncoder.store);
      }
      await encoder.close();
    });
    return File(outPath);
  }

  /// Reads the manifest and the list of media in a backup zip.
  static Future<BackupContents> read(File zip) async {
    final path = zip.path;
    final raw = await Isolate.run(() {
      final input = InputFileStream(path);
      try {
        final archive = ZipDecoder().decodeStream(input);
        final manifest = archive.find(manifestName)?.readBytes();
        return (
          manifest == null ? null : utf8.decode(manifest),
          [
            for (final f in archive.files)
              if (f.isFile && f.name.startsWith('media/')) f.name,
          ],
        );
      } catch (_) {
        return (null, <String>[]);
      } finally {
        input.closeSync();
      }
    });
    final (text, entries) = raw;
    if (text == null) throw const BackupException("That file isn't a Postcrate backup.");
    final json = (jsonDecode(text) as Map).cast<String, Object?>();
    if (json['format'] != format) throw const BackupException("That file isn't a Postcrate backup.");
    if ((json['version'] as int? ?? 0) > version) {
      throw const BackupException('This backup was made by a newer Postcrate. Update the app first.');
    }
    return BackupContents(
      file: zip,
      createdAt: DateTime.parse(json['createdAt']! as String).toLocal(),
      posts: [for (final post in json['posts']! as List) Post.fromJson((post as Map).cast<String, Object?>())],
      collections: [
        for (final c in (json['collections'] as List?) ?? const [])
          Collection.fromJson((c as Map).cast<String, Object?>()),
      ],
      mediaEntries: {for (final e in entries) p.basenameWithoutExtension(e): e},
    );
  }

  /// Unpacks the given zip entries to absolute paths. Returns the entries
  /// that were missing from the zip.
  static Future<Set<String>> extract(File zip, Map<String, String> entryToPath) {
    final path = zip.path;
    return Isolate.run(() {
      final missing = entryToPath.keys.toSet();
      final input = InputFileStream(path);
      try {
        final archive = ZipDecoder().decodeStream(input);
        for (final e in entryToPath.entries) {
          final f = archive.find(e.key);
          if (f == null || !f.isFile) continue;
          final target = File(e.value)..parent.createSync(recursive: true);
          final out = OutputFileStream(target.path);
          f.writeContent(out);
          out.closeSync();
          missing.remove(e.key);
        }
      } finally {
        input.closeSync();
      }
      return missing;
    });
  }
}
