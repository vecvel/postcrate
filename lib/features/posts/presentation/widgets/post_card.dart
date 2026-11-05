import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/theme/pc_tokens.dart';
import '../../../../core/utils/formatting.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/post.dart';
import 'attachment_thumb.dart';
import 'post_actions.dart';

class PostCard extends ConsumerWidget {
  const PostCard({super.key, required this.post, this.showShare = false});

  final Post post;
  final bool showShare;

  String _meta() {
    final parts = <String>[post.status.label, timeLabel(post.createdAt)];
    final apps = post.shareHistory.map((s) => s.target).toSet();
    if (apps.isNotEmpty) parts.add('Shared to ${apps.length} app${apps.length == 1 ? '' : 's'}');
    return parts.join(' · ');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.pc;
    return PcCard(
      onTap: () => context.push(Routes.post(post.id)),
      onLongPress: () => showPostActions(context, ref, post),
      semanticLabel: post.preview,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if ((post.title ?? '').trim().isNotEmpty) ...[
            Text(post.title!.trim(), style: context.text.titleMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  post.preview,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.bodyLarge!.copyWith(
                    fontSize: 15,
                    height: 1.45,
                    color: post.body.trim().isEmpty ? c.textSecondary : c.textPrimary,
                  ),
                ),
              ),
              if (post.pinned) ...[
                const SizedBox(width: 8),
                Icon(CupertinoIcons.pin, size: 16, color: c.textTertiary, semanticLabel: 'Pinned'),
              ],
            ],
          ),
          if (post.attachments.isNotEmpty) ...[
            const SizedBox(height: 10),
            SizedBox(
              height: 52,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: post.attachments.length,
                separatorBuilder: (_, _) => const SizedBox(width: 6),
                itemBuilder: (_, i) => AttachmentThumb(attachment: post.attachments[i], size: 52),
              ),
            ),
          ],
          const SizedBox(height: 10),
          Text(_meta(), style: context.text.bodySmall),
          if (post.shareHistory.isNotEmpty) ...[const SizedBox(height: 10), _SharedOn(post: post)],
          if (showShare) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                PcButton(label: 'Share', compact: true, onPressed: () => sharePost(context, ref, post)),
                const SizedBox(width: 8),
                PcButton.secondary(label: 'Edit', compact: true, onPressed: () => context.push(Routes.post(post.id))),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Where the post went. Chips with a saved link open the live post in its app.
class _SharedOn extends ConsumerWidget {
  const _SharedOn({required this.post});

  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final byTarget = <String, ShareEvent>{};
    for (final s in post.shareHistory) {
      final current = byTarget[s.target];
      if (current == null || (current.liveUrl == null && s.liveUrl != null)) byTarget[s.target] = s;
    }
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final s in byTarget.values)
          PcChip(
            label: s.target,
            icon: s.liveUrl == null ? CupertinoIcons.paperplane : CupertinoIcons.arrow_up_right,
            onTap: s.liveUrl == null ? null : () => openPostLink(context, ref, s.liveUrl!),
          ),
      ],
    );
  }
}
