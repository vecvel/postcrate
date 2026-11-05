import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../posts/data/posts_repository.dart';
import '../posts/domain/post.dart';
import '../posts/domain/social_app.dart';
import 'native/native_share.dart';

enum ShareOutcome { shared, openedComposer, dismissed, unavailable }

class ShareReport {
  const ShareReport(this.outcome, {this.app, this.captionOnClipboard = false});

  final ShareOutcome outcome;
  final SocialApp? app;

  /// True when the chosen app is known to drop pre-filled text, so the user
  /// should paste the caption.
  final bool captionOnClipboard;
}

/// Sends a post to installed apps.
///
/// Text and files go through the native share module, which copies the
/// caption to the clipboard first. Title, poll, alt text, first comment,
/// location and thread parts can't travel through a share sheet and are
/// offered through [copy] instead.
class ShareService {
  ShareService(this._repo, this._native);

  final PostsRepository _repo;
  final NativeShare _native;

  NativeShare get native => _native;

  String textFor(Post post, SocialApp? app) {
    final variant = app == null ? null : post.targets.where((t) => t.app == app).map((t) => t.variantText).firstOrNull;
    final text = (variant != null && variant.trim().isNotEmpty) ? variant : post.body;
    final parts = <String>[text.trim(), if (post.link != null && !text.contains(post.link!.url)) post.link!.url];
    return parts.where((p) => p.isNotEmpty).join('\n\n');
  }

  Future<ShareReport> share(BuildContext context, Post post, {SocialApp? app}) async {
    final box = context.findRenderObject() as RenderBox?;
    final origin = box == null || !box.hasSize ? null : box.localToGlobal(Offset.zero) & box.size;
    final text = textFor(post, app);

    final files = <NativeShareFile>[];
    for (final a in post.attachments) {
      final file = _repo.media.resolve(a.relativePath);
      if (await file.exists()) files.add(NativeShareFile(path: file.path, mimeType: a.mimeType, name: a.fileName));
    }

    // Text-only posts aimed at one platform open its composer, which the OS
    // routes to the native app through universal or app links.
    if (files.isEmpty && app != null && app != SocialApp.other) {
      final composer = app.composer(text, title: post.title, url: post.link?.url);
      if (composer != null) {
        await Clipboard.setData(ClipboardData(text: text));
        if (await _native.openUrl(composer)) {
          await _repo.recordShare(post.id, app.label);
          return ShareReport(ShareOutcome.openedComposer, app: app);
        }
      }
    }

    final result = await _native.share(
      text: text,
      subject: (post.title ?? '').trim().isEmpty ? null : post.title,
      files: files,
      target: app == SocialApp.other ? null : app,
      origin: origin,
    );

    switch (result.status) {
      case NativeShareStatus.completed:
        final known = SocialApp.fromShareTarget(result.target) ?? (app != SocialApp.other ? app : null);
        await _repo.recordShare(post.id, known?.label ?? _cleanRaw(result.target));
        return ShareReport(
          ShareOutcome.shared,
          app: known,
          captionOnClipboard: text.isNotEmpty && files.isNotEmpty && known != null && !known.keepsText,
        );
      case NativeShareStatus.dismissed:
        return const ShareReport(ShareOutcome.dismissed);
      case NativeShareStatus.unavailable:
        return const ShareReport(ShareOutcome.unavailable);
    }
  }

  Future<void> copy(String text) => Clipboard.setData(ClipboardData(text: text));

  Future<bool> open(Uri url) => _native.openUrl(url);

  static const _systemActivities = {
    'CopyToPasteboard': 'Copied',
    'Mail': 'Mail',
    'Message': 'Messages',
    'AirDrop': 'AirDrop',
    'SaveToCameraRoll': 'Photos',
    'Print': 'Printed',
    'SharePlay': 'SharePlay',
    'CollaborationInviteWithLink': 'Messages',
  };

  static String _cleanRaw(String raw) {
    if (raw.isEmpty) return 'Shared';
    if (raw.startsWith('com.apple.')) {
      final last = raw.split('.').last;
      if (raw.contains('DocumentManagerUICore') || raw.contains('SaveToFiles')) return 'Files';
      return _systemActivities[last] ?? last;
    }
    final pkg = raw.split('/').first;
    final parts = pkg.split('.').where((s) => s.isNotEmpty && s != 'com' && s != 'android' && s != 'app').toList();
    final pick = parts.isEmpty ? pkg : parts.firstWhere((p) => p.length > 3, orElse: () => parts.first);
    final word = pick.replaceAll(RegExp(r'(ShareExtension|shareextension|Share)$'), '');
    return word.isEmpty ? 'Shared' : '${word[0].toUpperCase()}${word.substring(1)}';
  }
}
