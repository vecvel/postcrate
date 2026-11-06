import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

@DataClassName('PostRow')
class Posts extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().nullable()();
  TextColumn get body => text().withDefault(const Constant(''))();

  /// JSON-encoded fields; their shape lives in features/posts/domain/post.dart.
  TextColumn get threadParts => text().withDefault(const Constant('[]'))();
  TextColumn get link => text().nullable()();
  TextColumn get poll => text().nullable()();
  TextColumn get hashtags => text().withDefault(const Constant('[]'))();
  TextColumn get mentions => text().withDefault(const Constant('[]'))();
  TextColumn get place => text().nullable()();
  TextColumn get targets => text().withDefault(const Constant('[]'))();

  /// Unused since direct YouTube upload was removed; kept so schema 2
  /// databases stay valid.
  TextColumn get youtube => text().nullable()();

  TextColumn get language => text().nullable()();
  TextColumn get contentWarning => text().nullable()();
  TextColumn get firstComment => text().nullable()();
  DateTimeColumn get reminderAt => dateTime().nullable()();
  TextColumn get status => text().withDefault(const Constant('draft'))();
  BoolColumn get pinned => boolean().withDefault(const Constant(false))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('AttachmentRow')
class Attachments extends Table {
  TextColumn get id => text()();
  TextColumn get postId => text().references(Posts, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();
  TextColumn get kind => text()();
  TextColumn get fileName => text()();
  TextColumn get relativePath => text()();
  TextColumn get mimeType => text()();
  IntColumn get sizeBytes => integer()();
  TextColumn get sha256 => text()();
  IntColumn get width => integer().nullable()();
  IntColumn get height => integer().nullable()();
  IntColumn get durationMs => integer().nullable()();
  TextColumn get altText => text().nullable()();
  IntColumn get coverFrameMs => integer().nullable()();
  TextColumn get crop => text().nullable()();

  /// Media probe result (JSON) and preview frame path, added in schema 2.
  TextColumn get mediaInfo => text().nullable()();
  TextColumn get thumbPath => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('CollectionRow')
class Collections extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().unique()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('PostCollectionRow')
class PostCollections extends Table {
  TextColumn get postId => text().references(Posts, #id, onDelete: KeyAction.cascade)();
  TextColumn get collectionId => text().references(Collections, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {postId, collectionId};
}

@DataClassName('ShareEventRow')
class ShareEvents extends Table {
  TextColumn get id => text()();
  TextColumn get postId => text().references(Posts, #id, onDelete: KeyAction.cascade)();
  TextColumn get target => text()();
  DateTimeColumn get sharedAt => dateTime()();
  TextColumn get liveUrl => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Posts, Attachments, Collections, PostCollections, ShareEvents])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _open());

  static QueryExecutor _open() =>
      driftDatabase(name: 'postcrate', native: const DriftNativeOptions(shareAcrossIsolates: true));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(posts, posts.youtube);
        await m.addColumn(attachments, attachments.mediaInfo);
        await m.addColumn(attachments, attachments.thumbPath);
      }
    },
    onCreate: (m) async {
      await m.createAll();
      await m.createIndex(Index('posts_created_at', 'CREATE INDEX posts_created_at ON posts (created_at)'));
      await m.createIndex(Index('attachments_post', 'CREATE INDEX attachments_post ON attachments (post_id)'));
    },
  );
}
