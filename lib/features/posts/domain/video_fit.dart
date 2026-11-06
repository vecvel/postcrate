import '../../../core/utils/formatting.dart';
import 'post.dart';
import 'social_app.dart';

/// A short vertical format an app promotes, such as YouTube Shorts or
/// Instagram Reels.
class ShortForm {
  const ShortForm(this.name, this.maxMs);

  final String name;
  final int maxMs;
}

/// What an app accepts for a video post. Values are the published limits for
/// standard accounts and change over time, so checks are hints, never blocks.
class VideoLimits {
  const VideoLimits({this.maxDurationMs, this.maxBytes, this.shortForm});

  final int? maxDurationMs;
  final int? maxBytes;
  final ShortForm? shortForm;
}

const _min = 60 * 1000;
const _mb = 1024 * 1024;
const _gb = 1024 * _mb;

extension SocialAppVideo on SocialApp {
  /// Null when the app has no published video limits worth checking.
  VideoLimits? get videoLimits => switch (this) {
    SocialApp.youtube => const VideoLimits(
      maxDurationMs: 15 * _min,
      maxBytes: 256 * _gb,
      shortForm: ShortForm('Short', 3 * _min),
    ),
    SocialApp.instagram => const VideoLimits(shortForm: ShortForm('Reel', 3 * _min)),
    SocialApp.facebook => const VideoLimits(
      maxDurationMs: 240 * _min,
      maxBytes: 10 * _gb,
      shortForm: ShortForm('Reel', 90 * 1000),
    ),
    SocialApp.tiktok => const VideoLimits(maxDurationMs: 10 * _min),
    SocialApp.x => const VideoLimits(maxDurationMs: 140 * 1000, maxBytes: 512 * _mb),
    SocialApp.threads => const VideoLimits(maxDurationMs: 5 * _min),
    SocialApp.bluesky => const VideoLimits(maxDurationMs: 3 * _min, maxBytes: 100 * _mb),
    SocialApp.linkedin => const VideoLimits(maxDurationMs: 15 * _min, maxBytes: 5 * _gb),
    SocialApp.snapchat => const VideoLimits(maxDurationMs: 60 * 1000),
    SocialApp.reddit => const VideoLimits(maxDurationMs: 15 * _min, maxBytes: 1 * _gb),
    SocialApp.pinterest => const VideoLimits(maxDurationMs: 15 * _min, maxBytes: 2 * _gb),
    SocialApp.telegram => const VideoLimits(maxBytes: 2 * _gb),
    SocialApp.discord => const VideoLimits(maxBytes: 10 * _mb),
    _ => null,
  };
}

enum FitLevel { ok, info, warning }

class FitNote {
  const FitNote(this.level, this.text);

  final FitLevel level;
  final String text;
}

/// Checks a video against the apps a post is going to, plus a few
/// compatibility notes that apply everywhere.
abstract final class VideoFit {
  static const _containers = {'mp4', 'mov', 'm4v'};
  static const _codecs = {'avc1', 'avc3', 'video/avc', 'hvc1', 'hev1', 'video/hevc'};

  static List<FitNote> check(Attachment v, Iterable<SocialApp> apps) {
    final info = v.mediaInfo;
    final duration = info?.durationMs ?? v.durationMs;
    final size = info?.displaySize;
    final vertical = size != null && size.$2 >= size.$1;

    final notes = <FitNote>[];
    final fits = <String>[];
    for (final app in apps) {
      final limits = app.videoLimits;
      if (limits == null) continue;
      final before = notes.length;
      final maxMs = limits.maxDurationMs;
      if (maxMs != null && duration != null && duration > maxMs) {
        notes.add(
          FitNote(
            FitLevel.warning,
            '${app.label} takes videos up to ${durationLabel(maxMs)}. This one is ${durationLabel(duration)}.',
          ),
        );
      }
      final maxBytes = limits.maxBytes;
      if (maxBytes != null && v.sizeBytes > maxBytes) {
        notes.add(
          FitNote(
            FitLevel.warning,
            '${app.label} takes files up to ${_size(maxBytes)}. This one is ${fileSizeLabel(v.sizeBytes)}.',
          ),
        );
      }
      final short = limits.shortForm;
      if (short != null && vertical && duration != null && duration <= short.maxMs && notes.length == before) {
        notes.add(
          FitNote(FitLevel.ok, '${app.label} ${short.name}: vertical and under ${durationLabel(short.maxMs)}.'),
        );
      } else if (notes.length == before) {
        fits.add(app.label);
      }
    }
    if (fits.isNotEmpty) notes.insert(0, FitNote(FitLevel.ok, 'Fits ${_list(fits)}.'));

    final ext = v.fileName.contains('.') ? v.fileName.split('.').last.toLowerCase() : '';
    if (!_containers.contains(ext)) {
      notes.add(FitNote(FitLevel.warning, 'Most apps expect MP4 or MOV. Some may not accept .$ext files.'));
    }
    final codec = info?.videoCodec?.toLowerCase();
    if (codec != null && !_codecs.contains(codec)) {
      notes.add(
        const FitNote(FitLevel.info, 'Some apps re-encode or reject this codec. H.264 plays almost everywhere.'),
      );
    }
    if (info != null && info.audioCodec == null) {
      notes.add(const FitNote(FitLevel.info, 'This video has no sound track.'));
    }
    return notes;
  }

  static String _size(int bytes) =>
      bytes >= _gb && bytes % _gb == 0 ? '${bytes ~/ _gb} GB' : '${(bytes / _mb).round()} MB';

  static String _list(List<String> items) =>
      items.length == 1 ? items.first : '${items.sublist(0, items.length - 1).join(', ')} and ${items.last}';
}
