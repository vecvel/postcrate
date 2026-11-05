import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:postcrate/app/app.dart';
import 'package:postcrate/core/database/app_database.dart';
import 'package:postcrate/core/providers.dart';
import 'package:postcrate/core/storage/media_store.dart';
import 'package:postcrate/features/backup/data/backup_settings.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  testWidgets('opens on Home and moves between tabs and the editor', timeout: const Timeout(Duration(seconds: 60)), (
    tester,
  ) async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.empty();
    final db = AppDatabase(NativeDatabase.memory());
    final dir = Directory.systemTemp.createTempSync('postcrate_widget');
    final prefs = await tester.runAsync(BackupSettings.open);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          mediaStoreProvider.overrideWithValue(MediaStore.at(dir)),
          preferencesProvider.overrideWithValue(prefs!),
        ],
        child: const PostcrateApp(),
      ),
    );
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
    await tester.pumpAndSettle();

    expect(find.text('Postcrate'), findsOneWidget);
    expect(find.text('Start your first post'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Library'));
    await tester.pumpAndSettle();
    expect(find.text('Your library is empty'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Backup'));
    await tester.pumpAndSettle();
    expect(find.text('Back up to a file'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Home'));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('New post').first);
    // The editor loads from the database, which needs real async time; avoid
    // pumpAndSettle while its loading spinner animates.
    for (var i = 0; i < 40 && find.text('Post').evaluate().isEmpty; i++) {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(find.text('Post'), findsOneWidget);
    expect(find.text('New post'), findsWidgets);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(Duration.zero);
    dir.deleteSync(recursive: true);
  });
}
