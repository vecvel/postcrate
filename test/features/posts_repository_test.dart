import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:postcrate/core/database/app_database.dart';
import 'package:postcrate/core/storage/media_store.dart';
import 'package:postcrate/features/posts/data/posts_repository.dart';
import 'package:postcrate/features/posts/domain/post.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late Directory dir;
  late PostsRepository repo;

  setUpAll(() => driftRuntimeOptions.dontWarnAboutMultipleDatabases = true);

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    dir = await Directory.systemTemp.createTemp('postcrate_test');
    await Directory('${dir.path}/media').create();
    repo = PostsRepository(db, MediaStore.at(dir));
  });

  tearDown(() async {
    await db.close();
    await dir.delete(recursive: true);
  });

  Future<Attachment> importText(String name, String content) async {
    final src = File('${dir.path}/$name')..writeAsStringSync(content);
    return (await repo.media.import(src))!;
  }

  test('saves and reads a post with attachments, collections and fields', () async {
    final c = await repo.createCollection('Launch');
    final a = await importText('notes.txt', 'hello');
    final post = repo.newPost().copyWith(
      title: 'Title',
      body: 'Hello #world',
      attachments: [a],
      collectionIds: [c.id],
      poll: () => const Poll(question: 'Q', options: ['A', 'B']),
    );
    await repo.save(post);

    final read = (await repo.getPost(post.id))!;
    expect(read.title, 'Title');
    expect(read.hashtags, ['world']);
    expect(read.attachments.single.kind, AttachmentKind.document);
    expect(read.attachments.single.sizeBytes, 5);
    expect(read.collectionIds, [c.id]);
    expect(read.poll!.options, ['A', 'B']);
  });

  test('imports files without the native media probe (tests have no plugin)', () async {
    final a = await importText('notes.txt', 'hi');
    expect(a.mediaInfo, isNull);
    expect(a.sizeBytes, 2);
  });

  test('removing an attachment deletes its file', () async {
    final a = await importText('a.txt', 'a');
    final post = repo.newPost().copyWith(body: 'x', attachments: [a]);
    await repo.save(post);
    expect(await repo.media.exists(a.relativePath), isTrue);

    await repo.save(post.copyWith(attachments: []));
    expect(await repo.media.exists(a.relativePath), isFalse);
  });

  test('a later editor save keeps a share recorded in the meantime', () async {
    final post = repo.newPost().copyWith(body: 'x');
    await repo.save(post);
    await repo.recordShare(post.id, 'Instagram');

    await repo.save(post.copyWith(body: 'edited'));
    final read = (await repo.getPost(post.id))!;
    expect(read.body, 'edited');
    expect(read.shareHistory.single.target, 'Instagram');
  });

  test('collection names must be unique, ignoring case', () async {
    await repo.createCollection('Launch');
    expect(() => repo.createCollection('launch '), throwsA(isA<DuplicateNameException>()));
    final other = await repo.createCollection('Ideas');
    expect(() => repo.renameCollection(other.id, 'LAUNCH'), throwsA(isA<DuplicateNameException>()));
  });

  test('deleting a collection keeps its posts', () async {
    final c = await repo.createCollection('Launch');
    final post = repo.newPost().copyWith(body: 'x', collectionIds: [c.id]);
    await repo.save(post);
    await repo.deleteCollection(c.id);
    final read = (await repo.getPost(post.id))!;
    expect(read.collectionIds, isEmpty);
  });

  test('restore adds missing posts and only overwrites older local copies', () async {
    final t0 = DateTime(2026, 1, 1);
    final local = repo.newPost().copyWith(body: 'local newer', updatedAt: t0.add(const Duration(days: 2)));
    await repo.save(local);

    final backupOlder = Post.fromJson({
      ...local.toJson(),
      'body': 'backup older',
      'updatedAt': t0.toUtc().toIso8601String(),
    });
    final backupNew = Post(id: 'from-backup', body: 'only in backup', createdAt: t0, updatedAt: t0);

    final written = await repo.mergeFromBackup([backupOlder, backupNew], const []);
    expect(written, 1);
    expect((await repo.getPost(local.id))!.body, 'local newer');
    expect((await repo.getPost('from-backup'))!.body, 'only in backup');
  });
}
