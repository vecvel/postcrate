import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers.dart';
import '../../../../core/theme/pc_tokens.dart';
import '../../../../core/utils/formatting.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/post.dart';
import '../../domain/social_app.dart';
import '../../domain/video_fit.dart';
import 'attachment_thumb.dart';
import 'media_details.dart';

sealed class AttachmentResult {
  const AttachmentResult();
}

class AttachmentEdit extends AttachmentResult {
  const AttachmentEdit(this.attachment);
  final Attachment attachment;
}

class AttachmentMove extends AttachmentResult {
  const AttachmentMove(this.delta);
  final int delta;
}

class AttachmentRemove extends AttachmentResult {
  const AttachmentRemove();
}

Future<AttachmentResult?> showAttachmentSheet(
  BuildContext context, {
  required Attachment attachment,
  required int index,
  required int count,
  List<SocialApp> targets = const [],
}) {
  return showPcSheet<AttachmentResult>(
    context,
    title: attachment.fileName,
    builder: (_) => _AttachmentBody(attachment: attachment, index: index, count: count, targets: targets),
  );
}

class _AttachmentBody extends ConsumerStatefulWidget {
  const _AttachmentBody({required this.attachment, required this.index, required this.count, required this.targets});

  final Attachment attachment;
  final int index;
  final int count;
  final List<SocialApp> targets;

  @override
  ConsumerState<_AttachmentBody> createState() => _AttachmentBodyState();
}

class _AttachmentBodyState extends ConsumerState<_AttachmentBody> {
  late Attachment _a = widget.attachment;
  late final _alt = TextEditingController(text: widget.attachment.altText ?? '');
  late CropAspect _crop = widget.attachment.crop;
  double? _frameMs;
  bool _renderingFrame = false;

  @override
  void initState() {
    super.initState();
    // Attachments added before the media probe existed get their details now.
    ref.read(mediaStoreProvider).refreshInfo(_a).then((a) {
      if (mounted && a.mediaInfo != null) setState(() => _a = a);
    });
  }

  @override
  void dispose() {
    _alt.dispose();
    super.dispose();
  }

  int? get _durationMs => _a.mediaInfo?.durationMs ?? _a.durationMs;

  Future<void> _setCover(double ms) async {
    setState(() => _renderingFrame = true);
    final rel = await ref.read(mediaStoreProvider).coverFrame(_a, ms.round());
    if (!mounted) return;
    setState(() {
      _renderingFrame = false;
      if (rel != null) _a = _a.copyWith(coverFrameMs: () => ms.round(), thumbRelativePath: () => rel);
    });
  }

  @override
  Widget build(BuildContext context) {
    final a = _a;
    final c = context.pc;
    final visual = a.kind == AttachmentKind.image || a.kind == AttachmentKind.video;
    final duration = _durationMs;
    final isVideo = a.kind == AttachmentKind.video;
    final checked = widget.targets.any((t) => t.videoLimits != null);
    final notes = [
      if (isVideo) ...VideoFit.check(a, widget.targets),
      if (isVideo && !checked) const FitNote(FitLevel.info, 'Pick apps for this post to check their video limits.'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(child: AttachmentThumb(attachment: a, size: 148)),
        if (a.kind == AttachmentKind.video && duration != null && duration > 0) ...[
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 2, top: PcSpace.md),
            child: Row(
              children: [
                Expanded(child: Text('Cover frame', style: context.text.labelMedium)),
                if (_renderingFrame)
                  const CupertinoActivityIndicator(radius: 7)
                else
                  Text(
                    durationLabel((_frameMs ?? (a.coverFrameMs ?? 0).toDouble()).round()),
                    style: context.text.labelMedium,
                  ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: CupertinoSlider(
              value: (_frameMs ?? (a.coverFrameMs ?? 0).toDouble()).clamp(0, duration.toDouble()),
              max: duration.toDouble(),
              activeColor: c.textPrimary,
              thumbColor: c.card,
              onChanged: (v) => setState(() => _frameMs = v),
              onChangeEnd: _setCover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text('Used as the preview for this video in Postcrate.', style: context.text.bodySmall),
          ),
        ],
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6, top: PcSpace.md),
          child: Text('Alt text', style: context.text.labelMedium),
        ),
        PcTextField(controller: _alt, hint: 'Describe this for people using screen readers', minLines: 2, maxLines: 4),
        if (visual) ...[
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 6, top: PcSpace.md),
            child: Text('Crop for', style: context.text.labelMedium),
          ),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final c in CropAspect.values)
                PcChip(label: c.label, selected: _crop == c, onTap: () => setState(() => _crop = c)),
            ],
          ),
        ],
        const PcSectionLabel('Details'),
        MediaDetails(attachment: a),
        if (notes.isNotEmpty) ...[
          PcSectionLabel(checked ? 'For your apps' : 'Compatibility'),
          PcGroup(
            children: [
              for (final n in notes)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: PcSpace.cardPadding, vertical: 11),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        switch (n.level) {
                          FitLevel.ok => CupertinoIcons.checkmark_circle,
                          FitLevel.info => CupertinoIcons.info_circle,
                          FitLevel.warning => CupertinoIcons.exclamationmark_circle,
                        },
                        size: 18,
                        color: switch (n.level) {
                          FitLevel.ok => c.success,
                          FitLevel.info => c.textTertiary,
                          FitLevel.warning => c.warning,
                        },
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Text(n.text, style: context.text.bodyMedium)),
                    ],
                  ),
                ),
            ],
          ),
        ],
        const SizedBox(height: PcSpace.lg),
        PcButton(
          label: 'Done',
          expand: true,
          onPressed: () =>
              Navigator.of(context).pop(AttachmentEdit(a.copyWith(altText: _alt.text.trim(), crop: _crop))),
        ),
        const SizedBox(height: PcSpace.xs),
        Row(
          children: [
            Expanded(
              child: PcButton.secondary(
                label: 'Move earlier',
                icon: CupertinoIcons.arrow_left,
                onPressed: widget.index == 0 ? null : () => Navigator.of(context).pop(const AttachmentMove(-1)),
              ),
            ),
            const SizedBox(width: PcSpace.xs),
            Expanded(
              child: PcButton.secondary(
                label: 'Move later',
                icon: CupertinoIcons.arrow_right,
                onPressed: widget.index >= widget.count - 1
                    ? null
                    : () => Navigator.of(context).pop(const AttachmentMove(1)),
              ),
            ),
          ],
        ),
        const SizedBox(height: PcSpace.xs),
        PcButton.secondary(
          label: 'Remove from post',
          icon: CupertinoIcons.trash,
          expand: true,
          onPressed: () => Navigator.of(context).pop(const AttachmentRemove()),
        ),
      ],
    );
  }
}
