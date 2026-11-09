import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../posts/data/link_preview_fetcher.dart';
import '../posts/domain/post.dart';
import 'link_capture.dart';
import 'native/native_share.dart';
import 'share_providers.dart';

/// The result of saving a shared item into a post.
@immutable
class SavedShare {
  const SavedShare({required this.postId, required this.skipped});

  final String postId;

  /// Files left out because Postcrate doesn't support their type.
  final int skipped;
}

final incomingShareProvider = NotifierProvider<IncomingShare, IncomingItem?>(IncomingShare.new);

/// "Save to Postcrate": text, links and files shared in from other apps
/// through the iOS share extension or the Android share sheet. The state is
/// the item waiting for the user to pick a post for it.
class IncomingShare extends Notifier<IncomingItem?> with WidgetsBindingObserver {
  bool _started = false;
  bool _checking = false;

  @override
  IncomingItem? build() {
    ref.onDispose(() => WidgetsBinding.instance.removeObserver(this));
    return null;
  }

  void start() {
    if (_started) return;
    _started = true;
    WidgetsBinding.instance.addObserver(this);
    ref.read(nativeShareProvider).onIncoming = () => unawaited(check());
    unawaited(check());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) unawaited(check());
  }

  /// Shows the next waiting item. Social post links go to link capture when a
  /// recent share is waiting for one.
  Future<void> check() async {
    if (state != null || _checking) return;
    _checking = true;
    try {
      final native = ref.read(nativeShareProvider);
      for (final item in await native.incomingItems()) {
        final text = item.text;
        if (item.files.isEmpty && text != null && await ref.read(linkCaptureProvider.notifier).offerShared(text)) {
          await native.removeIncoming(item.id);
          continue;
        }
        state = item;
        return;
      }
    } catch (_) {
      // Nothing shared, or the platform has no inbox.
    } finally {
      _checking = false;
    }
  }

  /// Adds the waiting item to [into], or to a new post when null.
  Future<SavedShare?> save({Post? into}) async {
    final item = state;
    if (item == null) return null;
    final repo = ref.read(postsRepositoryProvider);
    final media = ref.read(mediaStoreProvider);

    final base = into == null ? repo.newPost() : (await repo.getPost(into.id) ?? into);
    final attachments = [...base.attachments];
    var skipped = 0;
    for (final f in item.files) {
      final file = File(f.path);
      final a = await file.exists() ? await media.import(file, originalName: f.name) : null;
      if (a == null) {
        skipped++;
      } else {
        attachments.add(a);
      }
    }

    var body = base.body;
    LinkPreview? link = base.link;
    final text = item.text?.trim() ?? '';
    final onlyUrl = RegExp(r'^https?://\S+$').hasMatch(text);
    if (onlyUrl && link == null) {
      final preview = await LinkPreviewFetcher().fetch(text);
      link = LinkPreview(url: text, title: preview?.title, description: preview?.description);
    } else if (text.isNotEmpty) {
      body = body.trim().isEmpty ? text : '${body.trimRight()}\n\n$text';
    }

    final post = base.copyWith(body: body, link: () => link, attachments: attachments, updatedAt: DateTime.now());
    await repo.save(post);
    await _finish(item);
    return SavedShare(postId: post.id, skipped: skipped);
  }

  /// Throws the waiting item away.
  Future<void> discard() async {
    final item = state;
    if (item != null) await _finish(item);
  }

  Future<void> _finish(IncomingItem item) async {
    await ref.read(nativeShareProvider).removeIncoming(item.id);
    state = null;
    unawaited(check());
  }
}

/// "2 photos and a link", for the save sheet.
String describeIncoming(IncomingItem item) {
  var images = 0, videos = 0, audio = 0, documents = 0;
  for (final f in item.files) {
    final m = f.mimeType;
    if (m.startsWith('image/')) {
      images++;
    } else if (m.startsWith('video/')) {
      videos++;
    } else if (m.startsWith('audio/')) {
      audio++;
    } else {
      documents++;
    }
  }
  final text = item.text?.trim() ?? '';
  String? count(int n, String one, String many) => n == 0 ? null : (n == 1 ? '1 $one' : '$n $many');
  final parts = [
    count(images, 'photo', 'photos'),
    count(videos, 'video', 'videos'),
    count(audio, 'audio file', 'audio files'),
    count(documents, 'document', 'documents'),
    if (text.isNotEmpty) RegExp(r'^https?://\S+$').hasMatch(text) ? 'a link' : 'some text',
  ].whereType<String>().toList();
  if (parts.isEmpty) return 'Nothing';
  final list = parts.length == 1 ? parts.first : '${parts.sublist(0, parts.length - 1).join(', ')} and ${parts.last}';
  return list[0].toUpperCase() + list.substring(1);
}
