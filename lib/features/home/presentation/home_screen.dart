import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/providers.dart';
import '../../../core/theme/pc_tokens.dart';
import '../../../core/utils/formatting.dart';
import '../../../core/widgets/widgets.dart';
import '../../backup/backup_controller.dart';
import '../../posts/domain/post.dart';
import '../../posts/presentation/widgets/post_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(postsProvider);
    final backup = ref.watch(backupControllerProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: PcHeader(
                title: 'Postcrate',
                showMark: true,
                actions: [
                  PcIconButton(icon: CupertinoIcons.plus, label: 'New post', onTap: () => context.push(Routes.newPost)),
                ],
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(PcSpace.gutter, 0, PcSpace.gutter, PcBottomBar.contentInset(context)),
              sliver: posts.when(
                loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
                error: (e, _) => SliverToBoxAdapter(
                  child: PcEmptyState(title: "Couldn't load your posts", body: 'Restart the app and try again.'),
                ),
                data: (all) => SliverList.list(children: _content(context, all, backup)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _content(BuildContext context, List<Post> all, BackupState backup) {
    final drafts = all.where((p) => p.status == PostStatus.draft).length;
    final active = all.where((p) => p.status != PostStatus.archived).toList();
    final recent = [...active]..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    final now = DateTime.now();
    final upcoming = all.where((p) => p.reminderAt != null && p.reminderAt!.isAfter(now)).toList()
      ..sort((a, b) => a.reminderAt!.compareTo(b.reminderAt!));
    final pinned = active.where((p) => p.pinned).toList();

    final checklist = <(String, bool, VoidCallback)>[
      ('Write your first post', all.isNotEmpty, () => context.push(Routes.newPost)),
      ('Share a post to an app', all.any((p) => p.shareHistory.isNotEmpty), () => context.go(Routes.library)),
      ('Make a first backup', backup.lastBackupAt != null, () => context.go(Routes.backup)),
    ];
    final checklistDone = checklist.every((c) => c.$2);

    return [
      Row(
        children: [
          Expanded(
            child: _Stat(value: '${all.length}', label: 'Posts', onTap: () => context.go(Routes.library)),
          ),
          const SizedBox(width: PcSpace.xs),
          Expanded(
            child: _Stat(value: '$drafts', label: 'Drafts', onTap: () => context.go(Routes.library)),
          ),
          const SizedBox(width: PcSpace.xs),
          Expanded(
            child: _Stat(
              value: agoLabel(backup.lastBackupAt),
              label: 'Last backup',
              onTap: () => context.go(Routes.backup),
            ),
          ),
        ],
      ),
      if (!checklistDone) ...[
        const PcSectionLabel('Get set up'),
        PcGroup(
          children: [
            for (final (label, done, action) in checklist)
              PcRow(
                title: label,
                titleColor: done ? context.pc.textTertiary : null,
                leading: Icon(
                  done ? CupertinoIcons.checkmark_circle : CupertinoIcons.circle,
                  size: 22,
                  color: done ? context.pc.success : context.pc.textTertiary,
                  semanticLabel: done ? 'Done' : 'Not done',
                ),
                onTap: done ? null : action,
              ),
          ],
        ),
      ],
      if (upcoming.isNotEmpty) ...[
        const PcSectionLabel('Coming up'),
        PcGroup(
          children: [
            for (final p in upcoming.take(3))
              PcRow(
                title: p.preview,
                subtitle: dateTimeLabel(p.reminderAt!),
                leading: const PcIconTile(icon: CupertinoIcons.bell),
                onTap: () => context.push(Routes.post(p.id)),
              ),
          ],
        ),
      ],
      if (pinned.isNotEmpty) ...[
        const PcSectionLabel('Pinned'),
        for (final p in pinned.take(3)) ...[PostCard(post: p, showShare: true), const SizedBox(height: PcSpace.xs)],
      ],
      PcSectionLabel(
        'Recent',
        trailing: all.isEmpty
            ? null
            : PcTap(
                onTap: () => context.go(Routes.library),
                semanticLabel: 'See all posts',
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text('See all', style: context.text.labelMedium!.copyWith(color: context.pc.textPrimary)),
                ),
              ),
      ),
      if (recent.isEmpty)
        PcEmptyState(
          icon: CupertinoIcons.square_pencil,
          title: 'Start your first post',
          body: 'Write once, keep it here, and share it to any app on your phone.',
          actionLabel: 'New post',
          onAction: () => context.push(Routes.newPost),
        )
      else
        for (final p in recent.where((p) => !p.pinned).take(5)) ...[
          PostCard(post: p, showShare: true),
          const SizedBox(height: PcSpace.xs),
        ],
    ];
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label, this.onTap});

  final String value;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return PcCard(
      onTap: onTap,
      semanticLabel: '$label $value',
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: context.text.titleLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Text(label, style: context.text.labelMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
