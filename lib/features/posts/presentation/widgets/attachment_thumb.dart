import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers.dart';
import '../../../../core/theme/pc_tokens.dart';
import '../../../../core/utils/formatting.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/post.dart';

IconData attachmentIcon(AttachmentKind kind) => switch (kind) {
  AttachmentKind.image => CupertinoIcons.photo,
  AttachmentKind.video => CupertinoIcons.film,
  AttachmentKind.audio => CupertinoIcons.music_note,
  AttachmentKind.document => CupertinoIcons.doc_text,
};

/// Square preview of an attachment: the image itself, a video frame or PDF
/// page, or a kind icon with its file extension. Video and audio show their
/// duration.
class AttachmentThumb extends ConsumerStatefulWidget {
  const AttachmentThumb({super.key, required this.attachment, this.size = PcSize.mediaThumb});

  final Attachment attachment;
  final double size;

  @override
  ConsumerState<AttachmentThumb> createState() => _AttachmentThumbState();
}

class _AttachmentThumbState extends ConsumerState<AttachmentThumb> {
  Future<String?>? _thumb;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(AttachmentThumb old) {
    super.didUpdateWidget(old);
    if (old.attachment.thumbRelativePath != widget.attachment.thumbRelativePath ||
        old.attachment.id != widget.attachment.id) {
      _load();
    }
  }

  void _load() {
    final a = widget.attachment;
    final previewable =
        a.kind == AttachmentKind.video || (a.kind == AttachmentKind.document && a.mimeType == 'application/pdf');
    _thumb = previewable ? ref.read(mediaStoreProvider).ensureThumbnail(a) : null;
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.attachment;
    final size = widget.size;
    final c = context.pc;
    final media = ref.watch(mediaStoreProvider);
    final cacheWidth = (size * MediaQuery.devicePixelRatioOf(context)).round();

    final fallback = Container(
      color: PcSurface.fieldColor(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(attachmentIcon(a.kind), size: size * 0.32, color: c.textPrimary),
          if (size >= 48) ...[
            const SizedBox(height: 3),
            Text(a.extension, style: context.text.labelSmall!.copyWith(color: c.textSecondary)),
          ],
        ],
      ),
    );

    Widget body;
    if (a.kind == AttachmentKind.image) {
      body = Image.file(
        media.resolve(a.relativePath),
        fit: BoxFit.cover,
        cacheWidth: cacheWidth,
        errorBuilder: (_, _, _) => fallback,
      );
    } else if (_thumb != null) {
      body = FutureBuilder<String?>(
        future: _thumb,
        builder: (_, snap) => snap.data == null
            ? fallback
            : Image.file(
                media.resolve(snap.data!),
                key: ValueKey(snap.data),
                fit: BoxFit.cover,
                cacheWidth: cacheWidth,
                errorBuilder: (_, _, _) => fallback,
              ),
      );
    } else {
      body = fallback;
    }

    final ms = a.mediaInfo?.durationMs ?? a.durationMs;
    final showDuration = ms != null && size >= 48 && (a.kind == AttachmentKind.video || a.kind == AttachmentKind.audio);

    return Semantics(
      image: true,
      label: a.altText?.isNotEmpty == true ? a.altText : '${a.kind.label} ${a.fileName}',
      child: SizedBox.square(
        dimension: size,
        child: ClipRSuperellipse(
          borderRadius: BorderRadius.all(Radius.circular(size * 0.2)),
          child: Stack(
            fit: StackFit.expand,
            children: [
              body,
              if (showDuration)
                Positioned(
                  right: 4,
                  bottom: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.62),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      durationLabel(ms),
                      style: context.text.labelSmall!.copyWith(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
