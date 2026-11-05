import '../../posts/domain/post.dart';

enum YouTubeNoteLevel { ok, info, warning, blocker }

class YouTubeNote {
  const YouTubeNote(this.level, this.text);

  final YouTubeNoteLevel level;
  final String text;
}

/// YouTube rules checked on the device before a video is shared to the
/// YouTube app, so problems show up before the upload starts there.
/// Source: YouTube Help "Upload videos" and "Supported file formats".
abstract final class YouTubeRules {
  static const maxBytes = 256 * 1024 * 1024 * 1024;
  static const unverifiedMaxMs = 15 * 60 * 1000;
  static const shortsMaxMs = 3 * 60 * 1000;

  static const containers = {'mp4', 'mov', 'm4v', 'webm', 'avi', 'wmv', 'flv', '3gp', 'mpg', 'mpeg'};

  static bool isShortsEligible(Attachment v) {
    final info = v.mediaInfo;
    final d = info?.durationMs ?? v.durationMs;
    final size = info?.displaySize;
    if (d == null || size == null) return false;
    return d <= shortsMaxMs && size.$2 >= size.$1;
  }

  /// Notes about one video; a blocker means the upload would be rejected.
  static List<YouTubeNote> checkVideo(Attachment v) {
    final notes = <YouTubeNote>[];
    final ext = v.fileName.split('.').last.toLowerCase();
    if (!containers.contains(ext)) {
      notes.add(YouTubeNote(YouTubeNoteLevel.blocker, "YouTube doesn't accept .$ext files."));
    }
    if (v.sizeBytes > maxBytes) {
      notes.add(const YouTubeNote(YouTubeNoteLevel.blocker, 'Larger than 256 GB, the YouTube limit.'));
    }
    final info = v.mediaInfo;
    final d = info?.durationMs ?? v.durationMs;
    if (d != null && d > unverifiedMaxMs) {
      notes.add(
        const YouTubeNote(
          YouTubeNoteLevel.warning,
          'Longer than 15 minutes. Your YouTube account needs to be verified to upload it.',
        ),
      );
    }
    if (isShortsEligible(v)) {
      notes.add(
        const YouTubeNote(YouTubeNoteLevel.ok, 'Vertical and under 3 minutes: YouTube will show it as a Short.'),
      );
    }
    final codec = info?.videoCodec?.toLowerCase();
    if (codec != null && !_preferredVideo.contains(codec)) {
      notes.add(const YouTubeNote(YouTubeNoteLevel.info, 'YouTube will re-encode it. H.264 uploads process fastest.'));
    }
    if (info != null && info.audioCodec == null && v.kind == AttachmentKind.video) {
      notes.add(const YouTubeNote(YouTubeNoteLevel.info, 'This video has no sound track.'));
    }
    return notes;
  }

  static const _preferredVideo = {
    'avc1',
    'avc3',
    'video/avc',
    'hvc1',
    'hev1',
    'video/hevc',
    'av01',
    'video/av01',
    'vp09',
  };
}
