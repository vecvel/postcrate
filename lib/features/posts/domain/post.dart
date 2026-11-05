import 'package:flutter/foundation.dart';

import 'media_info.dart';
import 'social_app.dart';

enum PostStatus {
  draft('Draft'),
  ready('Ready'),
  shared('Shared'),
  archived('Archived');

  const PostStatus(this.label);
  final String label;

  static PostStatus fromName(String n) => values.firstWhere((s) => s.name == n, orElse: () => draft);
}

enum AttachmentKind {
  image('Image'),
  video('Video'),
  audio('Audio'),
  document('Document');

  const AttachmentKind(this.label);
  final String label;

  static AttachmentKind fromName(String n) => values.firstWhere((k) => k.name == n, orElse: () => document);

  static const extensions = {
    AttachmentKind.image: ['jpg', 'jpeg', 'png', 'heic', 'heif', 'webp', 'gif', 'avif'],
    AttachmentKind.video: ['mp4', 'mov', 'm4v', 'webm'],
    AttachmentKind.audio: ['mp3', 'm4a', 'aac', 'wav'],
    AttachmentKind.document: ['pdf', 'docx', 'pptx', 'txt'],
  };

  static List<String> get allExtensions => extensions.values.expand((e) => e).toList();

  static AttachmentKind? fromExtension(String ext) {
    final e = ext.toLowerCase().replaceFirst('.', '');
    for (final entry in extensions.entries) {
      if (entry.value.contains(e)) return entry.key;
    }
    return null;
  }
}

enum CropAspect {
  free('Original'),
  square('1:1'),
  portrait('4:5'),
  story('9:16'),
  landscape('16:9');

  const CropAspect(this.label);
  final String label;

  static CropAspect fromName(String? n) => values.firstWhere((c) => c.name == n, orElse: () => free);
}

@immutable
class Attachment {
  const Attachment({
    required this.id,
    required this.kind,
    required this.fileName,
    required this.relativePath,
    required this.mimeType,
    required this.sizeBytes,
    required this.sha256,
    this.width,
    this.height,
    this.durationMs,
    this.altText,
    this.coverFrameMs,
    this.crop = CropAspect.free,
    this.mediaInfo,
    this.thumbRelativePath,
  });

  final String id;
  final AttachmentKind kind;
  final String fileName;

  /// Path relative to the app documents directory.
  final String relativePath;
  final String mimeType;
  final int sizeBytes;
  final String sha256;
  final int? width;
  final int? height;
  final int? durationMs;
  final String? altText;
  final int? coverFrameMs;
  final CropAspect crop;

  /// Technical details from the native media probe (codecs, bitrate, ...).
  final MediaInfo? mediaInfo;

  /// Preview frame for video and documents, relative to the documents
  /// directory. A cache: regenerated when missing.
  final String? thumbRelativePath;

  String get extension => fileName.contains('.') ? fileName.split('.').last.toUpperCase() : kind.label;

  Attachment copyWith({
    String? altText,
    CropAspect? crop,
    String? relativePath,
    int? width,
    int? height,
    int? durationMs,
    int? Function()? coverFrameMs,
    MediaInfo? mediaInfo,
    String? Function()? thumbRelativePath,
  }) => Attachment(
    id: id,
    kind: kind,
    fileName: fileName,
    relativePath: relativePath ?? this.relativePath,
    mimeType: mimeType,
    sizeBytes: sizeBytes,
    sha256: sha256,
    width: width ?? this.width,
    height: height ?? this.height,
    durationMs: durationMs ?? this.durationMs,
    altText: altText ?? this.altText,
    coverFrameMs: coverFrameMs != null ? coverFrameMs() : this.coverFrameMs,
    crop: crop ?? this.crop,
    mediaInfo: mediaInfo ?? this.mediaInfo,
    thumbRelativePath: thumbRelativePath != null ? thumbRelativePath() : this.thumbRelativePath,
  );

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'fileName': fileName,
    'relativePath': relativePath,
    'mimeType': mimeType,
    'sizeBytes': sizeBytes,
    'sha256': sha256,
    'width': width,
    'height': height,
    'durationMs': durationMs,
    'altText': altText,
    'coverFrameMs': coverFrameMs,
    'crop': crop.name,
    'mediaInfo': mediaInfo?.toJson(),
  };

  factory Attachment.fromJson(Map<String, Object?> j) => Attachment(
    id: j['id']! as String,
    kind: AttachmentKind.fromName(j['kind']! as String),
    fileName: j['fileName']! as String,
    relativePath: j['relativePath']! as String,
    mimeType: j['mimeType']! as String,
    sizeBytes: j['sizeBytes']! as int,
    sha256: j['sha256']! as String,
    width: j['width'] as int?,
    height: j['height'] as int?,
    durationMs: j['durationMs'] as int?,
    altText: j['altText'] as String?,
    coverFrameMs: j['coverFrameMs'] as int?,
    crop: CropAspect.fromName(j['crop'] as String?),
    mediaInfo: j['mediaInfo'] == null ? null : MediaInfo.fromJson((j['mediaInfo']! as Map).cast<String, Object?>()),
  );
}

