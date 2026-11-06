import 'dart:io';

import 'package:path/path.dart' as p;

import '../../../core/utils/formatting.dart';
import '../../posts/data/posts_repository.dart';
import '../../posts/domain/post.dart';
import 'backup_archive.dart';

/// Makes backup files and restores from them. No accounts and no network:
/// the user decides where the file goes (Files, Google Drive, iCloud Drive,
/// a computer) through the system share sheet.
class BackupService {
  BackupService(this._repo, this._workDir);

  final PostsRepository _repo;

  /// Folder for freshly made backup files (the app's temporary directory).
  final Directory _workDir;

  Future<File> create() async {
    final dir = Directory(p.join(_workDir.path, 'backups'));
    if (await dir.exists()) await dir.delete(recursive: true);
    await dir.create(recursive: true);

    final posts = await _repo.getAll();
    final mediaPaths = <String, String>{
      for (final post in posts)
        for (final a in post.attachments) BackupArchive.mediaEntry(a): _repo.media.resolve(a.relativePath).path,
    };
    return BackupArchive.write(
      outDir: dir,
      posts: posts,
      collections: await _repo.getCollections(),
      mediaPaths: mediaPaths,
    );
  }

  /// Merges posts from [contents] into the library: missing posts are added,
  /// posts edited after the backup are kept, nothing is deleted. With [days],
  /// only posts created on those days are restored. Returns how many posts
  /// were added or updated.
  Future<int> restore(BackupContents contents, {Set<DateTime>? days}) async {
    final posts = days == null
        ? contents.posts
        : contents.posts.where((x) => days.contains(dayOf(x.createdAt))).toList();

    final wanted = <String, String>{};
    final entryOf = <String, String>{};
    for (final post in posts) {
      for (final a in post.attachments) {
        if (await _repo.media.exists(a.relativePath)) continue;
        final entry = contents.mediaEntries[a.sha256];
        if (entry == null) continue;
        wanted[entry] = _repo.media.resolve(a.relativePath).path;
        entryOf[a.id] = entry;
      }
    }
    final missing = wanted.isEmpty ? <String>{} : await BackupArchive.extract(contents.file, wanted);

    final cleaned = <Post>[];
    for (final post in posts) {
      final kept = <Attachment>[];
      for (final a in post.attachments) {
        final entry = entryOf[a.id];
        final present = entry != null ? !missing.contains(entry) : await _repo.media.exists(a.relativePath);
        if (present) kept.add(a.copyWith(thumbRelativePath: () => null));
      }
      cleaned.add(
        kept.length == post.attachments.length ? post : post.copyWith(attachments: kept, updatedAt: post.updatedAt),
      );
    }
    return _repo.mergeFromBackup(cleaned, contents.collections);
  }
}
