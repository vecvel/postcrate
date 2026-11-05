import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/posts/data/posts_repository.dart';
import '../features/posts/domain/post.dart';
import 'database/app_database.dart';
import 'storage/media_store.dart';

/// Overridden in main() once the database, media store and preferences are open.
final databaseProvider = Provider<AppDatabase>((ref) => throw UnimplementedError('databaseProvider'));
final mediaStoreProvider = Provider<MediaStore>((ref) => throw UnimplementedError('mediaStoreProvider'));
final preferencesProvider = Provider<SharedPreferencesWithCache>(
  (ref) => throw UnimplementedError('preferencesProvider'),
);

final postsRepositoryProvider = Provider<PostsRepository>(
  (ref) => PostsRepository(ref.watch(databaseProvider), ref.watch(mediaStoreProvider)),
);

final postsProvider = StreamProvider<List<Post>>((ref) => ref.watch(postsRepositoryProvider).watchPosts());

final postProvider = StreamProvider.family<Post?, String>(
  (ref, id) => ref.watch(postsRepositoryProvider).watchPost(id),
);

final collectionsProvider = StreamProvider<List<Collection>>(
  (ref) => ref.watch(postsRepositoryProvider).watchCollections(),
);
