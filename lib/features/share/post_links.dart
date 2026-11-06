import '../posts/domain/social_app.dart';

/// A URL recognized as a published post on a social platform.
class PostLink {
  const PostLink({required this.app, required this.url});

  final SocialApp app;
  final Uri url;
}

/// Recognizes post URLs copied from social apps ("Copy link") so they can be
/// attached to the post they came from.
abstract final class PostLinks {
  static final _url = RegExp(r'https?://[^\s<>"]+', caseSensitive: false);

  static final _patterns = <SocialApp, RegExp>{
    SocialApp.x: RegExp(r'^(?:www\.|mobile\.)?(?:x|twitter)\.com/[^/]+/status/\d+'),
    SocialApp.instagram: RegExp(r'^(?:www\.)?instagram\.com/(?:[^/]+/)?(?:p|reel|reels|tv)/[\w-]+'),
    SocialApp.threads: RegExp(r'^(?:www\.)?threads\.(?:net|com)/@[^/]+/post/[\w-]+'),
    SocialApp.facebook: RegExp(
      r'^(?:(?:www|m|web)\.)?(?:facebook\.com/(?:.+/(?:posts|videos|photos)/|permalink\.php|story\.php|share/|reel/|watch|photo)|fb\.watch/)',
    ),
    SocialApp.linkedin: RegExp(r'^(?:www\.)?linkedin\.com/(?:posts/|feed/update/|pulse/)'),
    SocialApp.bluesky: RegExp(r'^bsky\.app/profile/[^/]+/post/\w+'),
    SocialApp.tiktok: RegExp(r'^(?:(?:www|m)\.tiktok\.com/@[^/]+/(?:video|photo)/\d+|(?:vm|vt)\.tiktok\.com/\w+)'),
    SocialApp.youtube: RegExp(r'^(?:(?:www|m)\.youtube\.com/(?:watch\?v=|shorts/|live/)|youtu\.be/)[\w-]+'),
    SocialApp.reddit: RegExp(r'^(?:(?:www|old|new)\.)?reddit\.com/(?:r|u|user)/[^/]+/(?:comments|s)/\w+|^redd\.it/\w+'),
    SocialApp.pinterest: RegExp(r'^(?:[a-z]{2,3}\.)?(?:www\.)?pinterest\.[a-z.]+/pin/\d+|^pin\.it/\w+'),
    SocialApp.telegram: RegExp(r'^t\.me/(?:c/)?[\w]+/\d+'),
    SocialApp.tumblr: RegExp(r'^(?:www\.)?tumblr\.com/[\w-]+/\d+|^[\w-]+\.tumblr\.com/post/\d+'),
  };

  static final _mastodon = RegExp(r'^[\w.-]+\.[a-z]{2,}/@[\w.]+/\d{6,}$');

  /// Finds the first recognizable post URL in [text].
  static PostLink? find(String text) {
    for (final m in _url.allMatches(text)) {
      final link = parse(m.group(0)!.replaceAll(RegExp(r'[).,;!?]+$'), ''));
      if (link != null) return link;
    }
    return null;
  }

  static PostLink? parse(String raw) {
    final uri = Uri.tryParse(raw.trim());
    if (uri == null || !(uri.scheme == 'https' || uri.scheme == 'http') || uri.host.isEmpty) return null;
    final rest = '${uri.host.toLowerCase()}${uri.path}${uri.hasQuery ? '?${uri.query}' : ''}';
    for (final e in _patterns.entries) {
      if (e.value.hasMatch(rest)) return PostLink(app: e.key, url: uri);
    }
    if (_mastodon.hasMatch('${uri.host.toLowerCase()}${uri.path}')) return PostLink(app: SocialApp.mastodon, url: uri);
    return null;
  }
}
