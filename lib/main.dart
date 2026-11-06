import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'app/router.dart';
import 'core/database/app_database.dart';
import 'core/notifications/reminders.dart';
import 'core/providers.dart';
import 'core/storage/media_store.dart';
import 'features/backup/data/backup_settings.dart';
import 'features/posts/data/posts_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();
  final media = await MediaStore.open();
  final prefs = await BackupSettings.open();

  final reminders = Reminders.instance;
  await reminders.init();
  reminders.onOpen = (postId) => appRouter.push(Routes.post(postId));

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        mediaStoreProvider.overrideWithValue(media),
        preferencesProvider.overrideWithValue(prefs),
      ],
      child: const PostcrateApp(),
    ),
  );

  WidgetsBinding.instance.addPostFrameCallback((_) async {
    final launchedFrom = await reminders.launchPostId();
    if (launchedFrom != null) appRouter.push(Routes.post(launchedFrom));
    unawaited(PostsRepository(db, media).getAll().then(reminders.syncAll));
  });
}
