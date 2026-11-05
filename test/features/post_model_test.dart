import 'package:flutter_test/flutter_test.dart';
import 'package:postcrate/features/posts/domain/post.dart';
import 'package:postcrate/features/posts/domain/social_app.dart';

void main() {
  final now = DateTime(2026, 11, 2, 9, 41);

  test('hashtags and mentions are parsed from text and thread parts', () {
    final post = Post(id: 'p1', createdAt: now, updatedAt: now).copyWith(
      body: 'Shipped it #design #buildinpublic thanks @mira',
      threadParts: ['More soon #design @dev@mastodon.social'],
    );
    expect(post.hashtags, ['design', 'buildinpublic']);
    expect(post.mentions, ['mira', 'dev@mastodon.social']);
  });

  test('every field survives a JSON round trip', () {
    final post = Post(
      id: 'p1',
      title: 'Onboarding, rebuilt',
      body: 'Three screens #design',
      threadParts: const ['Part two'],
      attachments: const [
        Attachment(
          id: 'a1',
          kind: AttachmentKind.video,
          fileName: 'demo.mov',
          relativePath: 'media/a1.mov',
          mimeType: 'video/quicktime',
          sizeBytes: 1200,
          sha256: 'abc',
          width: 1080,
          height: 1920,
          durationMs: 42000,
          altText: 'Demo',
          coverFrameMs: 1000,
          crop: CropAspect.story,
        ),
      ],
      link: const LinkPreview(url: 'https://example.com', title: 'Notes'),
      poll: const Poll(question: 'Next?', options: ['A', 'B'], durationHours: 72),
      hashtags: const ['design'],
      place: const Place(name: 'Lisbon', latitude: 38.7, longitude: -9.1),
      language: 'en',
      contentWarning: 'Spoilers',
      firstComment: 'Link in here',
      reminderAt: now.add(const Duration(days: 1)),
      targets: const [TargetApp(app: SocialApp.x, variantText: 'Short')],
      collectionIds: const ['c1'],
      status: PostStatus.ready,
      pinned: true,
      notes: 'After the demo',
      createdAt: now,
      updatedAt: now,
      shareHistory: [ShareEvent(id: 's1', target: 'X', sharedAt: now, liveUrl: 'https://x.com/1')],
    );

    final back = Post.fromJson(post.toJson());
    expect(back.toJson(), post.toJson());
  });

  test('isEmpty ignores whitespace-only content', () {
    final post = Post(id: 'p', createdAt: now, updatedAt: now).copyWith(body: '  \n', threadParts: [' ']);
    expect(post.isEmpty, isTrue);
  });

  test('attachment kinds come from file extensions', () {
    expect(AttachmentKind.fromExtension('.HEIC'), AttachmentKind.image);
    expect(AttachmentKind.fromExtension('webm'), AttachmentKind.video);
    expect(AttachmentKind.fromExtension('m4a'), AttachmentKind.audio);
    expect(AttachmentKind.fromExtension('pptx'), AttachmentKind.document);
    expect(AttachmentKind.fromExtension('exe'), isNull);
  });

  test('share sheet targets map to known apps', () {
    expect(SocialApp.fromShareTarget('com.burbn.instagram.shareextension'), SocialApp.instagram);
    expect(SocialApp.fromShareTarget('com.atebits.Tweetie2.ShareExtension'), SocialApp.x);
    expect(SocialApp.fromShareTarget('com.linkedin.android'), SocialApp.linkedin);
    expect(SocialApp.fromShareTarget('com.apple.UIKit.activity.Mail'), isNull);
  });
}
