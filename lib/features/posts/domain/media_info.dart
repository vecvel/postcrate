import 'package:flutter/foundation.dart';

/// Technical details read from a media file by the native media probe
/// (AVFoundation / ImageIO / PDFKit on iOS, MediaExtractor /
/// MediaMetadataRetriever / PdfRenderer on Android). Every field is optional:
/// what's known depends on the file type.
@immutable
class MediaInfo {
  const MediaInfo({
    this.container,
    this.videoCodec,
    this.audioCodec,
    this.width,
    this.height,
    this.rotation,
    this.durationMs,
    this.bitrate,
    this.frameRate,
    this.sampleRate,
    this.channels,
    this.colorSpace,
    this.hdr,
    this.pageCount,
  });

  /// Container or file format, for example "MPEG-4", "QuickTime", "HEIF".
  final String? container;

  /// Raw codec identifiers as reported by the OS, for example "avc1",
  /// "hvc1", "video/avc", "mp4a", "audio/mp4a-latm".
  final String? videoCodec;
  final String? audioCodec;

  /// Encoded (stored) size in pixels, before [rotation] is applied.
  final int? width;
  final int? height;
  final int? rotation;
  final int? durationMs;

  /// Bits per second (whole file or video track estimate).
  final int? bitrate;
  final double? frameRate;
  final int? sampleRate;
  final int? channels;
  final String? colorSpace;
  final bool? hdr;
  final int? pageCount;

  bool get isEmpty => toJson().values.every((v) => v == null);

  /// Width and height as displayed, after rotation.
  (int, int)? get displaySize {
    if (width == null || height == null) return null;
    final turned = rotation == 90 || rotation == 270;
    return turned ? (height!, width!) : (width!, height!);
  }

  bool get isVertical {
    final s = displaySize;
    return s != null && s.$2 > s.$1;
  }

  Map<String, Object?> toJson() => {
    'container': container,
    'videoCodec': videoCodec,
    'audioCodec': audioCodec,
    'width': width,
    'height': height,
    'rotation': rotation,
    'durationMs': durationMs,
    'bitrate': bitrate,
    'frameRate': frameRate,
    'sampleRate': sampleRate,
    'channels': channels,
    'colorSpace': colorSpace,
    'hdr': hdr,
    'pageCount': pageCount,
  };

  factory MediaInfo.fromJson(Map<String, Object?> j) => MediaInfo(
    container: j['container'] as String?,
    videoCodec: j['videoCodec'] as String?,
    audioCodec: j['audioCodec'] as String?,
    width: (j['width'] as num?)?.toInt(),
    height: (j['height'] as num?)?.toInt(),
    rotation: (j['rotation'] as num?)?.toInt(),
    durationMs: (j['durationMs'] as num?)?.toInt(),
    bitrate: (j['bitrate'] as num?)?.toInt(),
    frameRate: (j['frameRate'] as num?)?.toDouble(),
    sampleRate: (j['sampleRate'] as num?)?.toInt(),
    channels: (j['channels'] as num?)?.toInt(),
    colorSpace: j['colorSpace'] as String?,
    hdr: j['hdr'] as bool?,
    pageCount: (j['pageCount'] as num?)?.toInt(),
  );

  /// Human-readable codec name for a raw identifier.
  static String codecLabel(String raw) {
    final r = raw.toLowerCase().trim();
    const names = {
      'avc1': 'H.264 (AVC)',
      'avc3': 'H.264 (AVC)',
      'video/avc': 'H.264 (AVC)',
      'hvc1': 'H.265 (HEVC)',
      'hev1': 'H.265 (HEVC)',
      'video/hevc': 'H.265 (HEVC)',
      'dvh1': 'Dolby Vision (HEVC)',
      'video/dolby-vision': 'Dolby Vision',
      'av01': 'AV1',
      'video/av01': 'AV1',
      'vp09': 'VP9',
      'video/x-vnd.on2.vp9': 'VP9',
      'vp08': 'VP8',
      'video/x-vnd.on2.vp8': 'VP8',
      'mp4v': 'MPEG-4 Part 2',
      'video/mp4v-es': 'MPEG-4 Part 2',
      'ap4h': 'ProRes 4444',
      'apch': 'ProRes 422 HQ',
      'apcn': 'ProRes 422',
      'apcs': 'ProRes 422 LT',
      'apco': 'ProRes 422 Proxy',
      'mp4a': 'AAC',
      'aac': 'AAC',
      'audio/mp4a-latm': 'AAC',
      '.mp3': 'MP3',
      'audio/mpeg': 'MP3',
      'opus': 'Opus',
      'audio/opus': 'Opus',
      'audio/vorbis': 'Vorbis',
      'ac-3': 'Dolby Digital (AC-3)',
      'audio/ac3': 'Dolby Digital (AC-3)',
      'ec-3': 'Dolby Digital Plus',
      'audio/eac3': 'Dolby Digital Plus',
      'alac': 'Apple Lossless',
      'audio/alac': 'Apple Lossless',
      'flac': 'FLAC',
      'audio/flac': 'FLAC',
      'lpcm': 'PCM',
      'audio/raw': 'PCM',
      'audio/amr-wb': 'AMR-WB',
      'audio/3gpp': 'AMR-NB',
    };
    return names[r] ?? raw.trim();
  }
}
