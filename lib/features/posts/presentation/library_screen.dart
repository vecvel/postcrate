import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/providers.dart';
import '../../../core/theme/pc_tokens.dart';
import '../../../core/utils/formatting.dart';
import '../../../core/widgets/widgets.dart';
import '../domain/post.dart';
import 'widgets/collections_sheet.dart';
import 'widgets/post_card.dart';

enum _Filter {
  all('All'),
  drafts('Drafts'),
  ready('Ready'),
  shared('Shared'),
  pinned('Pinned'),
  archived('Archived');

  const _Filter(this.label);
  final String label;

  bool matches(Post p) => switch (this) {
    _Filter.all => p.status != PostStatus.archived,
    _Filter.drafts => p.status == PostStatus.draft,
    _Filter.ready => p.status == PostStatus.ready,
    _Filter.shared => p.status == PostStatus.shared,
    _Filter.pinned => p.pinned,
    _Filter.archived => p.status == PostStatus.archived,
  };
}

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  final _search = TextEditingController();
  _Filter _filter = _Filter.all;
  String? _collectionId;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  bool _matchesQuery(Post p, String q) {
    if (q.isEmpty) return true;
    final hay = [
      p.title ?? '',
      p.body,
      ...p.threadParts,
      ...p.hashtags.map((h) => '#$h'),
      ...p.mentions.map((m) => '@$m'),
      p.notes ?? '',
      p.place?.name ?? '',
      for (final a in p.attachments) '${a.fileName} ${a.altText ?? ''}',
    ].join(' ').toLowerCase();
    return q.toLowerCase().split(RegExp(r'\s+')).every(hay.contains);
  }

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(postsProvider);
    final collections = ref.watch(collectionsProvider).value ?? const <Collection>[];
    if (_collectionId != null && !collections.any((c) => c.id == _collectionId)) _collectionId = null;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverToBoxAdapter(
              child: PcHeader(
                title: 'Library',
                actions: [
                  PcIconButton(
                    icon: CupertinoIcons.folder,
                    label: 'Collections',
                    onTap: () => showCollectionsSheet(context, ref),
                  ),
                  PcIconButton(icon: CupertinoIcons.plus, label: 'New post', onTap: () => context.push(Routes.newPost)),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: PcSpace.gutter),
                child: PcTextField(
                  controller: _search,
                  hint: 'Search posts',
                  prefixIcon: CupertinoIcons.search,
                  textInputAction: TextInputAction.search,
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 34 + PcSpace.sm * 2,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: PcSpace.gutter, vertical: PcSpace.sm),
                  children: [
                    for (final f in _Filter.values) ...[
                      PcChip(label: f.label, selected: _filter == f, onTap: () => setState(() => _filter = f)),
                      const SizedBox(width: 6),
                    ],
                    for (final c in collections) ...[
                      PcChip(
                        label: c.name,
                        icon: CupertinoIcons.folder,
                        selected: _collectionId == c.id,
                        onTap: () => setState(() => _collectionId = _collectionId == c.id ? null : c.id),
                      ),
                      const SizedBox(width: 6),
                    ],
                  ],
                ),
              ),
            ),
            ...posts.when(
              loading: () => const [SliverToBoxAdapter(child: SizedBox.shrink())],
              error: (e, _) => [
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(PcSpace.gutter),
                    child: PcEmptyState(title: "Couldn't load your posts", body: 'Restart the app and try again.'),
                  ),
                ),
              ],
              data: (all) => _list(context, all),
            ),
            SliverToBoxAdapter(child: SizedBox(height: PcBottomBar.contentInset(context))),
          ],
        ),
      ),
    );
  }

  List<Widget> _list(BuildContext context, List<Post> all) {
    final q = _search.text.trim();
    final visible =
        all
            .where(_filter.matches)
            .where((p) => _collectionId == null || p.collectionIds.contains(_collectionId))
            .where((p) => _matchesQuery(p, q))
            .toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    if (visible.isEmpty) {
      final filtered = q.isNotEmpty || _filter != _Filter.all || _collectionId != null;
      return [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: PcSpace.gutter),
          sliver: SliverToBoxAdapter(
            child: filtered
                ? const PcEmptyState(
                    icon: CupertinoIcons.search,
                    title: 'No matching posts',
                    body: 'Try another word or filter.',
                  )
                : PcEmptyState(
                    icon: CupertinoIcons.square_pencil,
                    title: 'Your library is empty',
                    body: 'Every post you write lands here, grouped by the day you made it.',
                    actionLabel: 'New post',
                    onAction: () => context.push(Routes.newPost),
                  ),
          ),
        ),
      ];
    }

    final groups = <DateTime, List<Post>>{};
    for (final p in visible) {
      (groups[dayOf(p.createdAt)] ??= []).add(p);
    }

    return [
      for (final entry in groups.entries)
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: PcSpace.gutter),
          sliver: SliverList.list(
            children: [
              PcSectionLabel(dayLabel(entry.key)),
              for (final p in entry.value) ...[PostCard(post: p), const SizedBox(height: PcSpace.xs)],
            ],
          ),
        ),
    ];
  }
}
