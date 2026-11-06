import 'package:flutter_test/flutter_test.dart';
import 'package:postcrate/features/posts/domain/social_app.dart';
import 'package:postcrate/features/share/post_links.dart';

void main() {
  test('recognizes post links from each platform', () {
    const cases = {
      'https://x.com/postcrate/status/1850000000000000000': SocialApp.x,
      'https://twitter.com/postcrate/status/185?s=20': SocialApp.x,
      'https://www.instagram.com/p/C9abcDEF12/': SocialApp.instagram,
      'https://www.instagram.com/reel/C9abcDEF12/?igsh=xyz': SocialApp.instagram,
      'https://www.threads.net/@postcrate/post/C9abcDEF12': SocialApp.threads,
      'https://www.facebook.com/share/p/1AbCdEf/': SocialApp.facebook,
      'https://www.facebook.com/postcrate/posts/pfbid02abc': SocialApp.facebook,
      'https://fb.watch/abc123/': SocialApp.facebook,
      'https://www.linkedin.com/posts/postcrate_launch-activity-7250000000-abcd': SocialApp.linkedin,
      'https://www.linkedin.com/feed/update/urn:li:activity:7250000000/': SocialApp.linkedin,
      'https://bsky.app/profile/postcrate.bsky.social/post/3lb2abcxyz': SocialApp.bluesky,
      'https://www.tiktok.com/@postcrate/video/7430000000000000000': SocialApp.tiktok,
      'https://vm.tiktok.com/ZMabc123/': SocialApp.tiktok,
      'https://youtu.be/dQw4w9WgXcQ': SocialApp.youtube,
      'https://www.youtube.com/shorts/abc123XYZ': SocialApp.youtube,
      'https://www.reddit.com/r/FlutterDev/comments/1gabc12/launch/': SocialApp.reddit,
      'https://pin.it/3abcDEF': SocialApp.pinterest,
      'https://t.me/postcrate/42': SocialApp.telegram,
      'https://mastodon.social/@postcrate/113400000000000000': SocialApp.mastodon,
    };
    cases.forEach((url, app) => expect(PostLinks.parse(url)?.app, app, reason: url));
  });

  test('ignores profiles and non-post pages', () {
    for (final url in [
      'https://x.com/postcrate',
      'https://www.instagram.com/postcrate/',
      'https://www.linkedin.com/in/someone',
      'https://example.com/post/1',
      'not a url',
    ]) {
      expect(PostLinks.parse(url), isNull, reason: url);
    }
  });

  test('finds a link inside copied text', () {
    final link = PostLinks.find('Check this out: https://bsky.app/profile/a.bsky.social/post/3abc). Nice');
    expect(link?.app, SocialApp.bluesky);
    expect(link?.url.toString(), 'https://bsky.app/profile/a.bsky.social/post/3abc');
  });

  test('composer links encode text and fall back to null', () {
    expect(SocialApp.x.composer('Hi #dev')!.toString(), 'https://x.com/intent/post?text=Hi%20%23dev');
    expect(SocialApp.facebook.composer('Hi'), isNull);
    expect(SocialApp.facebook.composer('Hi', url: 'https://a.b')!.host, 'www.facebook.com');
    expect(SocialApp.instagram.composer('Hi'), isNull);
  });

  test('maps Android chooser components and iOS activity types', () {
    expect(SocialApp.fromShareTarget('com.whatsapp/com.whatsapp.ContactPicker'), SocialApp.whatsapp);
    expect(SocialApp.fromShareTarget('com.instagram.barcelona/.Share'), SocialApp.threads);
    expect(SocialApp.fromShareTarget('com.facebook.Messenger.ShareExtension'), SocialApp.messenger);
    expect(SocialApp.fromShareTarget('com.facebook.Facebook.ShareExtension'), SocialApp.facebook);
    expect(SocialApp.fromShareTarget('ph.telegra.Telegraph.Share'), SocialApp.telegram);
  });
}
