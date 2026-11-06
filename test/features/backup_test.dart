import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:postcrate/core/database/app_database.dart';
import 'package:postcrate/core/storage/media_store.dart';
import 'package:postcrate/features/backup/data/backup_archive.dart';
import 'package:postcrate/features/backup/data/backup_service.dart';
import 'package:postcrate/features/posts/data/posts_repository.dart';
import 'package:postcrate/features/posts/domain/post.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() => driftRuntimeOptions.dontWarnAboutMultipleDatabases = true);

  late Directory root;
  setUp(() async => root = await Directory.systemTemp.createTemp('backup_test'));
  tearDown(() => root.delete(recursive: true));

  Future<(AppDatabase, PostsRepository)> library(String name) async {
    final dir = Directory('${root.path}/$name');
    await Directory('${dir.path}/media').create(recursive: true);
    final db = AppDatabase(NativeDatabase.memory());
    return (db, PostsRepository(db, MediaStore.at(dir)));
  }

  test('a backup file restores posts, collections and media into an empty library', () async {
    final (dbA, a) = await library('a');
    final src = File('${root.path}/clip.mp4')..writeAsBytesSync(List.generate(5000, (i) => i % 256));
    final clip = (await a.media.import(src))!;
    final col = await a.createCollection('Launch');
    final d1 = DateTime(2026, 11, 1, 9), d2 = DateTime(2026, 11, 3, 18);
    await a.save(
      Post(id: 'p1', body: 'with video', attachments: [clip], collectionIds: [col.id], createdAt: d1, updatedAt: d1),
    );
    await a.save(Post(id: 'p2', body: 'text only', createdAt: d2, updatedAt: d2));
    await a.recordShare('p1', 'Instagram', liveUrl: 'https://www.instagram.com/p/abc/');

    final zip = await BackupService(a, Directory('${root.path}/tmpA')).create();
    expect(zip.path, endsWith('.zip'));

    final contents = await BackupArchive.read(zip);
    expect(contents.posts.map((p) => p.id), containsAll(['p1', 'p2']));
    expect(contents.mediaEntries.keys, [clip.sha256]);
    expect(contents.days.map((d) => d.$1), [DateTime(2026, 11, 3), DateTime(2026, 11, 1)]);

    final (dbB, b) = await library('b');
    final restored = await BackupService(b, Directory('${root.path}/tmpB')).restore(contents);
    expect(restored, 2);
    final p1 = (await b.getPost('p1'))!;
    expect(await b.media.resolve(p1.attachments.single.relativePath).readAsBytes(), await src.readAsBytes());
    expect(p1.shareHistory.single.liveUrl, 'https://www.instagram.com/p/abc/');
    expect((await b.getCollections()).single.name, 'Launch');
    expect(p1.collectionIds, [(await b.getCollections()).single.id]);

    await dbA.close();
    await dbB.close();
  });

  test('restoring selected days brings back only posts made on those days', () async {
    final (dbA, a) = await library('a');
    final d1 = DateTime(2026, 11, 1, 9), d2 = DateTime(2026, 11, 3, 18);
    await a.save(Post(id: 'p1', body: 'one', createdAt: d1, updatedAt: d1));
    await a.save(Post(id: 'p2', body: 'two', createdAt: d2, updatedAt: d2));
    final contents = await BackupArchive.read(await BackupService(a, Directory('${root.path}/tmp')).create());

    final (dbB, b) = await library('b');
    final n = await BackupService(b, Directory('${root.path}/tmpB')).restore(contents, days: {DateTime(2026, 11, 3)});
    expect(n, 1);
    expect((await b.getAll()).map((p) => p.id), ['p2']);
    await dbA.close();
    await dbB.close();
  });

  test('rejects files that are not Postcrate backups', () async {
    final notZip = File('${root.path}/x.zip')..writeAsStringSync('hello');
    expect(() => BackupArchive.read(notZip), throwsA(isA<BackupException>()));
  });
}
