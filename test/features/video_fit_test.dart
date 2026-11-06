import 'package:flutter_test/flutter_test.dart';
import 'package:postcrate/features/posts/domain/media_info.dart';
import 'package:postcrate/features/posts/domain/post.dart';
import 'package:postcrate/features/posts/domain/social_app.dart';
import 'package:postcrate/features/posts/domain/video_fit.dart';

Attachment video({
  int w = 1080,
  int h = 1920,
  int ms = 42000,
  String name = 'clip.mp4',
  int size = 1000,
  int? rotation,
}) => Attachment(
  id: 'v1',
  kind: AttachmentKind.video,
  fileName: name,
  relativePath: 'media/v1.mp4',
  mimeType: 'video/mp4',
  sizeBytes: size,
  sha256: 'abc',
  mediaInfo: MediaInfo(width: w, height: h, rotation: rotation, durationMs: ms, videoCodec: 'avc1', audioCodec: 'mp4a'),
);

void main() {
  group('VideoFit', () {
    test('only checks the apps the post is going to', () {
      expect(VideoFit.check(video(), const []), isEmpty);
      final notes = VideoFit.check(video(), const [SocialApp.linkedin, SocialApp.threads]);
      expect(notes.single.text, 'Fits LinkedIn and Threads.');
    });

    test('short vertical videos post in the short format of each app', () {
      final notes = VideoFit.check(video(), const [SocialApp.youtube, SocialApp.instagram]);
      expect(notes.map((n) => n.text), contains(contains('YouTube Short')));
      expect(notes.map((n) => n.text), contains(contains('Instagram Reel')));
      final wide = VideoFit.check(video(w: 1920, h: 1080), const [SocialApp.youtube]);
      expect(wide.single.text, 'Fits YouTube.');
    });

    test('rotated landscape storage counts as vertical', () {
      final notes = VideoFit.check(video(w: 1920, h: 1080, rotation: 90), const [SocialApp.youtube]);
      expect(notes.single.text, contains('Short'));
    });

    test('warns per app on length and file size', () {
      final notes = VideoFit.check(video(w: 1920, h: 1080, ms: 4 * 60 * 1000, size: 600 * 1024 * 1024), const [
        SocialApp.x,
        SocialApp.linkedin,
      ]);
      final warnings = notes.where((n) => n.level == FitLevel.warning).map((n) => n.text).toList();
      expect(warnings, hasLength(2));
      expect(warnings.every((t) => t.startsWith('X ')), isTrue);
      expect(notes.first.text, 'Fits LinkedIn.');
    });

    test('flags uncommon containers for every app', () {
      final notes = VideoFit.check(video(name: 'clip.webm'), const []);
      expect(notes.single.level, FitLevel.warning);
    });
  });
}