@immutable
class LinkPreview {
  const LinkPreview({required this.url, this.title, this.description});

  final String url;
  final String? title;
  final String? description;

  Map<String, Object?> toJson() => {'url': url, 'title': title, 'description': description};

  factory LinkPreview.fromJson(Map<String, Object?> j) =>
      LinkPreview(url: j['url']! as String, title: j['title'] as String?, description: j['description'] as String?);
}

@immutable
class Poll {
  const Poll({required this.question, required this.options, this.durationHours = 24});

  final String question;
  final List<String> options;
  final int durationHours;

  Map<String, Object?> toJson() => {'question': question, 'options': options, 'durationHours': durationHours};

  factory Poll.fromJson(Map<String, Object?> j) => Poll(
    question: j['question']! as String,
    options: (j['options']! as List).cast<String>(),
    durationHours: j['durationHours'] as int? ?? 24,
  );

  String asText() => [question, for (final o in options) '- $o'].join('\n');
}

@immutable
class Place {
  const Place({required this.name, this.latitude, this.longitude});

  final String name;
  final double? latitude;
  final double? longitude;

  Map<String, Object?> toJson() => {'name': name, 'latitude': latitude, 'longitude': longitude};

  factory Place.fromJson(Map<String, Object?> j) => Place(
    name: j['name']! as String,
    latitude: (j['latitude'] as num?)?.toDouble(),
    longitude: (j['longitude'] as num?)?.toDouble(),
  );
}

@immutable
class TargetApp {
  const TargetApp({required this.app, this.variantText});

  final SocialApp app;

  /// Optional text written just for this app; falls back to the post body.
  final String? variantText;

  Map<String, Object?> toJson() => {'app': app.name, 'variantText': variantText};

  factory TargetApp.fromJson(Map<String, Object?> j) =>
      TargetApp(app: SocialApp.fromName(j['app']! as String), variantText: j['variantText'] as String?);
}

@immutable
class ShareEvent {
  const ShareEvent({required this.id, required this.target, required this.sharedAt, this.liveUrl});

  final String id;

  /// Friendly app name when known, otherwise what the share sheet reported.
  final String target;
  final DateTime sharedAt;
  final String? liveUrl;

  Map<String, Object?> toJson() => {
    'id': id,
    'target': target,
    'sharedAt': sharedAt.toUtc().toIso8601String(),
    'liveUrl': liveUrl,
  };

  factory ShareEvent.fromJson(Map<String, Object?> j) => ShareEvent(
    id: j['id']! as String,
    target: j['target']! as String,
    sharedAt: DateTime.parse(j['sharedAt']! as String).toLocal(),
    liveUrl: j['liveUrl'] as String?,
  );
}

@immutable
class Collection {
  const Collection({required this.id, required this.name, required this.createdAt});

  final String id;
  final String name;
  final DateTime createdAt;

  Map<String, Object?> toJson() => {'id': id, 'name': name, 'createdAt': createdAt.toUtc().toIso8601String()};

  factory Collection.fromJson(Map<String, Object?> j) => Collection(
    id: j['id']! as String,
    name: j['name']! as String,
    createdAt: DateTime.parse(j['createdAt']! as String).toLocal(),
  );
}

@immutable
class Post {
  const Post({
    required this.id,
    this.title,
    this.body = '',
    this.threadParts = const [],
    this.attachments = const [],
    this.link,
    this.poll,
    this.hashtags = const [],
    this.mentions = const [],
    this.place,
    this.language,
    this.contentWarning,
    this.firstComment,
    this.reminderAt,
    this.targets = const [],
    this.collectionIds = const [],
    this.status = PostStatus.draft,
    this.pinned = false,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.shareHistory = const [],
  });

  final String id;
  final String? title;
  final String body;
  final List<String> threadParts;
  final List<Attachment> attachments;
  final LinkPreview? link;
  final Poll? poll;
  final List<String> hashtags;
  final List<String> mentions;
  final Place? place;
  final String? language;
  final String? contentWarning;
  final String? firstComment;
  final DateTime? reminderAt;
  final List<TargetApp> targets;
  final List<String> collectionIds;
  final PostStatus status;
  final bool pinned;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ShareEvent> shareHistory;

  bool get isEmpty =>
      (title ?? '').trim().isEmpty &&
      body.trim().isEmpty &&
      attachments.isEmpty &&
      threadParts.every((t) => t.trim().isEmpty);

  List<Attachment> get videos => attachments.where((a) => a.kind == AttachmentKind.video).toList();

  /// Short text used in lists.
  String get preview {
    if (body.trim().isNotEmpty) return body.trim();
    if ((title ?? '').trim().isNotEmpty) return title!.trim();
    if (attachments.isNotEmpty) return '${attachments.length} attachment${attachments.length == 1 ? '' : 's'}';
    return 'Empty post';
  }

