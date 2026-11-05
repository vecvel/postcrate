import 'package:flutter/cupertino.dart';

import '../../../../core/theme/pc_tokens.dart';
import '../../../../core/utils/formatting.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/media_info.dart';
import '../../domain/post.dart';

/// Label and value rows describing an attachment: type, format, codecs,
/// resolution, duration, frame rate, bitrate, audio, pages and size.
List<(String, String)> mediaDetailRows(Attachment a) {
  final i = a.mediaInfo;
  final rows = <(String, String)>[
    ('Type', a.kind.label),
    ('Format', [i?.container ?? a.extension, a.mimeType].join(' · ')),
  ];
  if (i?.videoCodec != null) rows.add(('Video codec', _codec(i!.videoCodec!)));
  if (i?.audioCodec != null) rows.add(('Audio codec', _codec(i!.audioCodec!)));
  final size = i?.displaySize ?? (a.width != null && a.height != null ? (a.width!, a.height!) : null);
  if (size != null) {
    final shape = size.$1 == size.$2 ? 'square' : (size.$2 > size.$1 ? 'portrait' : 'landscape');
    rows.add(('Resolution', '${size.$1} × ${size.$2} · ${aspectLabel(size.$1, size.$2)} $shape'));
  }
  final ms = i?.durationMs ?? a.durationMs;
  if (ms != null) rows.add(('Duration', durationLabel(ms)));
  if (i?.frameRate != null) rows.add(('Frame rate', '${_fps(i!.frameRate!)} fps'));
  if (i?.bitrate != null) rows.add(('Bitrate', bitrateLabel(i!.bitrate!)));
  if (i?.sampleRate != null || i?.channels != null) {
    rows.add((
      'Audio',
      [
        if (i!.sampleRate != null) '${(i.sampleRate! / 1000).toStringAsFixed(i.sampleRate! % 1000 == 0 ? 0 : 1)} kHz',
        if (i.channels != null) _channels(i.channels!),
      ].join(' · '),
    ));
  }
  if (i?.colorSpace != null || i?.hdr == true) {
    rows.add(('Color', [if (i!.colorSpace != null) i.colorSpace!, if (i.hdr == true) 'HDR'].join(' · ')));
  }
  if (i?.rotation != null && i!.rotation != 0) rows.add(('Rotation', '${i.rotation}°'));
  if (i?.pageCount != null) {
    rows.add((a.kind == AttachmentKind.image ? 'Frames' : 'Pages', '${i!.pageCount}'));
  }
  rows.add(('File size', '${fileSizeLabel(a.sizeBytes)} (${_grouped(a.sizeBytes)} bytes)'));
  return rows;
}

String _codec(String raw) {
  final label = MediaInfo.codecLabel(raw);
  return label == raw ? raw : '$label · $raw';
}

String _fps(double f) => (f - f.round()).abs() < 0.01 ? '${f.round()}' : f.toStringAsFixed(2);

String _channels(int c) => switch (c) {
  1 => 'Mono',
  2 => 'Stereo',
  6 => '5.1 surround',
  8 => '7.1 surround',
  _ => '$c channels',
};

String _grouped(int n) => n.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');

/// Grouped list of [mediaDetailRows].
class MediaDetails extends StatelessWidget {
  const MediaDetails({super.key, required this.attachment});

  final Attachment attachment;

  @override
  Widget build(BuildContext context) {
    return PcGroup(
      children: [
        for (final (label, value) in mediaDetailRows(attachment))
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: PcSpace.cardPadding, vertical: 11),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 96, child: Text(label, style: context.text.bodyMedium)),
                const SizedBox(width: PcSpace.sm),
                Expanded(
                  child: Text(value, style: context.text.bodyMedium!.copyWith(color: context.pc.textPrimary)),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
