import 'package:flutter_test/flutter_test.dart';
import 'package:postcrate/features/posts/domain/media_info.dart';
import 'package:postcrate/features/posts/domain/post.dart';
import 'package:postcrate/features/youtube/domain/youtube_rules.dart';

Attachment video({int w = 1080, int h = 1920, int ms = 42000, String name = 'clip.mp4', int size = 1000}) => Attachment(
  id: 'v1',
  kind: AttachmentKind.video,
  fileName: name,
  relativePath: 'media/v1.mp4',
  mimeType: 'video/mp4',
  sizeBytes: size,
  sha256: 'abc',
  mediaInfo: MediaInfo(width: w, height: h, durationMs: ms, videoCodec: 'avc1', audioCodec: 'mp4a'),
);

void main() {
  group('YouTubeRules', () {
    test('vertical videos under 3 minutes become Shorts', () {
      expect(YouTubeRules.isShortsEligible(video()), isTrue);
      expect(YouTubeRules.isShortsEligible(video(w: 1920, h: 1080)), isFalse);
      expect(YouTubeRules.isShortsEligible(video(ms: 4 * 60 * 1000)), isFalse);
    });

    test('rotated landscape storage counts as vertical', () {
      final a = video(w: 1920, h: 1080);
      final rotated = a.copyWith(mediaInfo: const MediaInfo(width: 1920, height: 1080, rotation: 90, durationMs: 1000));
      expect(YouTubeRules.isShortsEligible(rotated), isTrue);
    });

    test('blocks unsupported containers and warns on long videos', () {
      final notes = YouTubeRules.checkVideo(video(name: 'clip.mkv', ms: 20 * 60 * 1000, w: 1920, h: 1080));
      expect(notes.any((n) => n.level == YouTubeNoteLevel.blocker), isTrue);
      expect(notes.any((n) => n.level == YouTubeNoteLevel.warning), isTrue);
    });
  });
}
