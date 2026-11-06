import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers.dart';
import '../../../../core/theme/pc_tokens.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/posts_repository.dart';
import '../../domain/post.dart';

/// Create, rename and delete collections.
Future<void> showCollectionsSheet(BuildContext context, WidgetRef ref) {
  return showPcSheet<void>(context, title: 'Collections', builder: (_) => const _CollectionsBody());
}

/// Asks for a collection name; validates empty and duplicate names.
Future<Collection?> promptNewCollection(BuildContext context, WidgetRef ref) async {
  final name = await _promptName(context, title: 'New collection', action: 'Create');
  if (name == null) return null;
  try {
    return await ref.read(postsRepositoryProvider).createCollection(name);
  } on DuplicateNameException catch (e) {
    if (context.mounted) showPcToast(context, e.toString());
    return null;
  }
}

Future<String?> _promptName(
  BuildContext context, {
  required String title,
  required String action,
  String initial = '',
}) {
  return showPcSheet<String>(
    context,
    title: title,
    builder: (_) => _NameForm(initial: initial, action: action),
  );
}

class _NameForm extends StatefulWidget {
  const _NameForm({required this.initial, required this.action});

  final String initial;
  final String action;

  @override
  State<_NameForm> createState() => _NameFormState();
}

class _NameFormState extends State<_NameForm> {
  late final _c = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _submit() {
    final v = _c.text.trim();
    if (v.isNotEmpty) Navigator.of(context).pop(v);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PcTextField(
          controller: _c,
          hint: 'Launch week',
          autofocus: true,
          textInputAction: TextInputAction.done,
          onChanged: (_) => setState(() {}),
          onSubmitted: (_) => _submit(),
        ),
        const SizedBox(height: PcSpace.md),
        PcButton(label: widget.action, expand: true, onPressed: _c.text.trim().isEmpty ? null : _submit),
      ],
    );
  }
}

class _CollectionsBody extends ConsumerWidget {
  const _CollectionsBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collections = ref.watch(collectionsProvider).value ?? const <Collection>[];
    final posts = ref.watch(postsProvider).value ?? const <Post>[];
    final repo = ref.read(postsRepositoryProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text('Group posts privately. Collections are never shared.', style: context.text.bodyMedium),
        ),
        const SizedBox(height: PcSpace.md),
        if (collections.isNotEmpty)
          PcGroup(
            children: [
              for (final c in collections)
                PcRow(
                  title: c.name,
                  subtitle: '${posts.where((p) => p.collectionIds.contains(c.id)).length} posts',
                  leading: const PcIconTile(icon: CupertinoIcons.folder),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PcIconButton(
                        icon: CupertinoIcons.pencil,
                        label: 'Rename ${c.name}',
                        onTap: () async {
                          final name = await _promptName(
                            context,
                            title: 'Rename collection',
                            action: 'Save',
                            initial: c.name,
                          );
                          if (name == null) return;
                          try {
                            await repo.renameCollection(c.id, name);
                          } on DuplicateNameException catch (e) {
                            if (context.mounted) showPcToast(context, e.toString());
                          }
                        },
                      ),
                      PcIconButton(
                        icon: CupertinoIcons.trash,
                        label: 'Delete ${c.name}',
                        color: context.pc.danger,
                        onTap: () async {
                          final count = posts.where((p) => p.collectionIds.contains(c.id)).length;
                          final ok = await showPcConfirm(
                            context,
                            title: 'Delete collection',
                            message: count == 0
                                ? '"${c.name}" will be deleted.'
                                : '"${c.name}" will be deleted. Its $count posts stay in your library.',
                            confirmLabel: 'Delete collection',
                            destructive: true,
                            typedConfirmation: count >= 10 ? c.name : null,
                          );
                          if (ok) await repo.deleteCollection(c.id);
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        const SizedBox(height: PcSpace.md),
        PcButton.secondary(
          label: 'New collection',
          icon: CupertinoIcons.plus,
          expand: true,
          onPressed: () => promptNewCollection(context, ref),
        ),
      ],
    );
  }
}
