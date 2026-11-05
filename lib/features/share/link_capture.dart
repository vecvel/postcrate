import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../posts/domain/post.dart';
import '../posts/domain/social_app.dart';
import 'post_links.dart';
import 'share_providers.dart';

/// A post (and the share it probably belongs to) that a captured link can be attached to.
@immutable
class LinkCandidate {
  const LinkCandidate({required this.post, this.share});

  final Post post;

  /// The share waiting for this link, or null to create a new share entry.
  final ShareEvent? share;
}

/// A post link found on the clipboard or shared into Postcrate.
@immutable
class LinkOffer {
  const LinkOffer({required this.link, required this.candidates, required this.fromShareSheet});

  final PostLink link;
  final List<LinkCandidate> candidates;
  final bool fromShareSheet;
}

final linkCaptureProvider = NotifierProvider<LinkCapture, LinkOffer?>(LinkCapture.new);

/// Finds out where a post was published. See "Where did it get shared?" in
/// docs/sharing-architecture.md. Checks the clipboard when the app comes
/// back after a share, and accepts links shared into Postcrate on Android.
class LinkCapture extends Notifier<LinkOffer?> with WidgetsBindingObserver {
  static const _window = Duration(hours: 24);

  bool _started = false;
  final _offered = <String>{};

  @override
  LinkOffer? build() {
    ref.onDispose(() => WidgetsBinding.instance.removeObserver(this));
    return null;
  }

  void start() {
    if (_started) return;
    _started = true;
    WidgetsBinding.instance.addObserver(this);
    final native = ref.read(nativeShareProvider);
    native.onIncomingText = (text) => unawaited(_incoming(text));
    unawaited(native.takeIncomingText().then((t) => t == null ? null : _incoming(t)).catchError((_) => null));
  }

  bool _wasBackgrounded = false;
  bool _checking = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Only react to real trips to another app. System sheets such as the iOS
    // paste prompt only make the app inactive, and reacting to those would
    // ask again in a loop.
    if (state == AppLifecycleState.hidden || state == AppLifecycleState.paused) {
      _wasBackgrounded = true;
    } else if (state == AppLifecycleState.resumed && _wasBackgrounded) {
      _wasBackgrounded = false;
      unawaited(checkClipboard());
    }
  }

  List<(Post, ShareEvent)> _awaiting(List<Post> posts) {
    final since = DateTime.now().subtract(_window);
    return [
      for (final p in posts)
        for (final s in p.shareHistory)
          if (s.liveUrl == null && s.sharedAt.isAfter(since)) (p, s),
    ]..sort((a, b) => b.$2.sharedAt.compareTo(a.$2.sharedAt));
  }

  List<LinkCandidate> _rank(List<(Post, ShareEvent)> awaiting, PostLink link) {
    final matching = awaiting.where((e) => e.$2.target == link.app.label);
    final others = awaiting.where((e) => e.$2.target != link.app.label);
    return [
      for (final (p, s) in [...matching, ...others]) LinkCandidate(post: p, share: s),
    ];
  }

  /// Offers a copied post link when a recent share is still waiting for one.
  Future<void> checkClipboard() async {
    if (state != null || _checking) return;
    _checking = true;
    try {
      await _checkClipboard();
    } finally {
      _checking = false;
    }
  }

  Future<void> _checkClipboard() async {
    final posts = await ref.read(postsRepositoryProvider).getAll();
    final awaiting = _awaiting(posts);
    if (awaiting.isEmpty) return;
    if (!await Clipboard.hasStrings()) return;
    final text = (await Clipboard.getData(Clipboard.kTextPlain))?.text;
    if (text == null) return;
    final link = PostLinks.find(text);
    if (link == null || _offered.contains(link.url.toString())) return;
    if (await ref.read(postsRepositoryProvider).hasLiveUrl(link.url.toString())) return;
    _offered.add(link.url.toString());
    state = LinkOffer(link: link, candidates: _rank(awaiting, link), fromShareSheet: false);
  }

  Future<void> _incoming(String text) async {
    final link = PostLinks.find(text) ?? _anyUrl(text);
    if (link == null) return;
    final posts = await ref.read(postsRepositoryProvider).getAll();
    final awaiting = _awaiting(posts);
    final ranked = _rank(awaiting, link);
    final waitingIds = ranked.map((c) => c.post.id).toSet();
    final recent = [...posts]..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    final rest = [for (final p in recent.where((p) => !waitingIds.contains(p.id)).take(10)) LinkCandidate(post: p)];
    state = LinkOffer(link: link, candidates: [...ranked, ...rest], fromShareSheet: true);
  }

  PostLink? _anyUrl(String text) {
    final match = RegExp(r'https?://\S+').firstMatch(text);
    final uri = match == null ? null : Uri.tryParse(match.group(0)!);
    return uri == null ? null : PostLink(app: SocialApp.other, url: uri);
  }

  Future<void> accept(LinkCandidate candidate) async {
    final offer = state;
    if (offer == null) return;
    state = null;
    final repo = ref.read(postsRepositoryProvider);
    final url = offer.link.url.toString();
    final label = offer.link.app == SocialApp.other ? null : offer.link.app.label;
    if (candidate.share != null) {
      await repo.setLiveUrl(candidate.share!.id, url, target: label);
    } else {
      await repo.recordShare(candidate.post.id, label ?? offer.link.url.host, liveUrl: url);
    }
  }

  void dismiss() => state = null;
}
