import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/notifications/reminders.dart';
import '../../core/providers.dart';
import 'data/backup_archive.dart';
import 'data/backup_service.dart';
import 'data/backup_settings.dart';

@immutable
class BackupState {
  const BackupState({this.lastBackupAt, this.busy = false, this.progress});

  final DateTime? lastBackupAt;
  final bool busy;
  final String? progress;
}

final backupControllerProvider = NotifierProvider<BackupController, BackupState>(BackupController.new);

class BackupController extends Notifier<BackupState> {
  late BackupSettings _settings;

  @override
  BackupState build() {
    _settings = BackupSettings(ref.watch(preferencesProvider));
    return BackupState(lastBackupAt: _settings.lastBackupAt);
  }

  Future<BackupService> _service() async =>
      BackupService(ref.read(postsRepositoryProvider), await getTemporaryDirectory());

  void _busy(String? label) =>
      state = BackupState(lastBackupAt: _settings.lastBackupAt, busy: label != null, progress: label);

  /// Packs every post and file into one backup file, ready to share or save.
  Future<File> create() async {
    _busy('Packing your posts');
    try {
      return await (await _service()).create();
    } finally {
      _busy(null);
    }
  }

  /// Call after the user saved or sent the backup file somewhere.
  Future<void> markBackedUp() async {
    await _settings.setLastBackupAt(DateTime.now());
    _busy(null);
  }

  Future<BackupContents> open(File file) => BackupArchive.read(file);

  Future<int> restore(BackupContents contents, {Set<DateTime>? days}) async {
    _busy('Restoring');
    try {
      final count = await (await _service()).restore(contents, days: days);
      await Reminders.instance.syncAll(await ref.read(postsRepositoryProvider).getAll());
      return count;
    } finally {
      _busy(null);
    }
  }
}
