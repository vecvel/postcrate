import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/notifications/reminders.dart';
import '../../../../core/providers.dart';
import '../../../../core/theme/pc_tokens.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../share/share_providers.dart';
import '../../../share/share_service.dart';
import '../../domain/post.dart';
import '../../domain/social_app.dart';

Future<void> sharePost(BuildContext context, WidgetRef ref, Post post, {SocialApp? app}) async {
  if (post.isEmpty) {
    showPcToast(context, 'Add some text or media before sharing.');
    return;
  }
  final report = await ref.read(shareServiceProvider).share(context, post, app: app);
  if (!context.mounted) return;
  switch (report.outcome) {
    case ShareOutcome.shared || ShareOutcome.openedComposer:
      showPcToast(
        context,
        report.captionOnClipboard
            ? 'Caption copied. Paste it if ${report.app!.label} leaves it empty.'
            : 'Shared. Copy the post link in the app to keep track of it.',
      );
    case ShareOutcome.unavailable:
      showPcToast(context, "Sharing isn't available on this device.");
    case ShareOutcome.dismissed:
      break;
  }
}

/// Opens a saved post link in its native app, or the browser.
Future<void> openPostLink(BuildContext context, WidgetRef ref, String url) async {
  final uri = Uri.tryParse(url);
  final ok = uri != null && await ref.read(shareServiceProvider).open(uri);
  if (!ok && context.mounted) showPcToast(context, "Couldn't open that link.");
}

Future<void> confirmDeletePost(BuildContext context, WidgetRef ref, Post post, {VoidCallback? onDeleted}) async {
  final ok = await showPcConfirm(
    context,
    title: 'Delete post',
    message: post.attachments.isEmpty
        ? 'This post will be removed from this device.'
        : 'This post and its ${post.attachments.length} attachment${post.attachments.length == 1 ? '' : 's'} will be removed from this device. Backup files you saved still have it.',
    confirmLabel: 'Delete post',
    destructive: true,
  );
  if (!ok) return;
  await ref.read(postsRepositoryProvider).delete(post.id);
  await Reminders.instance.cancel(post.id);
  onDeleted?.call();
}

Future<void> showPostActions(BuildContext context, WidgetRef ref, Post post) async {
  final repo = ref.read(postsRepositoryProvider);
  await showPcSheet<void>(
    context,
    title: 'Post',
    builder: (ctx) => PcGroup(
      children: [
        PcRow(
          title: 'Share',
          leading: const PcIconTile(icon: CupertinoIcons.share),
          onTap: () {
            Navigator.of(ctx).pop();
            sharePost(context, ref, post);
          },
        ),
        PcRow(
          title: 'Edit',
          leading: const PcIconTile(icon: CupertinoIcons.pencil),
          onTap: () {
            Navigator.of(ctx).pop();
            context.push(Routes.post(post.id));
          },
        ),
        PcRow(
          title: 'Duplicate',
          leading: const PcIconTile(icon: CupertinoIcons.doc_on_doc),
          onTap: () async {
            Navigator.of(ctx).pop();
            await repo.duplicate(post);
            if (context.mounted) showPcToast(context, 'Duplicated as a draft');
          },
        ),
        PcRow(
          title: post.pinned ? 'Unpin' : 'Pin',
          leading: const PcIconTile(icon: CupertinoIcons.pin),
          onTap: () async {
            Navigator.of(ctx).pop();
            await repo.save(post.copyWith(pinned: !post.pinned, updatedAt: DateTime.now()));
          },
        ),
        PcRow(
          title: post.status == PostStatus.archived ? 'Move to drafts' : 'Archive',
          leading: const PcIconTile(icon: CupertinoIcons.archivebox),
          onTap: () async {
            Navigator.of(ctx).pop();
            final next = post.status == PostStatus.archived ? PostStatus.draft : PostStatus.archived;
            await repo.save(post.copyWith(status: next, updatedAt: DateTime.now()));
          },
        ),
        PcRow(
          title: 'Delete',
          titleColor: ctx.pc.danger,
          leading: PcIconTile(icon: CupertinoIcons.trash, color: ctx.pc.danger),
          onTap: () {
            Navigator.of(ctx).pop();
            confirmDeletePost(context, ref, post);
          },
        ),
      ],
    ),
  );
}
