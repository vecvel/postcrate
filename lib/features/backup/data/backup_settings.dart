import 'package:shared_preferences/shared_preferences.dart';

/// Remembers when the last backup file was made.
class BackupSettings {
  BackupSettings(this._prefs);

  final SharedPreferencesWithCache _prefs;

  static const _kLast = 'backup.lastAt';
  static const keys = {_kLast};

  static Future<SharedPreferencesWithCache> open() =>
      SharedPreferencesWithCache.create(cacheOptions: const SharedPreferencesWithCacheOptions(allowList: keys));

  DateTime? get lastBackupAt {
    final ms = _prefs.getInt(_kLast);
    return ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms);
  }

  Future<void> setLastBackupAt(DateTime t) => _prefs.setInt(_kLast, t.millisecondsSinceEpoch);
}