  static final _hashtag = RegExp(r'(?:^|\s)#([\p{L}\p{N}_]+)', unicode: true);
  static final _mention = RegExp(r'(?:^|\s)@([\w.]+(?:@[\w.-]+)?)', unicode: true);

  static List<String> parseHashtags(String text) => _hashtag.allMatches(text).map((m) => m.group(1)!).toSet().toList();

  static List<String> parseMentions(String text) => _mention.allMatches(text).map((m) => m.group(1)!).toSet().toList();

  Post copyWith({
    String? title,
    String? body,
    List<String>? threadParts,
    List<Attachment>? attachments,
    LinkPreview? Function()? link,
    Poll? Function()? poll,
    Place? Function()? place,
    String? Function()? language,
    String? Function()? contentWarning,
    String? Function()? firstComment,
    DateTime? Function()? reminderAt,
    List<TargetApp>? targets,
    List<String>? collectionIds,
    PostStatus? status,
    bool? pinned,
    String? Function()? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<ShareEvent>? shareHistory,
  }) {
    final nextBody = body ?? this.body;
    final nextThread = threadParts ?? this.threadParts;
    final allText = [nextBody, ...nextThread].join('\n');
    return Post(
      id: id,
      title: title ?? this.title,
      body: nextBody,
      threadParts: nextThread,
      attachments: attachments ?? this.attachments,
      link: link != null ? link() : this.link,
      poll: poll != null ? poll() : this.poll,
      hashtags: parseHashtags(allText),
      mentions: parseMentions(allText),
      place: place != null ? place() : this.place,
      language: language != null ? language() : this.language,
      contentWarning: contentWarning != null ? contentWarning() : this.contentWarning,
      firstComment: firstComment != null ? firstComment() : this.firstComment,
      reminderAt: reminderAt != null ? reminderAt() : this.reminderAt,
      targets: targets ?? this.targets,
      collectionIds: collectionIds ?? this.collectionIds,
      status: status ?? this.status,
      pinned: pinned ?? this.pinned,
      notes: notes != null ? notes() : this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      shareHistory: shareHistory ?? this.shareHistory,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'threadParts': threadParts,
    'attachments': [for (final a in attachments) a.toJson()],
    'link': link?.toJson(),
    'poll': poll?.toJson(),
    'hashtags': hashtags,
    'mentions': mentions,
    'place': place?.toJson(),
    'language': language,
    'contentWarning': contentWarning,
    'firstComment': firstComment,
    'reminderAt': reminderAt?.toUtc().toIso8601String(),
    'targets': [for (final t in targets) t.toJson()],
    'collectionIds': collectionIds,
    'status': status.name,
    'pinned': pinned,
    'notes': notes,
    'createdAt': createdAt.toUtc().toIso8601String(),
    'updatedAt': updatedAt.toUtc().toIso8601String(),
    'shareHistory': [for (final s in shareHistory) s.toJson()],
  };

  factory Post.fromJson(Map<String, Object?> j) {
    Map<String, Object?>? m(Object? v) => v == null ? null : (v as Map).cast<String, Object?>();
    List<Map<String, Object?>> list(Object? v) =>
        ((v as List?) ?? const []).map((e) => (e as Map).cast<String, Object?>()).toList();
    return Post(
      id: j['id']! as String,
      title: j['title'] as String?,
      body: j['body'] as String? ?? '',
      threadParts: ((j['threadParts'] as List?) ?? const []).cast<String>(),
      attachments: list(j['attachments']).map(Attachment.fromJson).toList(),
      link: m(j['link']) == null ? null : LinkPreview.fromJson(m(j['link'])!),
      poll: m(j['poll']) == null ? null : Poll.fromJson(m(j['poll'])!),
      hashtags: ((j['hashtags'] as List?) ?? const []).cast<String>(),
      mentions: ((j['mentions'] as List?) ?? const []).cast<String>(),
      place: m(j['place']) == null ? null : Place.fromJson(m(j['place'])!),
      language: j['language'] as String?,
      contentWarning: j['contentWarning'] as String?,
      firstComment: j['firstComment'] as String?,
      reminderAt: j['reminderAt'] == null ? null : DateTime.parse(j['reminderAt']! as String).toLocal(),
      targets: list(j['targets']).map(TargetApp.fromJson).toList(),
      collectionIds: ((j['collectionIds'] as List?) ?? const []).cast<String>(),
      status: PostStatus.fromName(j['status'] as String? ?? 'draft'),
      pinned: j['pinned'] as bool? ?? false,
      notes: j['notes'] as String?,
      createdAt: DateTime.parse(j['createdAt']! as String).toLocal(),
      updatedAt: DateTime.parse(j['updatedAt']! as String).toLocal(),
      shareHistory: list(j['shareHistory']).map(ShareEvent.fromJson).toList(),
    );
  }
}
