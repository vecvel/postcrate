/// Platforms Postcrate shares to. Text limits change over time.
enum SocialApp {
  facebook(
    'Facebook',
    textLimit: 63206,
    android: ['com.facebook.katana', 'com.facebook.lite'],
    iosScheme: 'fb',
    keepsText: false,
  ),
  messenger('Messenger', android: ['com.facebook.orca'], iosScheme: 'fb-messenger'),
  instagram('Instagram', textLimit: 2200, android: ['com.instagram.android'], iosScheme: 'instagram', keepsText: false),
  threads('Threads', textLimit: 500, android: ['com.instagram.barcelona'], iosScheme: 'barcelona'),
  whatsapp('WhatsApp', textLimit: 65536, android: ['com.whatsapp', 'com.whatsapp.w4b'], iosScheme: 'whatsapp'),
  telegram('Telegram', textLimit: 4096, android: ['org.telegram.messenger'], iosScheme: 'tg'),
  x('X', textLimit: 280, android: ['com.twitter.android'], iosScheme: 'twitter'),
  linkedin('LinkedIn', textLimit: 3000, android: ['com.linkedin.android'], iosScheme: 'linkedin'),
  bluesky('Bluesky', textLimit: 300, android: ['xyz.blueskyweb.app'], iosScheme: 'bluesky'),
  mastodon('Mastodon', textLimit: 500, android: ['org.joinmastodon.android'], iosScheme: 'mastodon'),
  tiktok(
    'TikTok',
    textLimit: 2200,
    android: ['com.zhiliaoapp.musically', 'com.ss.android.ugc.trill'],
    iosScheme: 'tiktok',
    keepsText: false,
  ),
  youtube(
    'YouTube',
    textLimit: 5000,
    titleLimit: 100,
    android: ['com.google.android.youtube'],
    iosScheme: 'youtube',
    keepsText: false,
  ),
  reddit('Reddit', textLimit: 40000, titleLimit: 300, android: ['com.reddit.frontpage'], iosScheme: 'reddit'),
  pinterest('Pinterest', textLimit: 500, titleLimit: 100, android: ['com.pinterest'], iosScheme: 'pinterest'),
  snapchat('Snapchat', textLimit: 250, android: ['com.snapchat.android'], iosScheme: 'snapchat', keepsText: false),
  discord('Discord', textLimit: 2000, android: ['com.discord'], iosScheme: 'discord'),
  tumblr('Tumblr', textLimit: 4096, android: ['com.tumblr'], iosScheme: 'tumblr'),
  other('Any app');

  const SocialApp(
    this.label, {
    this.textLimit,
    this.titleLimit,
    this.android = const [],
    this.iosScheme,
    this.keepsText = true,
  });

  final String label;
  final int? textLimit;
  final int? titleLimit;

  /// Android package names, preferred first.
  final List<String> android;

  /// iOS URL scheme used to check whether the app is installed.
  final String? iosScheme;

  /// False when the app drops pre-filled text (policy or behavior); the
  /// caption is then pasted from the clipboard.
  final bool keepsText;

  static SocialApp fromName(String name) =>
      SocialApp.values.firstWhere((a) => a.name == name, orElse: () => SocialApp.other);

  static List<SocialApp> get platforms => values.where((a) => a != other).toList();

  /// Web composer that opens the native app through universal or app links
  /// when installed. Null when the platform has no text composer link.
  Uri? composer(String text, {String? title, String? url}) {
    final t = Uri.encodeComponent(text);
    final full = Uri.encodeComponent(url == null || text.contains(url) ? text : '$text\n\n$url');
    return switch (this) {
      SocialApp.x => Uri.parse('https://x.com/intent/post?text=$full'),
      SocialApp.threads => Uri.parse('https://www.threads.net/intent/post?text=$full'),
      SocialApp.bluesky => Uri.parse('https://bsky.app/intent/compose?text=$full'),
      SocialApp.linkedin => Uri.parse('https://www.linkedin.com/feed/?shareActive=true&text=$full'),
      SocialApp.whatsapp => Uri.parse('https://wa.me/?text=$full'),
      SocialApp.telegram => Uri.parse('https://t.me/share/url?url=${Uri.encodeComponent(url ?? '')}&text=$t'),
      SocialApp.reddit => Uri.parse(
        'https://www.reddit.com/submit?type=TEXT&title=${Uri.encodeComponent(title ?? '')}&text=$full',
      ),
      SocialApp.tumblr => Uri.parse('https://www.tumblr.com/widgets/share/tool?posttype=text&content=$full'),
      SocialApp.facebook when url != null => Uri.parse(
        'https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(url)}',
      ),
      SocialApp.pinterest when url != null => Uri.parse(
        'https://www.pinterest.com/pin/create/button/?url=${Uri.encodeComponent(url)}&description=$t',
      ),
      _ => null,
    };
  }

  /// Maps what the share sheet reported (iOS activity type, Android package
  /// or component) to a platform.
  static SocialApp? fromShareTarget(String raw) {
    final r = raw.toLowerCase();
    for (final app in platforms) {
      if (app.android.any((p) => r.startsWith(p) || r.contains('$p/'))) return app;
    }
    const hints = {
      'facebook.messenger': SocialApp.messenger,
      'messenger': SocialApp.messenger,
      'facebook': SocialApp.facebook,
      'barcelona': SocialApp.threads,
      'threads': SocialApp.threads,
      'instagram': SocialApp.instagram,
      'burbn': SocialApp.instagram,
      'whatsapp': SocialApp.whatsapp,
      'telegra': SocialApp.telegram,
      'twitter': SocialApp.x,
      'tweetie': SocialApp.x,
      'atebits': SocialApp.x,
      'linkedin': SocialApp.linkedin,
      'bluesky': SocialApp.bluesky,
      'bsky': SocialApp.bluesky,
      'mastodon': SocialApp.mastodon,
      'tiktok': SocialApp.tiktok,
      'musically': SocialApp.tiktok,
      'youtube': SocialApp.youtube,
      'reddit': SocialApp.reddit,
      'pinterest': SocialApp.pinterest,
      'snapchat': SocialApp.snapchat,
      'picaboo': SocialApp.snapchat,
      'discord': SocialApp.discord,
      'hammerandchisel': SocialApp.discord,
      'tumblr': SocialApp.tumblr,
    };
    for (final e in hints.entries) {
      if (r.contains(e.key)) return e.value;
    }
    return null;
  }
}
