import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../../core/storage/media_store.dart';
import '../domain/media_info.dart';
import '../domain/post.dart';

class DuplicateNameException implements Exception {
  const DuplicateNameException(this.name);
  final String name;

  @override
  String toString() => 'A collection named "$name" already exists.';
}

class PostsRepository {
  PostsRepository(this._db, this._media);

  final AppDatabase _db;
  final MediaStore _media;

  MediaStore get media => _media;

  // Reads -------------------------------------------------------------------

  Stream<List<Post>> watchPosts() {
    final query = _db.customSelect(
      'SELECT id FROM posts',
      readsFrom: {_db.posts, _db.attachments, _db.postCollections, _db.shareEvents},
    );
    return query.watch().asyncMap((_) => getAll());
  }

  Stream<Post?> watchPost(String id) => watchPosts().map((all) {
    for (final p in all) {
      if (p.id == id) return p;
    }
    return null;
  });

  Future<List<Post>> getAll() async {
    final rows = await (_db.select(_db.posts)..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();
    final atts = await (_db.select(_db.attachments)..orderBy([(t) => OrderingTerm.asc(t.position)])).get();
    final links = await _db.select(_db.postCollections).get();
    final shares = await (_db.select(_db.shareEvents)..orderBy([(t) => OrderingTerm.desc(t.sharedAt)])).get();

    final attsBy = <String, List<AttachmentRow>>{};
    for (final a in atts) {
      (attsBy[a.postId] ??= []).add(a);
    }
    final colsBy = <String, List<String>>{};
    for (final l in links) {
      (colsBy[l.postId] ??= []).add(l.collectionId);
    }
    final sharesBy = <String, List<ShareEventRow>>{};
    for (final s in shares) {
      (sharesBy[s.postId] ??= []).add(s);
    }
    return [
      for (final r in rows) _toPost(r, attsBy[r.id] ?? const [], colsBy[r.id] ?? const [], sharesBy[r.id] ?? const []),
    ];
  }

  Future<Post?> getPost(String id) async {
    final all = await getAll();
    for (final p in all) {
      if (p.id == id) return p;
    }
    return null;
  }

  // Writes ------------------------------------------------------------------

  Post newPost() {
    final now = DateTime.now();
    return Post(id: const Uuid().v4(), createdAt: now, updatedAt: now);
  }

  /// Writes the post, its attachments and collections. Share history is
  /// owned by [recordShare] and only replaced when [includeShareHistory] is
  /// set (restore), so an open editor can't overwrite a share it didn't see.
  Future<void> save(Post post, {bool includeShareHistory = false}) async {
    final removedFiles = <String>[];
    await _db.transaction(() async {
      final existing = await (_db.select(_db.attachments)..where((t) => t.postId.equals(post.id))).get();
      final keep = post.attachments.map((a) => a.id).toSet();
      final keptThumbs = post.attachments.map((a) => a.thumbRelativePath).toSet();
      for (final a in existing) {
        if (!keep.contains(a.id)) removedFiles.add(a.relativePath);
        if (a.thumbPath != null && !keptThumbs.contains(a.thumbPath)) removedFiles.add(a.thumbPath!);
      }

      await _db.into(_db.posts).insertOnConflictUpdate(_toRow(post));

      await (_db.delete(_db.attachments)..where((t) => t.postId.equals(post.id))).go();
      for (var i = 0; i < post.attachments.length; i++) {
        await _db.into(_db.attachments).insert(_toAttachmentRow(post.id, i, post.attachments[i]));
      }

      await (_db.delete(_db.postCollections)..where((t) => t.postId.equals(post.id))).go();
      for (final cid in post.collectionIds) {
        await _db
            .into(_db.postCollections)
            .insert(
              PostCollectionsCompanion.insert(postId: post.id, collectionId: cid),
              mode: InsertMode.insertOrIgnore,
            );
      }

      if (includeShareHistory) {
        await (_db.delete(_db.shareEvents)..where((t) => t.postId.equals(post.id))).go();
        for (final s in post.shareHistory) {
          await _db.into(_db.shareEvents).insert(_toShareRow(post.id, s));
        }
      }
    });
    for (final f in removedFiles) {
      await _media.delete(f);
    }
  }

  Future<void> delete(String postId) async {
    final atts = await (_db.select(_db.attachments)..where((t) => t.postId.equals(postId))).get();
    await (_db.delete(_db.posts)..where((t) => t.id.equals(postId))).go();
    for (final a in atts) {
      await _media.delete(a.relativePath);
      if (a.thumbPath != null) await _media.delete(a.thumbPath!);
    }
  }

  /// Records that [postId] was shared to [target] and marks it shared.
  /// Returns the new share event id.
  Future<String> recordShare(String postId, String target, {String? liveUrl}) async {
    final id = const Uuid().v4();
    await _db.transaction(() async {
      await _db
          .into(_db.shareEvents)
          .insert(
            ShareEventsCompanion.insert(
              id: id,
              postId: postId,
              target: target,
              sharedAt: DateTime.now(),
              liveUrl: Value(liveUrl),
            ),
          );
      await (_db.update(
        _db.posts,
      )..where((t) => t.id.equals(postId))).write(const PostsCompanion(status: Value('shared')));
    });
    return id;
  }

  /// Saves the live post link for a share; [target] replaces the recorded app
  /// name when the link identifies the platform.
  Future<void> setLiveUrl(String shareEventId, String? url, {String? target}) async {
    await (_db.update(_db.shareEvents)..where((t) => t.id.equals(shareEventId))).write(
      ShareEventsCompanion(liveUrl: Value(url), target: target == null ? const Value.absent() : Value(target)),
    );
  }

  /// True when some share already has this link.
  Future<bool> hasLiveUrl(String url) async {
    final rows = await (_db.select(_db.shareEvents)..where((t) => t.liveUrl.equals(url))).get();
    return rows.isNotEmpty;
  }

  Future<Post> duplicate(Post post) async {
    final now = DateTime.now();
    final attachments = <Attachment>[];
    for (final a in post.attachments) {
      final source = _media.resolve(a.relativePath);
      if (!await source.exists()) continue;
      final copy = await _media.import(source, originalName: a.fileName);
      if (copy != null) attachments.add(copy.copyWith(altText: a.altText, crop: a.crop));
    }
    final copy = Post.fromJson({
      ...post.toJson(),
      'id': const Uuid().v4(),
      'attachments': [for (final a in attachments) a.toJson()],
      'status': PostStatus.draft.name,
      'pinned': false,
      'shareHistory': const [],
      'createdAt': now.toUtc().toIso8601String(),
      'updatedAt': now.toUtc().toIso8601String(),
    });
    await save(copy);
    return copy;
  }

  // Collections ---------------------------------------------------------------

  Stream<List<Collection>> watchCollections() => (_db.select(
    _db.collections,
  )..orderBy([(t) => OrderingTerm.asc(t.name)])).watch().map((rows) => rows.map(_toCollection).toList());

  Future<List<Collection>> getCollections() async =>
      (await _db.select(_db.collections).get()).map(_toCollection).toList();

  Future<Collection> createCollection(String name) async {
    final trimmed = name.trim();
    await _ensureUniqueName(trimmed);
    final c = Collection(id: const Uuid().v4(), name: trimmed, createdAt: DateTime.now());
    await _db.into(_db.collections).insert(CollectionsCompanion.insert(id: c.id, name: c.name, createdAt: c.createdAt));
    return c;
  }

  Future<void> renameCollection(String id, String name) async {
    final trimmed = name.trim();
    await _ensureUniqueName(trimmed, exceptId: id);
    await (_db.update(
      _db.collections,
    )..where((t) => t.id.equals(id))).write(CollectionsCompanion(name: Value(trimmed)));
  }

  /// Deletes the collection only; posts in it are kept.
  Future<void> deleteCollection(String id) => (_db.delete(_db.collections)..where((t) => t.id.equals(id))).go();

  Future<void> _ensureUniqueName(String name, {String? exceptId}) async {
    final all = await _db.select(_db.collections).get();
    final clash = all.any((c) => c.id != exceptId && c.name.toLowerCase() == name.toLowerCase());
    if (clash) throw DuplicateNameException(name);
  }

  // Restore -------------------------------------------------------------------

  /// Merges posts from a backup. A post is written when it is missing locally
  /// or the backup copy was edited more recently. Nothing is deleted.
  Future<int> mergeFromBackup(List<Post> posts, List<Collection> collections) async {
    var written = 0;
    final local = {for (final p in await getAll()) p.id: p};
    await _db.transaction(() async {
      for (final c in collections) {
        final byName = await (_db.select(_db.collections)..where((t) => t.name.equals(c.name))).getSingleOrNull();
        if (byName == null) {
          await _db
              .into(_db.collections)
              .insertOnConflictUpdate(CollectionsCompanion.insert(id: c.id, name: c.name, createdAt: c.createdAt));
        }
      }
    });
    final knownCollections = (await _db.select(_db.collections).get()).map((c) => c.id).toSet();
    for (final p in posts) {
      final mine = local[p.id];
      if (mine != null && !p.updatedAt.isAfter(mine.updatedAt)) continue;
      await save(
        p.copyWith(collectionIds: p.collectionIds.where(knownCollections.contains).toList(), updatedAt: p.updatedAt),
        includeShareHistory: true,
      );
      written++;
    }
    return written;
  }

  // Mapping -------------------------------------------------------------------

  static String _j(Object? v) => jsonEncode(v);

  static Map<String, Object?>? _obj(String? s) => s == null ? null : (jsonDecode(s) as Map).cast<String, Object?>();

  static List<T> _list<T>(String s) => (jsonDecode(s) as List).cast<T>();

  PostsCompanion _toRow(Post p) => PostsCompanion.insert(
    id: p.id,
    title: Value(p.title),
    body: Value(p.body),
    threadParts: Value(_j(p.threadParts)),
    link: Value(p.link == null ? null : _j(p.link!.toJson())),
    poll: Value(p.poll == null ? null : _j(p.poll!.toJson())),
    hashtags: Value(_j(p.hashtags)),
    mentions: Value(_j(p.mentions)),
    place: Value(p.place == null ? null : _j(p.place!.toJson())),
    targets: Value(_j([for (final t in p.targets) t.toJson()])),
    language: Value(p.language),
    contentWarning: Value(p.contentWarning),
    firstComment: Value(p.firstComment),
    reminderAt: Value(p.reminderAt),
    status: Value(p.status.name),
    pinned: Value(p.pinned),
    notes: Value(p.notes),
    createdAt: p.createdAt,
    updatedAt: p.updatedAt,
  );

  AttachmentsCompanion _toAttachmentRow(String postId, int position, Attachment a) => AttachmentsCompanion.insert(
    id: a.id,
    postId: postId,
    position: position,
    kind: a.kind.name,
    fileName: a.fileName,
    relativePath: a.relativePath,
    mimeType: a.mimeType,
    sizeBytes: a.sizeBytes,
    sha256: a.sha256,
    width: Value(a.width),
    height: Value(a.height),
    durationMs: Value(a.durationMs),
    altText: Value(a.altText),
    coverFrameMs: Value(a.coverFrameMs),
    crop: Value(a.crop.name),
    mediaInfo: Value(a.mediaInfo == null ? null : _j(a.mediaInfo!.toJson())),
    thumbPath: Value(a.thumbRelativePath),
  );

  ShareEventsCompanion _toShareRow(String postId, ShareEvent s) => ShareEventsCompanion.insert(
    id: s.id,
    postId: postId,
    target: s.target,
    sharedAt: s.sharedAt,
    liveUrl: Value(s.liveUrl),
  );

  Post _toPost(PostRow r, List<AttachmentRow> atts, List<String> cols, List<ShareEventRow> shares) {
    final link = _obj(r.link);
    final poll = _obj(r.poll);
    final place = _obj(r.place);
    return Post(
      id: r.id,
      title: r.title,
      body: r.body,
      threadParts: _list<String>(r.threadParts),
      attachments: [
        for (final a in atts)
          Attachment(
            id: a.id,
            kind: AttachmentKind.fromName(a.kind),
            fileName: a.fileName,
            relativePath: a.relativePath,
            mimeType: a.mimeType,
            sizeBytes: a.sizeBytes,
            sha256: a.sha256,
            width: a.width,
            height: a.height,
            durationMs: a.durationMs,
            altText: a.altText,
            coverFrameMs: a.coverFrameMs,
            crop: CropAspect.fromName(a.crop),
            mediaInfo: _obj(a.mediaInfo) == null ? null : MediaInfo.fromJson(_obj(a.mediaInfo)!),
            thumbRelativePath: a.thumbPath,
          ),
      ],
      link: link == null ? null : LinkPreview.fromJson(link),
      poll: poll == null ? null : Poll.fromJson(poll),
      hashtags: _list<String>(r.hashtags),
      mentions: _list<String>(r.mentions),
      place: place == null ? null : Place.fromJson(place),
      language: r.language,
      contentWarning: r.contentWarning,
      firstComment: r.firstComment,
      reminderAt: r.reminderAt,
      targets: [for (final t in jsonDecode(r.targets) as List) TargetApp.fromJson((t as Map).cast<String, Object?>())],
      collectionIds: cols,
      status: PostStatus.fromName(r.status),
      pinned: r.pinned,
      notes: r.notes,
      createdAt: r.createdAt,
      updatedAt: r.updatedAt,
      shareHistory: [
        for (final s in shares) ShareEvent(id: s.id, target: s.target, sharedAt: s.sharedAt, liveUrl: s.liveUrl),
      ],
    );
  }

  static Collection _toCollection(CollectionRow r) => Collection(id: r.id, name: r.name, createdAt: r.createdAt);
}
