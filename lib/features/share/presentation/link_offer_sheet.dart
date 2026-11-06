import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/pc_tokens.dart';
import '../../../core/utils/formatting.dart';
import '../../../core/widgets/widgets.dart';
import '../../posts/domain/social_app.dart';
import '../link_capture.dart';

/// Asks which post a captured link belongs to.
Future<void> showLinkOfferSheet(BuildContext context, WidgetRef ref, LinkOffer offer) async {
  final ctrl = ref.read(linkCaptureProvider.notifier);
  final platform = offer.link.app == SocialApp.other ? 'a link' : 'a link to a post on ${offer.link.app.label}';
  final picked = await showPcSheet<LinkCandidate>(
    context,
    title: 'Add this link to your post?',
    builder: (ctx) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, PcSpace.sm),
          child: Text(
            '${offer.fromShareSheet ? 'You shared' : 'You copied'} $platform. Save it to see where the post went and open it later.',
            style: ctx.text.bodyMedium,
          ),
        ),
        PcCard(
          child: Text(
            offer.link.url.toString(),
            style: ctx.text.bodySmall!.copyWith(color: ctx.pc.textSecondary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (offer.candidates.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: PcSpace.md),
            child: Text('Write a post first, then share this link again.', style: ctx.text.bodyMedium),
          )
        else ...[
          const PcSectionLabel('Choose the post'),
          PcGroup(
            children: [
              for (final c in offer.candidates)
                PcRow(
                  title: c.post.preview,
                  subtitle: c.share == null
                      ? 'Edited ${dateTimeLabel(c.post.updatedAt)}'
                      : '${c.share!.target} · ${dateTimeLabel(c.share!.sharedAt)}',
                  trailing: Icon(CupertinoIcons.chevron_right, size: 16, color: ctx.pc.textTertiary),
                  onTap: () => Navigator.of(ctx).pop(c),
                ),
            ],
          ),
        ],
        const SizedBox(height: PcSpace.md),
        PcButton.secondary(label: 'Not now', expand: true, onPressed: () => Navigator.of(ctx).pop()),
      ],
    ),
  );
  if (picked == null) {
    ctrl.dismiss();
    return;
  }
  await ctrl.accept(picked);
  if (context.mounted) showPcToast(context, 'Link saved');
}
