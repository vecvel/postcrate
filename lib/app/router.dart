import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../features/backup/presentation/backup_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/posts/presentation/library_screen.dart';
import '../features/posts/presentation/post_editor_screen.dart';
import 'shell/app_shell.dart';

abstract final class Routes {
  static const home = '/home';
  static const library = '/library';
  static const backup = '/backup';
  static const newPost = '/post/new';
  static String post(String id) => '/post/$id';
}

final _rootKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootKey,
  initialLocation: Routes.home,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => AppShell(shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [GoRoute(path: Routes.library, builder: (_, _) => const LibraryScreen())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: Routes.home, builder: (_, _) => const HomeScreen())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: Routes.backup, builder: (_, _) => const BackupScreen())],
        ),
      ],
    ),
    GoRoute(
      path: Routes.newPost,
      parentNavigatorKey: _rootKey,
      pageBuilder: (_, _) => const CupertinoPage(fullscreenDialog: true, child: PostEditorScreen()),
    ),
    GoRoute(
      path: '/post/:id',
      parentNavigatorKey: _rootKey,
      pageBuilder: (_, state) => CupertinoPage(child: PostEditorScreen(postId: state.pathParameters['id'])),
    ),
  ],
);
