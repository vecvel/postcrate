import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/providers.dart';
import '../../../core/theme/pc_tokens.dart';
import '../../../core/utils/formatting.dart';
import '../../../core/widgets/widgets.dart';
import '../../posts/domain/post.dart';
import '../incoming_share.dart';
import '../native/native_share.dart';

/// Where the shared item goes: a new post, or the post picked from the list.
sealed class _Choice {
  const _Choice();
}

class _NewPost extends _Choice {
  const _NewPost();
}

class _Existing extends _Choice {
  const _Existing(this.post);
  final Post post;
}

/// Asks whether something shared into Postcrate becomes a new post or joins
/// an existing one, then opens that post.
Future<void> showIncomingSheet(BuildContext context, WidgetRef ref, IncomingItem item) async {
  final ctrl = ref.read(incomingShareProvider.notifier);
  final posts = [...await ref.read(postsRepositoryProvider).getAll()]
    ..removeWhere((p) => p.status == PostStatus.archived)
    ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  if (!context.mounted) return;
  final text = item.text?.trim() ?? '';

  final choice = await showPcSheet<_Choice>(
    context,
    title: 'Save to Postcrate',
    builder: (ctx) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, PcSpace.sm),
          child: Text('${describeIncoming(item)} from another app.', style: ctx.text.bodyMedium),
        ),
        if (text.isNotEmpty)
          PcCard(
            child: Text(
              text,
              style: ctx.text.bodySmall!.copyWith(color: ctx.pc.textSecondary),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        const SizedBox(height: PcSpace.md),
        PcButton(
          label: 'New post',
          icon: CupertinoIcons.plus,
          expand: true,
          onPressed: () => Navigator.of(ctx).pop(const _NewPost()),
        ),
        if (posts.isNotEmpty) ...[
          const PcSectionLabel('Or add to a post'),
          PcGroup(
            children: [
              for (final p in posts.take(6))
                PcRow(
                  title: p.preview,
                  subtitle: 'Edited ${dateTimeLabel(p.updatedAt)}',
                  trailing: Icon(CupertinoIcons.chevron_right, size: 16, color: ctx.pc.textTertiary),
                  onTap: () => Navigator.of(ctx).pop(_Existing(p)),
                ),
            ],
          ),
        ],
        const SizedBox(height: PcSpace.md),
        PcButton.secondary(label: 'Discard', expand: true, onPressed: () => Navigator.of(ctx).pop()),
      ],
    ),
  );

  if (choice == null) {
    await ctrl.discard();
    if (context.mounted) showPcToast(context, 'Discarded');
    return;
  }
  if (context.mounted && item.files.isNotEmpty) showPcToast(context, 'Saving…');
  final saved = await ctrl.save(into: choice is _Existing ? choice.post : null);
  if (saved == null || !context.mounted) return;
  if (saved.skipped > 0) {
    showPcToast(context, '${saved.skipped} file${saved.skipped == 1 ? '' : 's'} skipped: type not supported.');
  }
  unawaited(context.push(Routes.post(saved.postId)));
}
