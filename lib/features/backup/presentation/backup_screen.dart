import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/theme/pc_tokens.dart';
import '../../../core/utils/formatting.dart';
import '../../../core/widgets/widgets.dart';
import '../../posts/domain/post.dart';
import '../../share/native/native_share.dart';
import '../../share/share_providers.dart';
import '../backup_controller.dart';
import '../data/backup_archive.dart';

class BackupScreen extends ConsumerWidget {
  const BackupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(backupControllerProvider);
    final posts = ref.watch(postsProvider).value ?? const <Post>[];
    final files = posts.expand((p) => p.attachments).toList();
    final bytes = files.fold<int>(0, (sum, a) => sum + a.sizeBytes);
    final changed = s.lastBackupAt == null
        ? posts.length
        : posts.where((p) => p.updatedAt.isAfter(s.lastBackupAt!)).length;
    final c = context.pc;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.only(bottom: PcBottomBar.contentInset(context)),
          children: [
            const PcHeader(title: 'Backup'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: PcSpace.gutter),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PcCard(
                    padding: const EdgeInsets.all(PcSpace.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const PcIconTile(icon: CupertinoIcons.archivebox, size: 40),
                        const SizedBox(height: PcSpace.sm),
                        Text('Back up to a file', style: context.text.titleMedium),
                        const SizedBox(height: 4),
                        Text(
                          'Packs every post and file into one backup file. Save it to Files, Google Drive, iCloud Drive or a computer.',
                          style: context.text.bodyMedium,
                        ),
                        const SizedBox(height: PcSpace.md),
                        Text(
                          '${posts.length} posts · ${files.length} files · ${fileSizeLabel(bytes)}',
                          style: context.text.bodySmall,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          s.lastBackupAt == null
                              ? 'No backup yet'
                              : 'Last backup ${dateTimeLabel(s.lastBackupAt!)}'
                                    '${changed == 0 ? '' : ' · $changed changed since'}',
                          style: context.text.bodySmall!.copyWith(
                            color: s.lastBackupAt == null || changed > 0 ? c.warning : c.textTertiary,
                          ),
                        ),
                        const SizedBox(height: PcSpace.md),
                        Builder(
                          builder: (buttonContext) => PcButton(
                            label: s.busy && s.progress != null ? s.progress! : 'Create backup',
                            icon: CupertinoIcons.arrow_down_doc,
                            expand: true,
                            loading: s.busy,
                            onPressed: posts.isEmpty ? null : () => _backUp(buttonContext, ref),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const PcSectionLabel('Restore'),
                  PcCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Open a Postcrate backup file to bring back everything, or only the days you pick. '
                          'Posts you edited after the backup are kept, and nothing is deleted.',
                          style: context.text.bodyMedium,
                        ),
                        const SizedBox(height: PcSpace.md),
                        PcButton.secondary(
                          label: 'Choose backup file',
                          icon: CupertinoIcons.folder,
                          expand: true,
                          onPressed: s.busy ? null : () => _restore(context, ref),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: PcSpace.xl),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      'Postcrate has no accounts and no servers. Your posts live on this device, and backups go only '
                      'where you save them.',
                      style: context.text.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _backUp(BuildContext context, WidgetRef ref) async {
    final ctrl = ref.read(backupControllerProvider.notifier);
    final box = context.findRenderObject() as RenderBox?;
    final origin = box == null || !box.hasSize ? null : box.localToGlobal(Offset.zero) & box.size;
    try {
      final file = await ctrl.create();
      final result = await ref
          .read(nativeShareProvider)
          .share(
            text: '',
            files: [NativeShareFile(path: file.path, mimeType: 'application/zip', name: file.uri.pathSegments.last)],
            origin: origin,
          );
      if (result.status == NativeShareStatus.completed) {
        await ctrl.markBackedUp();
        if (context.mounted) showPcToast(context, 'Backup saved');
      }
    } catch (_) {
      if (context.mounted) showPcToast(context, "Couldn't create the backup. Check free space and try again.");
    }
  }

  Future<void> _restore(BuildContext context, WidgetRef ref) async {
    final ctrl = ref.read(backupControllerProvider.notifier);
    String? path;
    try {
      final picked = await FilePicker.pickFiles(type: FileType.custom, allowedExtensions: const ['zip']);
      path = picked.firstOrNull?.path;
    } catch (_) {
      if (context.mounted) showPcToast(context, "Couldn't open the file picker.");
      return;
    }
    if (path == null) return;
    BackupContents contents;
    try {
      contents = await ctrl.open(File(path));
    } on BackupException catch (e) {
      if (context.mounted) showPcToast(context, e.message);
      return;
    } catch (_) {
      if (context.mounted) showPcToast(context, "Couldn't read that backup file.");
      return;
    }
    if (!context.mounted) return;
    final count = await showPcSheet<int>(
      context,
      title: 'Restore backup',
      builder: (_) => _RestoreBody(contents: contents),
    );
    if (count != null && context.mounted) {
      showPcToast(context, count == 0 ? 'Everything was already up to date' : 'Restored $count posts');
    }
  }
}

class _RestoreBody extends ConsumerStatefulWidget {
  const _RestoreBody({required this.contents});

  final BackupContents contents;

  @override
  ConsumerState<_RestoreBody> createState() => _RestoreBodyState();
}

class _RestoreBodyState extends ConsumerState<_RestoreBody> {
  final _days = <DateTime>{};
  bool _running = false;

  @override
  Widget build(BuildContext context) {
    final b = widget.contents;
    final days = b.days;
    final all = _days.isEmpty;
    final total = all ? b.posts.length : days.where((d) => _days.contains(d.$1)).fold<int>(0, (s, d) => s + d.$2);
    final c = context.pc;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, PcSpace.md),
          child: Text(
            'Made ${dateTimeLabel(b.createdAt)} · ${b.posts.length} posts · ${b.mediaEntries.length} files',
            style: context.text.bodyMedium,
          ),
        ),
        PcGroup(
          children: [
            PcRow(
              title: 'Everything',
              subtitle: '${b.posts.length} posts',
              trailing: _check(context, all),
              onTap: () => setState(_days.clear),
            ),
          ],
        ),
        if (days.length > 1) ...[
          const PcSectionLabel('Or only posts made on'),
          PcGroup(
            children: [
              for (final (day, n) in days)
                PcRow(
                  title: dayLabel(day),
                  subtitle: '$n post${n == 1 ? '' : 's'}',
                  trailing: _check(context, _days.contains(day)),
                  onTap: () => setState(() => _days.contains(day) ? _days.remove(day) : _days.add(day)),
                ),
            ],
          ),
        ],
        const SizedBox(height: PcSpace.lg),
        PcButton(
          label: 'Restore $total post${total == 1 ? '' : 's'}',
          expand: true,
          loading: _running,
          onPressed: total == 0
              ? null
              : () async {
                  setState(() => _running = true);
                  try {
                    final n = await ref
                        .read(backupControllerProvider.notifier)
                        .restore(b, days: all ? null : Set.of(_days));
                    if (context.mounted) Navigator.of(context).pop(n);
                  } catch (_) {
                    if (!context.mounted) return;
                    setState(() => _running = false);
                    showPcToast(context, "Restore didn't finish. Try again.");
                  }
                },
        ),
        if (b.posts.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: PcSpace.sm),
            child: Text('This backup has no posts.', style: context.text.bodySmall!.copyWith(color: c.textTertiary)),
          ),
      ],
    );
  }

  Widget _check(BuildContext context, bool on) => Icon(
    on ? CupertinoIcons.checkmark_circle : CupertinoIcons.circle,
    size: 22,
    color: on ? context.pc.textPrimary : context.pc.textTertiary,
  );
}
