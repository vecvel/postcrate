import 'package:flutter_test/flutter_test.dart';
import 'package:postcrate/core/notifications/reminders.dart';
import 'package:postcrate/core/utils/formatting.dart';
import 'package:postcrate/features/posts/data/link_preview_fetcher.dart';
import 'package:postcrate/features/posts/domain/media_info.dart';
import 'package:postcrate/features/posts/domain/post.dart';
import 'package:postcrate/features/posts/presentation/widgets/media_details.dart';

void main() {
  test('codec identifiers get readable names on both platforms', () {
    expect(MediaInfo.codecLabel('avc1'), 'H.264 (AVC)');
    expect(MediaInfo.codecLabel('video/hevc'), 'H.265 (HEVC)');
    expect(MediaInfo.codecLabel('mp4a'), 'AAC');
    expect(MediaInfo.codecLabel('audio/mp4a-latm'), 'AAC');
    expect(MediaInfo.codecLabel('xyz1'), 'xyz1');
  });

  test('display size applies rotation', () {
    const info = MediaInfo(width: 1920, height: 1080, rotation: 90);
    expect(info.displaySize, (1080, 1920));
    expect(info.isVertical, isTrue);
  });

  test('media details list every known field', () {
    const a = Attachment(
      id: 'a',
      kind: AttachmentKind.video,
      fileName: 'clip.mov',
      relativePath: 'media/a.mov',
      mimeType: 'video/quicktime',
      sizeBytes: 12345678,
      sha256: 's',
      mediaInfo: MediaInfo(
        container: 'QuickTime',
        videoCodec: 'hvc1',
        audioCodec: 'mp4a',
        width: 3840,
        height: 2160,
        durationMs: 62500,
        bitrate: 24000000,
        frameRate: 29.97,
        sampleRate: 48000,
        channels: 2,
        colorSpace: 'Rec. 2020',
        hdr: true,
      ),
    );
    final rows = Map.fromEntries(mediaDetailRows(a).map((r) => MapEntry(r.$1, r.$2)));
    expect(rows['Format'], 'QuickTime · video/quicktime');
    expect(rows['Video codec'], 'H.265 (HEVC) · hvc1');
    expect(rows['Audio codec'], 'AAC · mp4a');
    expect(rows['Resolution'], '3840 × 2160 · 16:9 landscape');
    expect(rows['Duration'], '1:03');
    expect(rows['Frame rate'], '29.97 fps');
    expect(rows['Bitrate'], '24 Mbps');
    expect(rows['Audio'], '48 kHz · Stereo');
    expect(rows['Color'], 'Rec. 2020 · HDR');
    expect(rows['File size'], '11.8 MB (12,345,678 bytes)');
  });

  test('formatting helpers', () {
    expect(durationLabel(3725000), '1:02:05');
    expect(bitrateLabel(128000), '128 kbps');
    expect(aspectLabel(1080, 1920), '9:16');
    expect(aspectLabel(1000, 333), '3.00:1');
  });

  test('link previews read Open Graph tags, falling back to the title', () {
    final p = LinkPreviewFetcher.parse(
      '<html><head><title>Fallback</title>'
      '<meta content="Release notes &amp; more" property="og:title">'
      '<meta name="description" content="What changed">'
      '<meta property="og:image" content="/cover.png"></head></html>',
      Uri.parse('https://example.com/changelog'),
    );
    expect(p.title, 'Release notes & more');
    expect(p.description, 'What changed');
    expect(p.imageUrl, 'https://example.com/cover.png');
    expect(LinkPreviewFetcher.parse('<title> Only </title>', Uri.parse('https://a.b')).title, 'Only');
  });

  test('reminder ids are stable and positive', () {
    final id = Reminders.idFor('8d0f2c1e-1b6f-4d1a-9a77-2c4f0f0d3b11');
    expect(id, Reminders.idFor('8d0f2c1e-1b6f-4d1a-9a77-2c4f0f0d3b11'));
    expect(id, greaterThan(0));
  });

  test('media info survives the post JSON round trip', () {
    final now = DateTime(2026, 11, 5);
    final post = Post(
      id: 'p',
      createdAt: now,
      updatedAt: now,
      attachments: const [
        Attachment(
          id: 'a',
          kind: AttachmentKind.audio,
          fileName: 'a.m4a',
          relativePath: 'media/a.m4a',
          mimeType: 'audio/mp4',
          sizeBytes: 1,
          sha256: 's',
          mediaInfo: MediaInfo(audioCodec: 'mp4a', sampleRate: 44100, channels: 1, durationMs: 1000),
        ),
      ],
    );
    expect(Post.fromJson(post.toJson()).toJson(), post.toJson());
  });
}
