// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PostsTable extends Posts with TableInfo<$PostsTable, PostRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PostsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _threadPartsMeta = const VerificationMeta('threadParts');
  @override
  late final GeneratedColumn<String> threadParts = GeneratedColumn<String>(
    'thread_parts',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _linkMeta = const VerificationMeta('link');
  @override
  late final GeneratedColumn<String> link = GeneratedColumn<String>(
    'link',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pollMeta = const VerificationMeta('poll');
  @override
  late final GeneratedColumn<String> poll = GeneratedColumn<String>(
    'poll',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hashtagsMeta = const VerificationMeta('hashtags');
  @override
  late final GeneratedColumn<String> hashtags = GeneratedColumn<String>(
    'hashtags',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _mentionsMeta = const VerificationMeta('mentions');
  @override
  late final GeneratedColumn<String> mentions = GeneratedColumn<String>(
    'mentions',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _placeMeta = const VerificationMeta('place');
  @override
  late final GeneratedColumn<String> place = GeneratedColumn<String>(
    'place',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetsMeta = const VerificationMeta('targets');
  @override
  late final GeneratedColumn<String> targets = GeneratedColumn<String>(
    'targets',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _youtubeMeta = const VerificationMeta('youtube');
  @override
  late final GeneratedColumn<String> youtube = GeneratedColumn<String>(
    'youtube',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _languageMeta = const VerificationMeta('language');
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contentWarningMeta = const VerificationMeta('contentWarning');
  @override
  late final GeneratedColumn<String> contentWarning = GeneratedColumn<String>(
    'content_warning',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _firstCommentMeta = const VerificationMeta('firstComment');
  @override
  late final GeneratedColumn<String> firstComment = GeneratedColumn<String>(
    'first_comment',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reminderAtMeta = const VerificationMeta('reminderAt');
  @override
  late final GeneratedColumn<DateTime> reminderAt = GeneratedColumn<DateTime>(
    'reminder_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('draft'),
  );
  static const VerificationMeta _pinnedMeta = const VerificationMeta('pinned');
  @override
  late final GeneratedColumn<bool> pinned = GeneratedColumn<bool>(
    'pinned',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("pinned" IN (0, 1))'),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    body,
    threadParts,
    link,
    poll,
    hashtags,
    mentions,
    place,
    targets,
    youtube,
    language,
    contentWarning,
    firstComment,
    reminderAt,
    status,
    pinned,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'posts';
  @override
  VerificationContext validateIntegrity(Insertable<PostRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(_titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('body')) {
      context.handle(_bodyMeta, body.isAcceptableOrUnknown(data['body']!, _bodyMeta));
    }
    if (data.containsKey('thread_parts')) {
      context.handle(_threadPartsMeta, threadParts.isAcceptableOrUnknown(data['thread_parts']!, _threadPartsMeta));
    }
    if (data.containsKey('link')) {
      context.handle(_linkMeta, link.isAcceptableOrUnknown(data['link']!, _linkMeta));
    }
    if (data.containsKey('poll')) {
      context.handle(_pollMeta, poll.isAcceptableOrUnknown(data['poll']!, _pollMeta));
    }
    if (data.containsKey('hashtags')) {
      context.handle(_hashtagsMeta, hashtags.isAcceptableOrUnknown(data['hashtags']!, _hashtagsMeta));
    }
    if (data.containsKey('mentions')) {
      context.handle(_mentionsMeta, mentions.isAcceptableOrUnknown(data['mentions']!, _mentionsMeta));
    }
    if (data.containsKey('place')) {
      context.handle(_placeMeta, place.isAcceptableOrUnknown(data['place']!, _placeMeta));
    }
    if (data.containsKey('targets')) {
      context.handle(_targetsMeta, targets.isAcceptableOrUnknown(data['targets']!, _targetsMeta));
    }
    if (data.containsKey('youtube')) {
      context.handle(_youtubeMeta, youtube.isAcceptableOrUnknown(data['youtube']!, _youtubeMeta));
    }
    if (data.containsKey('language')) {
      context.handle(_languageMeta, language.isAcceptableOrUnknown(data['language']!, _languageMeta));
    }
    if (data.containsKey('content_warning')) {
      context.handle(
        _contentWarningMeta,
        contentWarning.isAcceptableOrUnknown(data['content_warning']!, _contentWarningMeta),
      );
    }
    if (data.containsKey('first_comment')) {
      context.handle(_firstCommentMeta, firstComment.isAcceptableOrUnknown(data['first_comment']!, _firstCommentMeta));
    }
    if (data.containsKey('reminder_at')) {
      context.handle(_reminderAtMeta, reminderAt.isAcceptableOrUnknown(data['reminder_at']!, _reminderAtMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta, status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('pinned')) {
      context.handle(_pinnedMeta, pinned.isAcceptableOrUnknown(data['pinned']!, _pinnedMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(_notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PostRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PostRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}title']),
      body: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}body'])!,
      threadParts: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}thread_parts'])!,
      link: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}link']),
      poll: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}poll']),
      hashtags: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}hashtags'])!,
      mentions: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}mentions'])!,
      place: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}place']),
      targets: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}targets'])!,
      youtube: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}youtube']),
      language: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}language']),
      contentWarning: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}content_warning']),
      firstComment: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}first_comment']),
      reminderAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}reminder_at']),
      status: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      pinned: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}pinned'])!,
      notes: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $PostsTable createAlias(String alias) {
    return $PostsTable(attachedDatabase, alias);
  }
}

class PostRow extends DataClass implements Insertable<PostRow> {
  final String id;
  final String? title;
  final String body;

  /// JSON-encoded fields; their shape lives in features/posts/domain/post.dart.
  final String threadParts;
  final String? link;
  final String? poll;
  final String hashtags;
  final String mentions;
  final String? place;
  final String targets;

  /// Unused since direct YouTube upload was removed; kept so schema 2
  /// databases stay valid.
  final String? youtube;
  final String? language;
  final String? contentWarning;
  final String? firstComment;
  final DateTime? reminderAt;
  final String status;
  final bool pinned;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PostRow({
    required this.id,
    this.title,
    required this.body,
    required this.threadParts,
    this.link,
    this.poll,
    required this.hashtags,
    required this.mentions,
    this.place,
    required this.targets,
    this.youtube,
    this.language,
    this.contentWarning,
    this.firstComment,
    this.reminderAt,
    required this.status,
    required this.pinned,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    map['body'] = Variable<String>(body);
    map['thread_parts'] = Variable<String>(threadParts);
    if (!nullToAbsent || link != null) {
      map['link'] = Variable<String>(link);
    }
    if (!nullToAbsent || poll != null) {
      map['poll'] = Variable<String>(poll);
    }
    map['hashtags'] = Variable<String>(hashtags);
    map['mentions'] = Variable<String>(mentions);
    if (!nullToAbsent || place != null) {
      map['place'] = Variable<String>(place);
    }
    map['targets'] = Variable<String>(targets);
    if (!nullToAbsent || youtube != null) {
      map['youtube'] = Variable<String>(youtube);
    }
    if (!nullToAbsent || language != null) {
      map['language'] = Variable<String>(language);
    }
    if (!nullToAbsent || contentWarning != null) {
      map['content_warning'] = Variable<String>(contentWarning);
    }
    if (!nullToAbsent || firstComment != null) {
      map['first_comment'] = Variable<String>(firstComment);
    }
    if (!nullToAbsent || reminderAt != null) {
      map['reminder_at'] = Variable<DateTime>(reminderAt);
    }
    map['status'] = Variable<String>(status);
    map['pinned'] = Variable<bool>(pinned);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PostsCompanion toCompanion(bool nullToAbsent) {
    return PostsCompanion(
      id: Value(id),
      title: title == null && nullToAbsent ? const Value.absent() : Value(title),
      body: Value(body),
      threadParts: Value(threadParts),
      link: link == null && nullToAbsent ? const Value.absent() : Value(link),
      poll: poll == null && nullToAbsent ? const Value.absent() : Value(poll),
      hashtags: Value(hashtags),
      mentions: Value(mentions),
      place: place == null && nullToAbsent ? const Value.absent() : Value(place),
      targets: Value(targets),
      youtube: youtube == null && nullToAbsent ? const Value.absent() : Value(youtube),
      language: language == null && nullToAbsent ? const Value.absent() : Value(language),
      contentWarning: contentWarning == null && nullToAbsent ? const Value.absent() : Value(contentWarning),
      firstComment: firstComment == null && nullToAbsent ? const Value.absent() : Value(firstComment),
      reminderAt: reminderAt == null && nullToAbsent ? const Value.absent() : Value(reminderAt),
      status: Value(status),
      pinned: Value(pinned),
      notes: notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PostRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PostRow(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String?>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      threadParts: serializer.fromJson<String>(json['threadParts']),
      link: serializer.fromJson<String?>(json['link']),
      poll: serializer.fromJson<String?>(json['poll']),
      hashtags: serializer.fromJson<String>(json['hashtags']),
      mentions: serializer.fromJson<String>(json['mentions']),
      place: serializer.fromJson<String?>(json['place']),
      targets: serializer.fromJson<String>(json['targets']),
      youtube: serializer.fromJson<String?>(json['youtube']),
      language: serializer.fromJson<String?>(json['language']),
      contentWarning: serializer.fromJson<String?>(json['contentWarning']),
      firstComment: serializer.fromJson<String?>(json['firstComment']),
      reminderAt: serializer.fromJson<DateTime?>(json['reminderAt']),
      status: serializer.fromJson<String>(json['status']),
      pinned: serializer.fromJson<bool>(json['pinned']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String?>(title),
      'body': serializer.toJson<String>(body),
      'threadParts': serializer.toJson<String>(threadParts),
      'link': serializer.toJson<String?>(link),
      'poll': serializer.toJson<String?>(poll),
      'hashtags': serializer.toJson<String>(hashtags),
      'mentions': serializer.toJson<String>(mentions),
      'place': serializer.toJson<String?>(place),
      'targets': serializer.toJson<String>(targets),
      'youtube': serializer.toJson<String?>(youtube),
      'language': serializer.toJson<String?>(language),
      'contentWarning': serializer.toJson<String?>(contentWarning),
      'firstComment': serializer.toJson<String?>(firstComment),
      'reminderAt': serializer.toJson<DateTime?>(reminderAt),
      'status': serializer.toJson<String>(status),
      'pinned': serializer.toJson<bool>(pinned),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PostRow copyWith({
    String? id,
    Value<String?> title = const Value.absent(),
    String? body,
    String? threadParts,
    Value<String?> link = const Value.absent(),
    Value<String?> poll = const Value.absent(),
    String? hashtags,
    String? mentions,
    Value<String?> place = const Value.absent(),
    String? targets,
    Value<String?> youtube = const Value.absent(),
    Value<String?> language = const Value.absent(),
    Value<String?> contentWarning = const Value.absent(),
    Value<String?> firstComment = const Value.absent(),
    Value<DateTime?> reminderAt = const Value.absent(),
    String? status,
    bool? pinned,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PostRow(
    id: id ?? this.id,
    title: title.present ? title.value : this.title,
    body: body ?? this.body,
    threadParts: threadParts ?? this.threadParts,
    link: link.present ? link.value : this.link,
    poll: poll.present ? poll.value : this.poll,
    hashtags: hashtags ?? this.hashtags,
    mentions: mentions ?? this.mentions,
    place: place.present ? place.value : this.place,
    targets: targets ?? this.targets,
    youtube: youtube.present ? youtube.value : this.youtube,
    language: language.present ? language.value : this.language,
    contentWarning: contentWarning.present ? contentWarning.value : this.contentWarning,
    firstComment: firstComment.present ? firstComment.value : this.firstComment,
    reminderAt: reminderAt.present ? reminderAt.value : this.reminderAt,
    status: status ?? this.status,
    pinned: pinned ?? this.pinned,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PostRow copyWithCompanion(PostsCompanion data) {
    return PostRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      threadParts: data.threadParts.present ? data.threadParts.value : this.threadParts,
      link: data.link.present ? data.link.value : this.link,
      poll: data.poll.present ? data.poll.value : this.poll,
      hashtags: data.hashtags.present ? data.hashtags.value : this.hashtags,
      mentions: data.mentions.present ? data.mentions.value : this.mentions,
      place: data.place.present ? data.place.value : this.place,
      targets: data.targets.present ? data.targets.value : this.targets,
      youtube: data.youtube.present ? data.youtube.value : this.youtube,
      language: data.language.present ? data.language.value : this.language,
      contentWarning: data.contentWarning.present ? data.contentWarning.value : this.contentWarning,
      firstComment: data.firstComment.present ? data.firstComment.value : this.firstComment,
      reminderAt: data.reminderAt.present ? data.reminderAt.value : this.reminderAt,
      status: data.status.present ? data.status.value : this.status,
      pinned: data.pinned.present ? data.pinned.value : this.pinned,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PostRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('threadParts: $threadParts, ')
          ..write('link: $link, ')
          ..write('poll: $poll, ')
          ..write('hashtags: $hashtags, ')
          ..write('mentions: $mentions, ')
          ..write('place: $place, ')
          ..write('targets: $targets, ')
          ..write('youtube: $youtube, ')
          ..write('language: $language, ')
          ..write('contentWarning: $contentWarning, ')
          ..write('firstComment: $firstComment, ')
          ..write('reminderAt: $reminderAt, ')
          ..write('status: $status, ')
          ..write('pinned: $pinned, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    body,
    threadParts,
    link,
    poll,
    hashtags,
    mentions,
    place,
    targets,
    youtube,
    language,
    contentWarning,
    firstComment,
    reminderAt,
    status,
    pinned,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PostRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.body == this.body &&
          other.threadParts == this.threadParts &&
          other.link == this.link &&
          other.poll == this.poll &&
          other.hashtags == this.hashtags &&
          other.mentions == this.mentions &&
          other.place == this.place &&
          other.targets == this.targets &&
          other.youtube == this.youtube &&
          other.language == this.language &&
          other.contentWarning == this.contentWarning &&
          other.firstComment == this.firstComment &&
          other.reminderAt == this.reminderAt &&
          other.status == this.status &&
          other.pinned == this.pinned &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PostsCompanion extends UpdateCompanion<PostRow> {
  final Value<String> id;
  final Value<String?> title;
  final Value<String> body;
  final Value<String> threadParts;
  final Value<String?> link;
  final Value<String?> poll;
  final Value<String> hashtags;
  final Value<String> mentions;
  final Value<String?> place;
  final Value<String> targets;
  final Value<String?> youtube;
  final Value<String?> language;
  final Value<String?> contentWarning;
  final Value<String?> firstComment;
  final Value<DateTime?> reminderAt;
  final Value<String> status;
  final Value<bool> pinned;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PostsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.threadParts = const Value.absent(),
    this.link = const Value.absent(),
    this.poll = const Value.absent(),
    this.hashtags = const Value.absent(),
    this.mentions = const Value.absent(),
    this.place = const Value.absent(),
    this.targets = const Value.absent(),
    this.youtube = const Value.absent(),
    this.language = const Value.absent(),
    this.contentWarning = const Value.absent(),
    this.firstComment = const Value.absent(),
    this.reminderAt = const Value.absent(),
    this.status = const Value.absent(),
    this.pinned = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PostsCompanion.insert({
    required String id,
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.threadParts = const Value.absent(),
    this.link = const Value.absent(),
    this.poll = const Value.absent(),
    this.hashtags = const Value.absent(),
    this.mentions = const Value.absent(),
    this.place = const Value.absent(),
    this.targets = const Value.absent(),
    this.youtube = const Value.absent(),
    this.language = const Value.absent(),
    this.contentWarning = const Value.absent(),
    this.firstComment = const Value.absent(),
    this.reminderAt = const Value.absent(),
    this.status = const Value.absent(),
    this.pinned = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<PostRow> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? body,
    Expression<String>? threadParts,
    Expression<String>? link,
    Expression<String>? poll,
    Expression<String>? hashtags,
    Expression<String>? mentions,
    Expression<String>? place,
    Expression<String>? targets,
    Expression<String>? youtube,
    Expression<String>? language,
    Expression<String>? contentWarning,
    Expression<String>? firstComment,
    Expression<DateTime>? reminderAt,
    Expression<String>? status,
    Expression<bool>? pinned,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (threadParts != null) 'thread_parts': threadParts,
      if (link != null) 'link': link,
      if (poll != null) 'poll': poll,
      if (hashtags != null) 'hashtags': hashtags,
      if (mentions != null) 'mentions': mentions,
      if (place != null) 'place': place,
      if (targets != null) 'targets': targets,
      if (youtube != null) 'youtube': youtube,
      if (language != null) 'language': language,
      if (contentWarning != null) 'content_warning': contentWarning,
      if (firstComment != null) 'first_comment': firstComment,
      if (reminderAt != null) 'reminder_at': reminderAt,
      if (status != null) 'status': status,
      if (pinned != null) 'pinned': pinned,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PostsCompanion copyWith({
    Value<String>? id,
    Value<String?>? title,
    Value<String>? body,
    Value<String>? threadParts,
    Value<String?>? link,
    Value<String?>? poll,
    Value<String>? hashtags,
    Value<String>? mentions,
    Value<String?>? place,
    Value<String>? targets,
    Value<String?>? youtube,
    Value<String?>? language,
    Value<String?>? contentWarning,
    Value<String?>? firstComment,
    Value<DateTime?>? reminderAt,
    Value<String>? status,
    Value<bool>? pinned,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PostsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      threadParts: threadParts ?? this.threadParts,
      link: link ?? this.link,
      poll: poll ?? this.poll,
      hashtags: hashtags ?? this.hashtags,
      mentions: mentions ?? this.mentions,
      place: place ?? this.place,
      targets: targets ?? this.targets,
      youtube: youtube ?? this.youtube,
      language: language ?? this.language,
      contentWarning: contentWarning ?? this.contentWarning,
      firstComment: firstComment ?? this.firstComment,
      reminderAt: reminderAt ?? this.reminderAt,
      status: status ?? this.status,
      pinned: pinned ?? this.pinned,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (threadParts.present) {
      map['thread_parts'] = Variable<String>(threadParts.value);
    }
    if (link.present) {
      map['link'] = Variable<String>(link.value);
    }
    if (poll.present) {
      map['poll'] = Variable<String>(poll.value);
    }
    if (hashtags.present) {
      map['hashtags'] = Variable<String>(hashtags.value);
    }
    if (mentions.present) {
      map['mentions'] = Variable<String>(mentions.value);
    }
    if (place.present) {
      map['place'] = Variable<String>(place.value);
    }
    if (targets.present) {
      map['targets'] = Variable<String>(targets.value);
    }
    if (youtube.present) {
      map['youtube'] = Variable<String>(youtube.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (contentWarning.present) {
      map['content_warning'] = Variable<String>(contentWarning.value);
    }
    if (firstComment.present) {
      map['first_comment'] = Variable<String>(firstComment.value);
    }
    if (reminderAt.present) {
      map['reminder_at'] = Variable<DateTime>(reminderAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (pinned.present) {
      map['pinned'] = Variable<bool>(pinned.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PostsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('threadParts: $threadParts, ')
          ..write('link: $link, ')
          ..write('poll: $poll, ')
          ..write('hashtags: $hashtags, ')
          ..write('mentions: $mentions, ')
          ..write('place: $place, ')
          ..write('targets: $targets, ')
          ..write('youtube: $youtube, ')
          ..write('language: $language, ')
          ..write('contentWarning: $contentWarning, ')
          ..write('firstComment: $firstComment, ')
          ..write('reminderAt: $reminderAt, ')
          ..write('status: $status, ')
          ..write('pinned: $pinned, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AttachmentsTable extends Attachments with TableInfo<$AttachmentsTable, AttachmentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttachmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _postIdMeta = const VerificationMeta('postId');
  @override
  late final GeneratedColumn<String> postId = GeneratedColumn<String>(
    'post_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES posts (id) ON DELETE CASCADE'),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileNameMeta = const VerificationMeta('fileName');
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
    'file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _relativePathMeta = const VerificationMeta('relativePath');
  @override
  late final GeneratedColumn<String> relativePath = GeneratedColumn<String>(
    'relative_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mimeTypeMeta = const VerificationMeta('mimeType');
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
    'mime_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sizeBytesMeta = const VerificationMeta('sizeBytes');
  @override
  late final GeneratedColumn<int> sizeBytes = GeneratedColumn<int>(
    'size_bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sha256Meta = const VerificationMeta('sha256');
  @override
  late final GeneratedColumn<String> sha256 = GeneratedColumn<String>(
    'sha256',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _widthMeta = const VerificationMeta('width');
  @override
  late final GeneratedColumn<int> width = GeneratedColumn<int>(
    'width',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<int> height = GeneratedColumn<int>(
    'height',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta('durationMs');
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _altTextMeta = const VerificationMeta('altText');
  @override
  late final GeneratedColumn<String> altText = GeneratedColumn<String>(
    'alt_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _coverFrameMsMeta = const VerificationMeta('coverFrameMs');
  @override
  late final GeneratedColumn<int> coverFrameMs = GeneratedColumn<int>(
    'cover_frame_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cropMeta = const VerificationMeta('crop');
  @override
  late final GeneratedColumn<String> crop = GeneratedColumn<String>(
    'crop',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mediaInfoMeta = const VerificationMeta('mediaInfo');
  @override
  late final GeneratedColumn<String> mediaInfo = GeneratedColumn<String>(
    'media_info',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _thumbPathMeta = const VerificationMeta('thumbPath');
  @override
  late final GeneratedColumn<String> thumbPath = GeneratedColumn<String>(
    'thumb_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    postId,
    position,
    kind,
    fileName,
    relativePath,
    mimeType,
    sizeBytes,
    sha256,
    width,
    height,
    durationMs,
    altText,
    coverFrameMs,
    crop,
    mediaInfo,
    thumbPath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attachments';
  @override
  VerificationContext validateIntegrity(Insertable<AttachmentRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('post_id')) {
      context.handle(_postIdMeta, postId.isAcceptableOrUnknown(data['post_id']!, _postIdMeta));
    } else if (isInserting) {
      context.missing(_postIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta, position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(_kindMeta, kind.isAcceptableOrUnknown(data['kind']!, _kindMeta));
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('file_name')) {
      context.handle(_fileNameMeta, fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta));
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('relative_path')) {
      context.handle(_relativePathMeta, relativePath.isAcceptableOrUnknown(data['relative_path']!, _relativePathMeta));
    } else if (isInserting) {
      context.missing(_relativePathMeta);
    }
    if (data.containsKey('mime_type')) {
      context.handle(_mimeTypeMeta, mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta));
    } else if (isInserting) {
      context.missing(_mimeTypeMeta);
    }
    if (data.containsKey('size_bytes')) {
      context.handle(_sizeBytesMeta, sizeBytes.isAcceptableOrUnknown(data['size_bytes']!, _sizeBytesMeta));
    } else if (isInserting) {
      context.missing(_sizeBytesMeta);
    }
    if (data.containsKey('sha256')) {
      context.handle(_sha256Meta, sha256.isAcceptableOrUnknown(data['sha256']!, _sha256Meta));
    } else if (isInserting) {
      context.missing(_sha256Meta);
    }
    if (data.containsKey('width')) {
      context.handle(_widthMeta, width.isAcceptableOrUnknown(data['width']!, _widthMeta));
    }
    if (data.containsKey('height')) {
      context.handle(_heightMeta, height.isAcceptableOrUnknown(data['height']!, _heightMeta));
    }
    if (data.containsKey('duration_ms')) {
      context.handle(_durationMsMeta, durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta));
    }
    if (data.containsKey('alt_text')) {
      context.handle(_altTextMeta, altText.isAcceptableOrUnknown(data['alt_text']!, _altTextMeta));
    }
    if (data.containsKey('cover_frame_ms')) {
      context.handle(_coverFrameMsMeta, coverFrameMs.isAcceptableOrUnknown(data['cover_frame_ms']!, _coverFrameMsMeta));
    }
    if (data.containsKey('crop')) {
      context.handle(_cropMeta, crop.isAcceptableOrUnknown(data['crop']!, _cropMeta));
    }
    if (data.containsKey('media_info')) {
      context.handle(_mediaInfoMeta, mediaInfo.isAcceptableOrUnknown(data['media_info']!, _mediaInfoMeta));
    }
    if (data.containsKey('thumb_path')) {
      context.handle(_thumbPathMeta, thumbPath.isAcceptableOrUnknown(data['thumb_path']!, _thumbPathMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AttachmentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AttachmentRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      postId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}post_id'])!,
      position: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      kind: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}kind'])!,
      fileName: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}file_name'])!,
      relativePath: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}relative_path'])!,
      mimeType: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}mime_type'])!,
      sizeBytes: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}size_bytes'])!,
      sha256: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}sha256'])!,
      width: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}width']),
      height: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}height']),
      durationMs: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}duration_ms']),
      altText: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}alt_text']),
      coverFrameMs: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}cover_frame_ms']),
      crop: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}crop']),
      mediaInfo: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}media_info']),
      thumbPath: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}thumb_path']),
    );
  }

  @override
  $AttachmentsTable createAlias(String alias) {
    return $AttachmentsTable(attachedDatabase, alias);
  }
}

class AttachmentRow extends DataClass implements Insertable<AttachmentRow> {
  final String id;
  final String postId;
  final int position;
  final String kind;
  final String fileName;
  final String relativePath;
  final String mimeType;
  final int sizeBytes;
  final String sha256;
  final int? width;
  final int? height;
  final int? durationMs;
  final String? altText;
  final int? coverFrameMs;
  final String? crop;

  /// Media probe result (JSON) and preview frame path, added in schema 2.
  final String? mediaInfo;
  final String? thumbPath;
  const AttachmentRow({
    required this.id,
    required this.postId,
    required this.position,
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
    this.crop,
    this.mediaInfo,
    this.thumbPath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['post_id'] = Variable<String>(postId);
    map['position'] = Variable<int>(position);
    map['kind'] = Variable<String>(kind);
    map['file_name'] = Variable<String>(fileName);
    map['relative_path'] = Variable<String>(relativePath);
    map['mime_type'] = Variable<String>(mimeType);
    map['size_bytes'] = Variable<int>(sizeBytes);
    map['sha256'] = Variable<String>(sha256);
    if (!nullToAbsent || width != null) {
      map['width'] = Variable<int>(width);
    }
    if (!nullToAbsent || height != null) {
      map['height'] = Variable<int>(height);
    }
    if (!nullToAbsent || durationMs != null) {
      map['duration_ms'] = Variable<int>(durationMs);
    }
    if (!nullToAbsent || altText != null) {
      map['alt_text'] = Variable<String>(altText);
    }
    if (!nullToAbsent || coverFrameMs != null) {
      map['cover_frame_ms'] = Variable<int>(coverFrameMs);
    }
    if (!nullToAbsent || crop != null) {
      map['crop'] = Variable<String>(crop);
    }
    if (!nullToAbsent || mediaInfo != null) {
      map['media_info'] = Variable<String>(mediaInfo);
    }
    if (!nullToAbsent || thumbPath != null) {
      map['thumb_path'] = Variable<String>(thumbPath);
    }
    return map;
  }

  AttachmentsCompanion toCompanion(bool nullToAbsent) {
    return AttachmentsCompanion(
      id: Value(id),
      postId: Value(postId),
      position: Value(position),
      kind: Value(kind),
      fileName: Value(fileName),
      relativePath: Value(relativePath),
      mimeType: Value(mimeType),
      sizeBytes: Value(sizeBytes),
      sha256: Value(sha256),
      width: width == null && nullToAbsent ? const Value.absent() : Value(width),
      height: height == null && nullToAbsent ? const Value.absent() : Value(height),
      durationMs: durationMs == null && nullToAbsent ? const Value.absent() : Value(durationMs),
      altText: altText == null && nullToAbsent ? const Value.absent() : Value(altText),
      coverFrameMs: coverFrameMs == null && nullToAbsent ? const Value.absent() : Value(coverFrameMs),
      crop: crop == null && nullToAbsent ? const Value.absent() : Value(crop),
      mediaInfo: mediaInfo == null && nullToAbsent ? const Value.absent() : Value(mediaInfo),
      thumbPath: thumbPath == null && nullToAbsent ? const Value.absent() : Value(thumbPath),
    );
  }

  factory AttachmentRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AttachmentRow(
      id: serializer.fromJson<String>(json['id']),
      postId: serializer.fromJson<String>(json['postId']),
      position: serializer.fromJson<int>(json['position']),
      kind: serializer.fromJson<String>(json['kind']),
      fileName: serializer.fromJson<String>(json['fileName']),
      relativePath: serializer.fromJson<String>(json['relativePath']),
      mimeType: serializer.fromJson<String>(json['mimeType']),
      sizeBytes: serializer.fromJson<int>(json['sizeBytes']),
      sha256: serializer.fromJson<String>(json['sha256']),
      width: serializer.fromJson<int?>(json['width']),
      height: serializer.fromJson<int?>(json['height']),
      durationMs: serializer.fromJson<int?>(json['durationMs']),
      altText: serializer.fromJson<String?>(json['altText']),
      coverFrameMs: serializer.fromJson<int?>(json['coverFrameMs']),
      crop: serializer.fromJson<String?>(json['crop']),
      mediaInfo: serializer.fromJson<String?>(json['mediaInfo']),
      thumbPath: serializer.fromJson<String?>(json['thumbPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'postId': serializer.toJson<String>(postId),
      'position': serializer.toJson<int>(position),
      'kind': serializer.toJson<String>(kind),
      'fileName': serializer.toJson<String>(fileName),
      'relativePath': serializer.toJson<String>(relativePath),
      'mimeType': serializer.toJson<String>(mimeType),
      'sizeBytes': serializer.toJson<int>(sizeBytes),
      'sha256': serializer.toJson<String>(sha256),
      'width': serializer.toJson<int?>(width),
      'height': serializer.toJson<int?>(height),
      'durationMs': serializer.toJson<int?>(durationMs),
      'altText': serializer.toJson<String?>(altText),
      'coverFrameMs': serializer.toJson<int?>(coverFrameMs),
      'crop': serializer.toJson<String?>(crop),
      'mediaInfo': serializer.toJson<String?>(mediaInfo),
      'thumbPath': serializer.toJson<String?>(thumbPath),
    };
  }

  AttachmentRow copyWith({
    String? id,
    String? postId,
    int? position,
    String? kind,
    String? fileName,
    String? relativePath,
    String? mimeType,
    int? sizeBytes,
    String? sha256,
    Value<int?> width = const Value.absent(),
    Value<int?> height = const Value.absent(),
    Value<int?> durationMs = const Value.absent(),
    Value<String?> altText = const Value.absent(),
    Value<int?> coverFrameMs = const Value.absent(),
    Value<String?> crop = const Value.absent(),
    Value<String?> mediaInfo = const Value.absent(),
    Value<String?> thumbPath = const Value.absent(),
  }) => AttachmentRow(
    id: id ?? this.id,
    postId: postId ?? this.postId,
    position: position ?? this.position,
    kind: kind ?? this.kind,
    fileName: fileName ?? this.fileName,
    relativePath: relativePath ?? this.relativePath,
    mimeType: mimeType ?? this.mimeType,
    sizeBytes: sizeBytes ?? this.sizeBytes,
    sha256: sha256 ?? this.sha256,
    width: width.present ? width.value : this.width,
    height: height.present ? height.value : this.height,
    durationMs: durationMs.present ? durationMs.value : this.durationMs,
    altText: altText.present ? altText.value : this.altText,
    coverFrameMs: coverFrameMs.present ? coverFrameMs.value : this.coverFrameMs,
    crop: crop.present ? crop.value : this.crop,
    mediaInfo: mediaInfo.present ? mediaInfo.value : this.mediaInfo,
    thumbPath: thumbPath.present ? thumbPath.value : this.thumbPath,
  );
  AttachmentRow copyWithCompanion(AttachmentsCompanion data) {
    return AttachmentRow(
      id: data.id.present ? data.id.value : this.id,
      postId: data.postId.present ? data.postId.value : this.postId,
      position: data.position.present ? data.position.value : this.position,
      kind: data.kind.present ? data.kind.value : this.kind,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      relativePath: data.relativePath.present ? data.relativePath.value : this.relativePath,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      sizeBytes: data.sizeBytes.present ? data.sizeBytes.value : this.sizeBytes,
      sha256: data.sha256.present ? data.sha256.value : this.sha256,
      width: data.width.present ? data.width.value : this.width,
      height: data.height.present ? data.height.value : this.height,
      durationMs: data.durationMs.present ? data.durationMs.value : this.durationMs,
      altText: data.altText.present ? data.altText.value : this.altText,
      coverFrameMs: data.coverFrameMs.present ? data.coverFrameMs.value : this.coverFrameMs,
      crop: data.crop.present ? data.crop.value : this.crop,
      mediaInfo: data.mediaInfo.present ? data.mediaInfo.value : this.mediaInfo,
      thumbPath: data.thumbPath.present ? data.thumbPath.value : this.thumbPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AttachmentRow(')
          ..write('id: $id, ')
          ..write('postId: $postId, ')
          ..write('position: $position, ')
          ..write('kind: $kind, ')
          ..write('fileName: $fileName, ')
          ..write('relativePath: $relativePath, ')
          ..write('mimeType: $mimeType, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('sha256: $sha256, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('durationMs: $durationMs, ')
          ..write('altText: $altText, ')
          ..write('coverFrameMs: $coverFrameMs, ')
          ..write('crop: $crop, ')
          ..write('mediaInfo: $mediaInfo, ')
          ..write('thumbPath: $thumbPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    postId,
    position,
    kind,
    fileName,
    relativePath,
    mimeType,
    sizeBytes,
    sha256,
    width,
    height,
    durationMs,
    altText,
    coverFrameMs,
    crop,
    mediaInfo,
    thumbPath,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttachmentRow &&
          other.id == this.id &&
          other.postId == this.postId &&
          other.position == this.position &&
          other.kind == this.kind &&
          other.fileName == this.fileName &&
          other.relativePath == this.relativePath &&
          other.mimeType == this.mimeType &&
          other.sizeBytes == this.sizeBytes &&
          other.sha256 == this.sha256 &&
          other.width == this.width &&
          other.height == this.height &&
          other.durationMs == this.durationMs &&
          other.altText == this.altText &&
          other.coverFrameMs == this.coverFrameMs &&
          other.crop == this.crop &&
          other.mediaInfo == this.mediaInfo &&
          other.thumbPath == this.thumbPath);
}

class AttachmentsCompanion extends UpdateCompanion<AttachmentRow> {
  final Value<String> id;
  final Value<String> postId;
  final Value<int> position;
  final Value<String> kind;
  final Value<String> fileName;
  final Value<String> relativePath;
  final Value<String> mimeType;
  final Value<int> sizeBytes;
  final Value<String> sha256;
  final Value<int?> width;
  final Value<int?> height;
  final Value<int?> durationMs;
  final Value<String?> altText;
  final Value<int?> coverFrameMs;
  final Value<String?> crop;
  final Value<String?> mediaInfo;
  final Value<String?> thumbPath;
  final Value<int> rowid;
  const AttachmentsCompanion({
    this.id = const Value.absent(),
    this.postId = const Value.absent(),
    this.position = const Value.absent(),
    this.kind = const Value.absent(),
    this.fileName = const Value.absent(),
    this.relativePath = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.sha256 = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.altText = const Value.absent(),
    this.coverFrameMs = const Value.absent(),
    this.crop = const Value.absent(),
    this.mediaInfo = const Value.absent(),
    this.thumbPath = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AttachmentsCompanion.insert({
    required String id,
    required String postId,
    required int position,
    required String kind,
    required String fileName,
    required String relativePath,
    required String mimeType,
    required int sizeBytes,
    required String sha256,
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.altText = const Value.absent(),
    this.coverFrameMs = const Value.absent(),
    this.crop = const Value.absent(),
    this.mediaInfo = const Value.absent(),
    this.thumbPath = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       postId = Value(postId),
       position = Value(position),
       kind = Value(kind),
       fileName = Value(fileName),
       relativePath = Value(relativePath),
       mimeType = Value(mimeType),
       sizeBytes = Value(sizeBytes),
       sha256 = Value(sha256);
  static Insertable<AttachmentRow> custom({
    Expression<String>? id,
    Expression<String>? postId,
    Expression<int>? position,
    Expression<String>? kind,
    Expression<String>? fileName,
    Expression<String>? relativePath,
    Expression<String>? mimeType,
    Expression<int>? sizeBytes,
    Expression<String>? sha256,
    Expression<int>? width,
    Expression<int>? height,
    Expression<int>? durationMs,
    Expression<String>? altText,
    Expression<int>? coverFrameMs,
    Expression<String>? crop,
    Expression<String>? mediaInfo,
    Expression<String>? thumbPath,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (postId != null) 'post_id': postId,
      if (position != null) 'position': position,
      if (kind != null) 'kind': kind,
      if (fileName != null) 'file_name': fileName,
      if (relativePath != null) 'relative_path': relativePath,
      if (mimeType != null) 'mime_type': mimeType,
      if (sizeBytes != null) 'size_bytes': sizeBytes,
      if (sha256 != null) 'sha256': sha256,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (durationMs != null) 'duration_ms': durationMs,
      if (altText != null) 'alt_text': altText,
      if (coverFrameMs != null) 'cover_frame_ms': coverFrameMs,
      if (crop != null) 'crop': crop,
      if (mediaInfo != null) 'media_info': mediaInfo,
      if (thumbPath != null) 'thumb_path': thumbPath,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AttachmentsCompanion copyWith({
    Value<String>? id,
    Value<String>? postId,
    Value<int>? position,
    Value<String>? kind,
    Value<String>? fileName,
    Value<String>? relativePath,
    Value<String>? mimeType,
    Value<int>? sizeBytes,
    Value<String>? sha256,
    Value<int?>? width,
    Value<int?>? height,
    Value<int?>? durationMs,
    Value<String?>? altText,
    Value<int?>? coverFrameMs,
    Value<String?>? crop,
    Value<String?>? mediaInfo,
    Value<String?>? thumbPath,
    Value<int>? rowid,
  }) {
    return AttachmentsCompanion(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      position: position ?? this.position,
      kind: kind ?? this.kind,
      fileName: fileName ?? this.fileName,
      relativePath: relativePath ?? this.relativePath,
      mimeType: mimeType ?? this.mimeType,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      sha256: sha256 ?? this.sha256,
      width: width ?? this.width,
      height: height ?? this.height,
      durationMs: durationMs ?? this.durationMs,
      altText: altText ?? this.altText,
      coverFrameMs: coverFrameMs ?? this.coverFrameMs,
      crop: crop ?? this.crop,
      mediaInfo: mediaInfo ?? this.mediaInfo,
      thumbPath: thumbPath ?? this.thumbPath,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (postId.present) {
      map['post_id'] = Variable<String>(postId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (relativePath.present) {
      map['relative_path'] = Variable<String>(relativePath.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (sizeBytes.present) {
      map['size_bytes'] = Variable<int>(sizeBytes.value);
    }
    if (sha256.present) {
      map['sha256'] = Variable<String>(sha256.value);
    }
    if (width.present) {
      map['width'] = Variable<int>(width.value);
    }
    if (height.present) {
      map['height'] = Variable<int>(height.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (altText.present) {
      map['alt_text'] = Variable<String>(altText.value);
    }
    if (coverFrameMs.present) {
      map['cover_frame_ms'] = Variable<int>(coverFrameMs.value);
    }
    if (crop.present) {
      map['crop'] = Variable<String>(crop.value);
    }
    if (mediaInfo.present) {
      map['media_info'] = Variable<String>(mediaInfo.value);
    }
    if (thumbPath.present) {
      map['thumb_path'] = Variable<String>(thumbPath.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttachmentsCompanion(')
          ..write('id: $id, ')
          ..write('postId: $postId, ')
          ..write('position: $position, ')
          ..write('kind: $kind, ')
          ..write('fileName: $fileName, ')
          ..write('relativePath: $relativePath, ')
          ..write('mimeType: $mimeType, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('sha256: $sha256, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('durationMs: $durationMs, ')
          ..write('altText: $altText, ')
          ..write('coverFrameMs: $coverFrameMs, ')
          ..write('crop: $crop, ')
          ..write('mediaInfo: $mediaInfo, ')
          ..write('thumbPath: $thumbPath, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CollectionsTable extends Collections with TableInfo<$CollectionsTable, CollectionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CollectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'collections';
  @override
  VerificationContext validateIntegrity(Insertable<CollectionRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CollectionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CollectionRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $CollectionsTable createAlias(String alias) {
    return $CollectionsTable(attachedDatabase, alias);
  }
}

class CollectionRow extends DataClass implements Insertable<CollectionRow> {
  final String id;
  final String name;
  final DateTime createdAt;
  const CollectionRow({required this.id, required this.name, required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CollectionsCompanion toCompanion(bool nullToAbsent) {
    return CollectionsCompanion(id: Value(id), name: Value(name), createdAt: Value(createdAt));
  }

  factory CollectionRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CollectionRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CollectionRow copyWith({String? id, String? name, DateTime? createdAt}) =>
      CollectionRow(id: id ?? this.id, name: name ?? this.name, createdAt: createdAt ?? this.createdAt);
  CollectionRow copyWithCompanion(CollectionsCompanion data) {
    return CollectionRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CollectionRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CollectionRow && other.id == this.id && other.name == this.name && other.createdAt == this.createdAt);
}

class CollectionsCompanion extends UpdateCompanion<CollectionRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CollectionsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CollectionsCompanion.insert({
    required String id,
    required String name,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<CollectionRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CollectionsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return CollectionsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CollectionsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PostCollectionsTable extends PostCollections with TableInfo<$PostCollectionsTable, PostCollectionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PostCollectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _postIdMeta = const VerificationMeta('postId');
  @override
  late final GeneratedColumn<String> postId = GeneratedColumn<String>(
    'post_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES posts (id) ON DELETE CASCADE'),
  );
  static const VerificationMeta _collectionIdMeta = const VerificationMeta('collectionId');
  @override
  late final GeneratedColumn<String> collectionId = GeneratedColumn<String>(
    'collection_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES collections (id) ON DELETE CASCADE'),
  );
  @override
  List<GeneratedColumn> get $columns => [postId, collectionId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'post_collections';
  @override
  VerificationContext validateIntegrity(Insertable<PostCollectionRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('post_id')) {
      context.handle(_postIdMeta, postId.isAcceptableOrUnknown(data['post_id']!, _postIdMeta));
    } else if (isInserting) {
      context.missing(_postIdMeta);
    }
    if (data.containsKey('collection_id')) {
      context.handle(_collectionIdMeta, collectionId.isAcceptableOrUnknown(data['collection_id']!, _collectionIdMeta));
    } else if (isInserting) {
      context.missing(_collectionIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {postId, collectionId};
  @override
  PostCollectionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PostCollectionRow(
      postId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}post_id'])!,
      collectionId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}collection_id'])!,
    );
  }

  @override
  $PostCollectionsTable createAlias(String alias) {
    return $PostCollectionsTable(attachedDatabase, alias);
  }
}

class PostCollectionRow extends DataClass implements Insertable<PostCollectionRow> {
  final String postId;
  final String collectionId;
  const PostCollectionRow({required this.postId, required this.collectionId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['post_id'] = Variable<String>(postId);
    map['collection_id'] = Variable<String>(collectionId);
    return map;
  }

  PostCollectionsCompanion toCompanion(bool nullToAbsent) {
    return PostCollectionsCompanion(postId: Value(postId), collectionId: Value(collectionId));
  }

  factory PostCollectionRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PostCollectionRow(
      postId: serializer.fromJson<String>(json['postId']),
      collectionId: serializer.fromJson<String>(json['collectionId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'postId': serializer.toJson<String>(postId),
      'collectionId': serializer.toJson<String>(collectionId),
    };
  }

  PostCollectionRow copyWith({String? postId, String? collectionId}) =>
      PostCollectionRow(postId: postId ?? this.postId, collectionId: collectionId ?? this.collectionId);
  PostCollectionRow copyWithCompanion(PostCollectionsCompanion data) {
    return PostCollectionRow(
      postId: data.postId.present ? data.postId.value : this.postId,
      collectionId: data.collectionId.present ? data.collectionId.value : this.collectionId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PostCollectionRow(')
          ..write('postId: $postId, ')
          ..write('collectionId: $collectionId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(postId, collectionId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PostCollectionRow && other.postId == this.postId && other.collectionId == this.collectionId);
}

class PostCollectionsCompanion extends UpdateCompanion<PostCollectionRow> {
  final Value<String> postId;
  final Value<String> collectionId;
  final Value<int> rowid;
  const PostCollectionsCompanion({
    this.postId = const Value.absent(),
    this.collectionId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PostCollectionsCompanion.insert({
    required String postId,
    required String collectionId,
    this.rowid = const Value.absent(),
  }) : postId = Value(postId),
       collectionId = Value(collectionId);
  static Insertable<PostCollectionRow> custom({
    Expression<String>? postId,
    Expression<String>? collectionId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (postId != null) 'post_id': postId,
      if (collectionId != null) 'collection_id': collectionId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PostCollectionsCompanion copyWith({Value<String>? postId, Value<String>? collectionId, Value<int>? rowid}) {
    return PostCollectionsCompanion(
      postId: postId ?? this.postId,
      collectionId: collectionId ?? this.collectionId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (postId.present) {
      map['post_id'] = Variable<String>(postId.value);
    }
    if (collectionId.present) {
      map['collection_id'] = Variable<String>(collectionId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PostCollectionsCompanion(')
          ..write('postId: $postId, ')
          ..write('collectionId: $collectionId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShareEventsTable extends ShareEvents with TableInfo<$ShareEventsTable, ShareEventRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShareEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _postIdMeta = const VerificationMeta('postId');
  @override
  late final GeneratedColumn<String> postId = GeneratedColumn<String>(
    'post_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES posts (id) ON DELETE CASCADE'),
  );
  static const VerificationMeta _targetMeta = const VerificationMeta('target');
  @override
  late final GeneratedColumn<String> target = GeneratedColumn<String>(
    'target',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sharedAtMeta = const VerificationMeta('sharedAt');
  @override
  late final GeneratedColumn<DateTime> sharedAt = GeneratedColumn<DateTime>(
    'shared_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _liveUrlMeta = const VerificationMeta('liveUrl');
  @override
  late final GeneratedColumn<String> liveUrl = GeneratedColumn<String>(
    'live_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, postId, target, sharedAt, liveUrl];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'share_events';
  @override
  VerificationContext validateIntegrity(Insertable<ShareEventRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('post_id')) {
      context.handle(_postIdMeta, postId.isAcceptableOrUnknown(data['post_id']!, _postIdMeta));
    } else if (isInserting) {
      context.missing(_postIdMeta);
    }
    if (data.containsKey('target')) {
      context.handle(_targetMeta, target.isAcceptableOrUnknown(data['target']!, _targetMeta));
    } else if (isInserting) {
      context.missing(_targetMeta);
    }
    if (data.containsKey('shared_at')) {
      context.handle(_sharedAtMeta, sharedAt.isAcceptableOrUnknown(data['shared_at']!, _sharedAtMeta));
    } else if (isInserting) {
      context.missing(_sharedAtMeta);
    }
    if (data.containsKey('live_url')) {
      context.handle(_liveUrlMeta, liveUrl.isAcceptableOrUnknown(data['live_url']!, _liveUrlMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShareEventRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShareEventRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      postId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}post_id'])!,
      target: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}target'])!,
      sharedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}shared_at'])!,
      liveUrl: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}live_url']),
    );
  }

  @override
  $ShareEventsTable createAlias(String alias) {
    return $ShareEventsTable(attachedDatabase, alias);
  }
}

class ShareEventRow extends DataClass implements Insertable<ShareEventRow> {
  final String id;
  final String postId;
  final String target;
  final DateTime sharedAt;
  final String? liveUrl;
  const ShareEventRow({
    required this.id,
    required this.postId,
    required this.target,
    required this.sharedAt,
    this.liveUrl,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['post_id'] = Variable<String>(postId);
    map['target'] = Variable<String>(target);
    map['shared_at'] = Variable<DateTime>(sharedAt);
    if (!nullToAbsent || liveUrl != null) {
      map['live_url'] = Variable<String>(liveUrl);
    }
    return map;
  }

  ShareEventsCompanion toCompanion(bool nullToAbsent) {
    return ShareEventsCompanion(
      id: Value(id),
      postId: Value(postId),
      target: Value(target),
      sharedAt: Value(sharedAt),
      liveUrl: liveUrl == null && nullToAbsent ? const Value.absent() : Value(liveUrl),
    );
  }

  factory ShareEventRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShareEventRow(
      id: serializer.fromJson<String>(json['id']),
      postId: serializer.fromJson<String>(json['postId']),
      target: serializer.fromJson<String>(json['target']),
      sharedAt: serializer.fromJson<DateTime>(json['sharedAt']),
      liveUrl: serializer.fromJson<String?>(json['liveUrl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'postId': serializer.toJson<String>(postId),
      'target': serializer.toJson<String>(target),
      'sharedAt': serializer.toJson<DateTime>(sharedAt),
      'liveUrl': serializer.toJson<String?>(liveUrl),
    };
  }

  ShareEventRow copyWith({
    String? id,
    String? postId,
    String? target,
    DateTime? sharedAt,
    Value<String?> liveUrl = const Value.absent(),
  }) => ShareEventRow(
    id: id ?? this.id,
    postId: postId ?? this.postId,
    target: target ?? this.target,
    sharedAt: sharedAt ?? this.sharedAt,
    liveUrl: liveUrl.present ? liveUrl.value : this.liveUrl,
  );
  ShareEventRow copyWithCompanion(ShareEventsCompanion data) {
    return ShareEventRow(
      id: data.id.present ? data.id.value : this.id,
      postId: data.postId.present ? data.postId.value : this.postId,
      target: data.target.present ? data.target.value : this.target,
      sharedAt: data.sharedAt.present ? data.sharedAt.value : this.sharedAt,
      liveUrl: data.liveUrl.present ? data.liveUrl.value : this.liveUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShareEventRow(')
          ..write('id: $id, ')
          ..write('postId: $postId, ')
          ..write('target: $target, ')
          ..write('sharedAt: $sharedAt, ')
          ..write('liveUrl: $liveUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, postId, target, sharedAt, liveUrl);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShareEventRow &&
          other.id == this.id &&
          other.postId == this.postId &&
          other.target == this.target &&
          other.sharedAt == this.sharedAt &&
          other.liveUrl == this.liveUrl);
}

class ShareEventsCompanion extends UpdateCompanion<ShareEventRow> {
  final Value<String> id;
  final Value<String> postId;
  final Value<String> target;
  final Value<DateTime> sharedAt;
  final Value<String?> liveUrl;
  final Value<int> rowid;
  const ShareEventsCompanion({
    this.id = const Value.absent(),
    this.postId = const Value.absent(),
    this.target = const Value.absent(),
    this.sharedAt = const Value.absent(),
    this.liveUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShareEventsCompanion.insert({
    required String id,
    required String postId,
    required String target,
    required DateTime sharedAt,
    this.liveUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       postId = Value(postId),
       target = Value(target),
       sharedAt = Value(sharedAt);
  static Insertable<ShareEventRow> custom({
    Expression<String>? id,
    Expression<String>? postId,
    Expression<String>? target,
    Expression<DateTime>? sharedAt,
    Expression<String>? liveUrl,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (postId != null) 'post_id': postId,
      if (target != null) 'target': target,
      if (sharedAt != null) 'shared_at': sharedAt,
      if (liveUrl != null) 'live_url': liveUrl,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShareEventsCompanion copyWith({
    Value<String>? id,
    Value<String>? postId,
    Value<String>? target,
    Value<DateTime>? sharedAt,
    Value<String?>? liveUrl,
    Value<int>? rowid,
  }) {
    return ShareEventsCompanion(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      target: target ?? this.target,
      sharedAt: sharedAt ?? this.sharedAt,
      liveUrl: liveUrl ?? this.liveUrl,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (postId.present) {
      map['post_id'] = Variable<String>(postId.value);
    }
    if (target.present) {
      map['target'] = Variable<String>(target.value);
    }
    if (sharedAt.present) {
      map['shared_at'] = Variable<DateTime>(sharedAt.value);
    }
    if (liveUrl.present) {
      map['live_url'] = Variable<String>(liveUrl.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShareEventsCompanion(')
          ..write('id: $id, ')
          ..write('postId: $postId, ')
          ..write('target: $target, ')
          ..write('sharedAt: $sharedAt, ')
          ..write('liveUrl: $liveUrl, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PostsTable posts = $PostsTable(this);
  late final $AttachmentsTable attachments = $AttachmentsTable(this);
  late final $CollectionsTable collections = $CollectionsTable(this);
  late final $PostCollectionsTable postCollections = $PostCollectionsTable(this);
  late final $ShareEventsTable shareEvents = $ShareEventsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables => allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [posts, attachments, collections, postCollections, shareEvents];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName('posts', limitUpdateKind: UpdateKind.delete),
      result: [TableUpdate('attachments', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName('posts', limitUpdateKind: UpdateKind.delete),
      result: [TableUpdate('post_collections', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName('collections', limitUpdateKind: UpdateKind.delete),
      result: [TableUpdate('post_collections', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName('posts', limitUpdateKind: UpdateKind.delete),
      result: [TableUpdate('share_events', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$PostsTableCreateCompanionBuilder =
    PostsCompanion Function({
      required String id,
      Value<String?> title,
      Value<String> body,
      Value<String> threadParts,
      Value<String?> link,
      Value<String?> poll,
      Value<String> hashtags,
      Value<String> mentions,
      Value<String?> place,
      Value<String> targets,
      Value<String?> youtube,
      Value<String?> language,
      Value<String?> contentWarning,
      Value<String?> firstComment,
      Value<DateTime?> reminderAt,
      Value<String> status,
      Value<bool> pinned,
      Value<String?> notes,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$PostsTableUpdateCompanionBuilder =
    PostsCompanion Function({
      Value<String> id,
      Value<String?> title,
      Value<String> body,
      Value<String> threadParts,
      Value<String?> link,
      Value<String?> poll,
      Value<String> hashtags,
      Value<String> mentions,
      Value<String?> place,
      Value<String> targets,
      Value<String?> youtube,
      Value<String?> language,
      Value<String?> contentWarning,
      Value<String?> firstComment,
      Value<DateTime?> reminderAt,
      Value<String> status,
      Value<bool> pinned,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$PostsTableReferences extends BaseReferences<_$AppDatabase, $PostsTable, PostRow> {
  $$PostsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AttachmentsTable, List<AttachmentRow>> _attachmentsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.attachments, aliasName: 'posts__id__attachments__post_id');

  $$AttachmentsTableProcessedTableManager get attachmentsRefs {
    final manager = $$AttachmentsTableTableManager(
      $_db,
      $_db.attachments,
    ).filter((f) => f.postId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_attachmentsRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PostCollectionsTable, List<PostCollectionRow>> _postCollectionsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(db.postCollections, aliasName: 'posts__id__post_collections__post_id');

  $$PostCollectionsTableProcessedTableManager get postCollectionsRefs {
    final manager = $$PostCollectionsTableTableManager(
      $_db,
      $_db.postCollections,
    ).filter((f) => f.postId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_postCollectionsRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ShareEventsTable, List<ShareEventRow>> _shareEventsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.shareEvents, aliasName: 'posts__id__share_events__post_id');

  $$ShareEventsTableProcessedTableManager get shareEventsRefs {
    final manager = $$ShareEventsTableTableManager(
      $_db,
      $_db.shareEvents,
    ).filter((f) => f.postId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_shareEventsRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PostsTableFilterComposer extends Composer<_$AppDatabase, $PostsTable> {
  $$PostsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get body => $composableBuilder(column: $table.body, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get threadParts =>
      $composableBuilder(column: $table.threadParts, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get link => $composableBuilder(column: $table.link, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get poll => $composableBuilder(column: $table.poll, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get hashtags =>
      $composableBuilder(column: $table.hashtags, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mentions =>
      $composableBuilder(column: $table.mentions, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get place =>
      $composableBuilder(column: $table.place, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get targets =>
      $composableBuilder(column: $table.targets, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get youtube =>
      $composableBuilder(column: $table.youtube, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contentWarning =>
      $composableBuilder(column: $table.contentWarning, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get firstComment =>
      $composableBuilder(column: $table.firstComment, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get reminderAt =>
      $composableBuilder(column: $table.reminderAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get pinned =>
      $composableBuilder(column: $table.pinned, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> attachmentsRefs(Expression<bool> Function($$AttachmentsTableFilterComposer f) f) {
    final $$AttachmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.attachments,
      getReferencedColumn: (t) => t.postId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AttachmentsTableFilterComposer(
            $db: $db,
            $table: $db.attachments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> postCollectionsRefs(Expression<bool> Function($$PostCollectionsTableFilterComposer f) f) {
    final $$PostCollectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.postCollections,
      getReferencedColumn: (t) => t.postId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$PostCollectionsTableFilterComposer(
            $db: $db,
            $table: $db.postCollections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> shareEventsRefs(Expression<bool> Function($$ShareEventsTableFilterComposer f) f) {
    final $$ShareEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shareEvents,
      getReferencedColumn: (t) => t.postId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$ShareEventsTableFilterComposer(
            $db: $db,
            $table: $db.shareEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PostsTableOrderingComposer extends Composer<_$AppDatabase, $PostsTable> {
  $$PostsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get threadParts =>
      $composableBuilder(column: $table.threadParts, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get link =>
      $composableBuilder(column: $table.link, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get poll =>
      $composableBuilder(column: $table.poll, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get hashtags =>
      $composableBuilder(column: $table.hashtags, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mentions =>
      $composableBuilder(column: $table.mentions, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get place =>
      $composableBuilder(column: $table.place, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get targets =>
      $composableBuilder(column: $table.targets, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get youtube =>
      $composableBuilder(column: $table.youtube, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contentWarning =>
      $composableBuilder(column: $table.contentWarning, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get firstComment =>
      $composableBuilder(column: $table.firstComment, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get reminderAt =>
      $composableBuilder(column: $table.reminderAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get pinned =>
      $composableBuilder(column: $table.pinned, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$PostsTableAnnotationComposer extends Composer<_$AppDatabase, $PostsTable> {
  $$PostsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title => $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body => $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get threadParts =>
      $composableBuilder(column: $table.threadParts, builder: (column) => column);

  GeneratedColumn<String> get link => $composableBuilder(column: $table.link, builder: (column) => column);

  GeneratedColumn<String> get poll => $composableBuilder(column: $table.poll, builder: (column) => column);

  GeneratedColumn<String> get hashtags => $composableBuilder(column: $table.hashtags, builder: (column) => column);

  GeneratedColumn<String> get mentions => $composableBuilder(column: $table.mentions, builder: (column) => column);

  GeneratedColumn<String> get place => $composableBuilder(column: $table.place, builder: (column) => column);

  GeneratedColumn<String> get targets => $composableBuilder(column: $table.targets, builder: (column) => column);

  GeneratedColumn<String> get youtube => $composableBuilder(column: $table.youtube, builder: (column) => column);

  GeneratedColumn<String> get language => $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get contentWarning =>
      $composableBuilder(column: $table.contentWarning, builder: (column) => column);

  GeneratedColumn<String> get firstComment =>
      $composableBuilder(column: $table.firstComment, builder: (column) => column);

  GeneratedColumn<DateTime> get reminderAt =>
      $composableBuilder(column: $table.reminderAt, builder: (column) => column);

  GeneratedColumn<String> get status => $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get pinned => $composableBuilder(column: $table.pinned, builder: (column) => column);

  GeneratedColumn<String> get notes => $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt => $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt => $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> attachmentsRefs<T extends Object>(Expression<T> Function($$AttachmentsTableAnnotationComposer a) f) {
    final $$AttachmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.attachments,
      getReferencedColumn: (t) => t.postId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$AttachmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.attachments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> postCollectionsRefs<T extends Object>(
    Expression<T> Function($$PostCollectionsTableAnnotationComposer a) f,
  ) {
    final $$PostCollectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.postCollections,
      getReferencedColumn: (t) => t.postId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$PostCollectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.postCollections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> shareEventsRefs<T extends Object>(Expression<T> Function($$ShareEventsTableAnnotationComposer a) f) {
    final $$ShareEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shareEvents,
      getReferencedColumn: (t) => t.postId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$ShareEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.shareEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PostsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PostsTable,
          PostRow,
          $$PostsTableFilterComposer,
          $$PostsTableOrderingComposer,
          $$PostsTableAnnotationComposer,
          $$PostsTableCreateCompanionBuilder,
          $$PostsTableUpdateCompanionBuilder,
          (PostRow, $$PostsTableReferences),
          PostRow,
          PrefetchHooks Function({bool attachmentsRefs, bool postCollectionsRefs, bool shareEventsRefs})
        > {
  $$PostsTableTableManager(_$AppDatabase db, $PostsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$PostsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$PostsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$PostsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String> threadParts = const Value.absent(),
                Value<String?> link = const Value.absent(),
                Value<String?> poll = const Value.absent(),
                Value<String> hashtags = const Value.absent(),
                Value<String> mentions = const Value.absent(),
                Value<String?> place = const Value.absent(),
                Value<String> targets = const Value.absent(),
                Value<String?> youtube = const Value.absent(),
                Value<String?> language = const Value.absent(),
                Value<String?> contentWarning = const Value.absent(),
                Value<String?> firstComment = const Value.absent(),
                Value<DateTime?> reminderAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<bool> pinned = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PostsCompanion(
                id: id,
                title: title,
                body: body,
                threadParts: threadParts,
                link: link,
                poll: poll,
                hashtags: hashtags,
                mentions: mentions,
                place: place,
                targets: targets,
                youtube: youtube,
                language: language,
                contentWarning: contentWarning,
                firstComment: firstComment,
                reminderAt: reminderAt,
                status: status,
                pinned: pinned,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String> threadParts = const Value.absent(),
                Value<String?> link = const Value.absent(),
                Value<String?> poll = const Value.absent(),
                Value<String> hashtags = const Value.absent(),
                Value<String> mentions = const Value.absent(),
                Value<String?> place = const Value.absent(),
                Value<String> targets = const Value.absent(),
                Value<String?> youtube = const Value.absent(),
                Value<String?> language = const Value.absent(),
                Value<String?> contentWarning = const Value.absent(),
                Value<String?> firstComment = const Value.absent(),
                Value<DateTime?> reminderAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<bool> pinned = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PostsCompanion.insert(
                id: id,
                title: title,
                body: body,
                threadParts: threadParts,
                link: link,
                poll: poll,
                hashtags: hashtags,
                mentions: mentions,
                place: place,
                targets: targets,
                youtube: youtube,
                language: language,
                contentWarning: contentWarning,
                firstComment: firstComment,
                reminderAt: reminderAt,
                status: status,
                pinned: pinned,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) =>
              p0.map((e) => (e.readTable<$PostsTable, PostRow>(table), $$PostsTableReferences(db, table, e))).toList(),
          prefetchHooksCallback: ({attachmentsRefs = false, postCollectionsRefs = false, shareEventsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (attachmentsRefs) db.attachments,
                if (postCollectionsRefs) db.postCollections,
                if (shareEventsRefs) db.shareEvents,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (attachmentsRefs)
                    await $_getPrefetchedDataByColumns<PostRow, $PostsTable, AttachmentRow, $AttachmentsTable>(
                      currentTable: table,
                      referencedTable: $$PostsTableReferences._attachmentsRefsTable(db),
                      managerFromTypedResult: (p0) => $$PostsTableReferences(db, table, p0).attachmentsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'post_id',
                      typedResults: items,
                    ),
                  if (postCollectionsRefs)
                    await $_getPrefetchedDataByColumns<PostRow, $PostsTable, PostCollectionRow, $PostCollectionsTable>(
                      currentTable: table,
                      referencedTable: $$PostsTableReferences._postCollectionsRefsTable(db),
                      managerFromTypedResult: (p0) => $$PostsTableReferences(db, table, p0).postCollectionsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'post_id',
                      typedResults: items,
                    ),
                  if (shareEventsRefs)
                    await $_getPrefetchedDataByColumns<PostRow, $PostsTable, ShareEventRow, $ShareEventsTable>(
                      currentTable: table,
                      referencedTable: $$PostsTableReferences._shareEventsRefsTable(db),
                      managerFromTypedResult: (p0) => $$PostsTableReferences(db, table, p0).shareEventsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'post_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PostsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PostsTable,
      PostRow,
      $$PostsTableFilterComposer,
      $$PostsTableOrderingComposer,
      $$PostsTableAnnotationComposer,
      $$PostsTableCreateCompanionBuilder,
      $$PostsTableUpdateCompanionBuilder,
      (PostRow, $$PostsTableReferences),
      PostRow,
      PrefetchHooks Function({bool attachmentsRefs, bool postCollectionsRefs, bool shareEventsRefs})
    >;
typedef $$AttachmentsTableCreateCompanionBuilder =
    AttachmentsCompanion Function({
      required String id,
      required String postId,
      required int position,
      required String kind,
      required String fileName,
      required String relativePath,
      required String mimeType,
      required int sizeBytes,
      required String sha256,
      Value<int?> width,
      Value<int?> height,
      Value<int?> durationMs,
      Value<String?> altText,
      Value<int?> coverFrameMs,
      Value<String?> crop,
      Value<String?> mediaInfo,
      Value<String?> thumbPath,
      Value<int> rowid,
    });
typedef $$AttachmentsTableUpdateCompanionBuilder =
    AttachmentsCompanion Function({
      Value<String> id,
      Value<String> postId,
      Value<int> position,
      Value<String> kind,
      Value<String> fileName,
      Value<String> relativePath,
      Value<String> mimeType,
      Value<int> sizeBytes,
      Value<String> sha256,
      Value<int?> width,
      Value<int?> height,
      Value<int?> durationMs,
      Value<String?> altText,
      Value<int?> coverFrameMs,
      Value<String?> crop,
      Value<String?> mediaInfo,
      Value<String?> thumbPath,
      Value<int> rowid,
    });

final class $$AttachmentsTableReferences extends BaseReferences<_$AppDatabase, $AttachmentsTable, AttachmentRow> {
  $$AttachmentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PostsTable _postIdTable(_$AppDatabase db) => db.posts.createAlias('attachments__post_id__posts__id');

  $$PostsTableProcessedTableManager get postId {
    final $_column = $_itemColumn<String>('post_id')!;

    final manager = $$PostsTableTableManager($_db, $_db.posts).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_postIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$AttachmentsTableFilterComposer extends Composer<_$AppDatabase, $AttachmentsTable> {
  $$AttachmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kind => $composableBuilder(column: $table.kind, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get relativePath =>
      $composableBuilder(column: $table.relativePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sizeBytes =>
      $composableBuilder(column: $table.sizeBytes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sha256 =>
      $composableBuilder(column: $table.sha256, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get width => $composableBuilder(column: $table.width, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get height =>
      $composableBuilder(column: $table.height, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationMs =>
      $composableBuilder(column: $table.durationMs, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get altText =>
      $composableBuilder(column: $table.altText, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get coverFrameMs =>
      $composableBuilder(column: $table.coverFrameMs, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get crop => $composableBuilder(column: $table.crop, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mediaInfo =>
      $composableBuilder(column: $table.mediaInfo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get thumbPath =>
      $composableBuilder(column: $table.thumbPath, builder: (column) => ColumnFilters(column));

  $$PostsTableFilterComposer get postId {
    final $$PostsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.postId,
      referencedTable: $db.posts,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$PostsTableFilterComposer(
            $db: $db,
            $table: $db.posts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttachmentsTableOrderingComposer extends Composer<_$AppDatabase, $AttachmentsTable> {
  $$AttachmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get relativePath =>
      $composableBuilder(column: $table.relativePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sizeBytes =>
      $composableBuilder(column: $table.sizeBytes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sha256 =>
      $composableBuilder(column: $table.sha256, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get width =>
      $composableBuilder(column: $table.width, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get height =>
      $composableBuilder(column: $table.height, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationMs =>
      $composableBuilder(column: $table.durationMs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get altText =>
      $composableBuilder(column: $table.altText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get coverFrameMs =>
      $composableBuilder(column: $table.coverFrameMs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get crop =>
      $composableBuilder(column: $table.crop, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mediaInfo =>
      $composableBuilder(column: $table.mediaInfo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get thumbPath =>
      $composableBuilder(column: $table.thumbPath, builder: (column) => ColumnOrderings(column));

  $$PostsTableOrderingComposer get postId {
    final $$PostsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.postId,
      referencedTable: $db.posts,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$PostsTableOrderingComposer(
            $db: $db,
            $table: $db.posts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttachmentsTableAnnotationComposer extends Composer<_$AppDatabase, $AttachmentsTable> {
  $$AttachmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position => $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get kind => $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get fileName => $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<String> get relativePath =>
      $composableBuilder(column: $table.relativePath, builder: (column) => column);

  GeneratedColumn<String> get mimeType => $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<int> get sizeBytes => $composableBuilder(column: $table.sizeBytes, builder: (column) => column);

  GeneratedColumn<String> get sha256 => $composableBuilder(column: $table.sha256, builder: (column) => column);

  GeneratedColumn<int> get width => $composableBuilder(column: $table.width, builder: (column) => column);

  GeneratedColumn<int> get height => $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(column: $table.durationMs, builder: (column) => column);

  GeneratedColumn<String> get altText => $composableBuilder(column: $table.altText, builder: (column) => column);

  GeneratedColumn<int> get coverFrameMs => $composableBuilder(column: $table.coverFrameMs, builder: (column) => column);

  GeneratedColumn<String> get crop => $composableBuilder(column: $table.crop, builder: (column) => column);

  GeneratedColumn<String> get mediaInfo => $composableBuilder(column: $table.mediaInfo, builder: (column) => column);

  GeneratedColumn<String> get thumbPath => $composableBuilder(column: $table.thumbPath, builder: (column) => column);

  $$PostsTableAnnotationComposer get postId {
    final $$PostsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.postId,
      referencedTable: $db.posts,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$PostsTableAnnotationComposer(
            $db: $db,
            $table: $db.posts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttachmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AttachmentsTable,
          AttachmentRow,
          $$AttachmentsTableFilterComposer,
          $$AttachmentsTableOrderingComposer,
          $$AttachmentsTableAnnotationComposer,
          $$AttachmentsTableCreateCompanionBuilder,
          $$AttachmentsTableUpdateCompanionBuilder,
          (AttachmentRow, $$AttachmentsTableReferences),
          AttachmentRow,
          PrefetchHooks Function({bool postId})
        > {
  $$AttachmentsTableTableManager(_$AppDatabase db, $AttachmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$AttachmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$AttachmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$AttachmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> postId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> fileName = const Value.absent(),
                Value<String> relativePath = const Value.absent(),
                Value<String> mimeType = const Value.absent(),
                Value<int> sizeBytes = const Value.absent(),
                Value<String> sha256 = const Value.absent(),
                Value<int?> width = const Value.absent(),
                Value<int?> height = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
                Value<String?> altText = const Value.absent(),
                Value<int?> coverFrameMs = const Value.absent(),
                Value<String?> crop = const Value.absent(),
                Value<String?> mediaInfo = const Value.absent(),
                Value<String?> thumbPath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AttachmentsCompanion(
                id: id,
                postId: postId,
                position: position,
                kind: kind,
                fileName: fileName,
                relativePath: relativePath,
                mimeType: mimeType,
                sizeBytes: sizeBytes,
                sha256: sha256,
                width: width,
                height: height,
                durationMs: durationMs,
                altText: altText,
                coverFrameMs: coverFrameMs,
                crop: crop,
                mediaInfo: mediaInfo,
                thumbPath: thumbPath,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String postId,
                required int position,
                required String kind,
                required String fileName,
                required String relativePath,
                required String mimeType,
                required int sizeBytes,
                required String sha256,
                Value<int?> width = const Value.absent(),
                Value<int?> height = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
                Value<String?> altText = const Value.absent(),
                Value<int?> coverFrameMs = const Value.absent(),
                Value<String?> crop = const Value.absent(),
                Value<String?> mediaInfo = const Value.absent(),
                Value<String?> thumbPath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AttachmentsCompanion.insert(
                id: id,
                postId: postId,
                position: position,
                kind: kind,
                fileName: fileName,
                relativePath: relativePath,
                mimeType: mimeType,
                sizeBytes: sizeBytes,
                sha256: sha256,
                width: width,
                height: height,
                durationMs: durationMs,
                altText: altText,
                coverFrameMs: coverFrameMs,
                crop: crop,
                mediaInfo: mediaInfo,
                thumbPath: thumbPath,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable<$AttachmentsTable, AttachmentRow>(table), $$AttachmentsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({postId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (postId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.postId,
                                referencedTable: $$AttachmentsTableReferences._postIdTable(db),
                                referencedColumn: $$AttachmentsTableReferences._postIdTable(db).id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AttachmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AttachmentsTable,
      AttachmentRow,
      $$AttachmentsTableFilterComposer,
      $$AttachmentsTableOrderingComposer,
      $$AttachmentsTableAnnotationComposer,
      $$AttachmentsTableCreateCompanionBuilder,
      $$AttachmentsTableUpdateCompanionBuilder,
      (AttachmentRow, $$AttachmentsTableReferences),
      AttachmentRow,
      PrefetchHooks Function({bool postId})
    >;
typedef $$CollectionsTableCreateCompanionBuilder =
    CollectionsCompanion Function({
      required String id,
      required String name,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$CollectionsTableUpdateCompanionBuilder =
    CollectionsCompanion Function({Value<String> id, Value<String> name, Value<DateTime> createdAt, Value<int> rowid});

final class $$CollectionsTableReferences extends BaseReferences<_$AppDatabase, $CollectionsTable, CollectionRow> {
  $$CollectionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PostCollectionsTable, List<PostCollectionRow>> _postCollectionsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(db.postCollections, aliasName: 'collections__id__post_collections__collection_id');

  $$PostCollectionsTableProcessedTableManager get postCollectionsRefs {
    final manager = $$PostCollectionsTableTableManager(
      $_db,
      $_db.postCollections,
    ).filter((f) => f.collectionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_postCollectionsRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CollectionsTableFilterComposer extends Composer<_$AppDatabase, $CollectionsTable> {
  $$CollectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> postCollectionsRefs(Expression<bool> Function($$PostCollectionsTableFilterComposer f) f) {
    final $$PostCollectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.postCollections,
      getReferencedColumn: (t) => t.collectionId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$PostCollectionsTableFilterComposer(
            $db: $db,
            $table: $db.postCollections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CollectionsTableOrderingComposer extends Composer<_$AppDatabase, $CollectionsTable> {
  $$CollectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$CollectionsTableAnnotationComposer extends Composer<_$AppDatabase, $CollectionsTable> {
  $$CollectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name => $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt => $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> postCollectionsRefs<T extends Object>(
    Expression<T> Function($$PostCollectionsTableAnnotationComposer a) f,
  ) {
    final $$PostCollectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.postCollections,
      getReferencedColumn: (t) => t.collectionId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$PostCollectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.postCollections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CollectionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CollectionsTable,
          CollectionRow,
          $$CollectionsTableFilterComposer,
          $$CollectionsTableOrderingComposer,
          $$CollectionsTableAnnotationComposer,
          $$CollectionsTableCreateCompanionBuilder,
          $$CollectionsTableUpdateCompanionBuilder,
          (CollectionRow, $$CollectionsTableReferences),
          CollectionRow,
          PrefetchHooks Function({bool postCollectionsRefs})
        > {
  $$CollectionsTableTableManager(_$AppDatabase db, $CollectionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$CollectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$CollectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$CollectionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CollectionsCompanion(id: id, name: name, createdAt: createdAt, rowid: rowid),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => CollectionsCompanion.insert(id: id, name: name, createdAt: createdAt, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable<$CollectionsTable, CollectionRow>(table), $$CollectionsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({postCollectionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (postCollectionsRefs) db.postCollections],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (postCollectionsRefs)
                    await $_getPrefetchedDataByColumns<
                      CollectionRow,
                      $CollectionsTable,
                      PostCollectionRow,
                      $PostCollectionsTable
                    >(
                      currentTable: table,
                      referencedTable: $$CollectionsTableReferences._postCollectionsRefsTable(db),
                      managerFromTypedResult: (p0) => $$CollectionsTableReferences(db, table, p0).postCollectionsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'collection_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CollectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CollectionsTable,
      CollectionRow,
      $$CollectionsTableFilterComposer,
      $$CollectionsTableOrderingComposer,
      $$CollectionsTableAnnotationComposer,
      $$CollectionsTableCreateCompanionBuilder,
      $$CollectionsTableUpdateCompanionBuilder,
      (CollectionRow, $$CollectionsTableReferences),
      CollectionRow,
      PrefetchHooks Function({bool postCollectionsRefs})
    >;
typedef $$PostCollectionsTableCreateCompanionBuilder =
    PostCollectionsCompanion Function({required String postId, required String collectionId, Value<int> rowid});
typedef $$PostCollectionsTableUpdateCompanionBuilder =
    PostCollectionsCompanion Function({Value<String> postId, Value<String> collectionId, Value<int> rowid});

final class $$PostCollectionsTableReferences
    extends BaseReferences<_$AppDatabase, $PostCollectionsTable, PostCollectionRow> {
  $$PostCollectionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PostsTable _postIdTable(_$AppDatabase db) => db.posts.createAlias('post_collections__post_id__posts__id');

  $$PostsTableProcessedTableManager get postId {
    final $_column = $_itemColumn<String>('post_id')!;

    final manager = $$PostsTableTableManager($_db, $_db.posts).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_postIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }

  static $CollectionsTable _collectionIdTable(_$AppDatabase db) =>
      db.collections.createAlias('post_collections__collection_id__collections__id');

  $$CollectionsTableProcessedTableManager get collectionId {
    final $_column = $_itemColumn<String>('collection_id')!;

    final manager = $$CollectionsTableTableManager($_db, $_db.collections).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_collectionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PostCollectionsTableFilterComposer extends Composer<_$AppDatabase, $PostCollectionsTable> {
  $$PostCollectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$PostsTableFilterComposer get postId {
    final $$PostsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.postId,
      referencedTable: $db.posts,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$PostsTableFilterComposer(
            $db: $db,
            $table: $db.posts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CollectionsTableFilterComposer get collectionId {
    final $$CollectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.collectionId,
      referencedTable: $db.collections,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$CollectionsTableFilterComposer(
            $db: $db,
            $table: $db.collections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PostCollectionsTableOrderingComposer extends Composer<_$AppDatabase, $PostCollectionsTable> {
  $$PostCollectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$PostsTableOrderingComposer get postId {
    final $$PostsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.postId,
      referencedTable: $db.posts,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$PostsTableOrderingComposer(
            $db: $db,
            $table: $db.posts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CollectionsTableOrderingComposer get collectionId {
    final $$CollectionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.collectionId,
      referencedTable: $db.collections,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$CollectionsTableOrderingComposer(
            $db: $db,
            $table: $db.collections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PostCollectionsTableAnnotationComposer extends Composer<_$AppDatabase, $PostCollectionsTable> {
  $$PostCollectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$PostsTableAnnotationComposer get postId {
    final $$PostsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.postId,
      referencedTable: $db.posts,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$PostsTableAnnotationComposer(
            $db: $db,
            $table: $db.posts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CollectionsTableAnnotationComposer get collectionId {
    final $$CollectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.collectionId,
      referencedTable: $db.collections,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$CollectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.collections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PostCollectionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PostCollectionsTable,
          PostCollectionRow,
          $$PostCollectionsTableFilterComposer,
          $$PostCollectionsTableOrderingComposer,
          $$PostCollectionsTableAnnotationComposer,
          $$PostCollectionsTableCreateCompanionBuilder,
          $$PostCollectionsTableUpdateCompanionBuilder,
          (PostCollectionRow, $$PostCollectionsTableReferences),
          PostCollectionRow,
          PrefetchHooks Function({bool postId, bool collectionId})
        > {
  $$PostCollectionsTableTableManager(_$AppDatabase db, $PostCollectionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$PostCollectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$PostCollectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$PostCollectionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> postId = const Value.absent(),
                Value<String> collectionId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PostCollectionsCompanion(postId: postId, collectionId: collectionId, rowid: rowid),
          createCompanionCallback:
              ({required String postId, required String collectionId, Value<int> rowid = const Value.absent()}) =>
                  PostCollectionsCompanion.insert(postId: postId, collectionId: collectionId, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PostCollectionsTable, PostCollectionRow>(table),
                  $$PostCollectionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({postId = false, collectionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (postId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.postId,
                                referencedTable: $$PostCollectionsTableReferences._postIdTable(db),
                                referencedColumn: $$PostCollectionsTableReferences._postIdTable(db).id,
                              )
                              as T;
                    }
                    if (collectionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.collectionId,
                                referencedTable: $$PostCollectionsTableReferences._collectionIdTable(db),
                                referencedColumn: $$PostCollectionsTableReferences._collectionIdTable(db).id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PostCollectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PostCollectionsTable,
      PostCollectionRow,
      $$PostCollectionsTableFilterComposer,
      $$PostCollectionsTableOrderingComposer,
      $$PostCollectionsTableAnnotationComposer,
      $$PostCollectionsTableCreateCompanionBuilder,
      $$PostCollectionsTableUpdateCompanionBuilder,
      (PostCollectionRow, $$PostCollectionsTableReferences),
      PostCollectionRow,
      PrefetchHooks Function({bool postId, bool collectionId})
    >;
typedef $$ShareEventsTableCreateCompanionBuilder =
    ShareEventsCompanion Function({
      required String id,
      required String postId,
      required String target,
      required DateTime sharedAt,
      Value<String?> liveUrl,
      Value<int> rowid,
    });
typedef $$ShareEventsTableUpdateCompanionBuilder =
    ShareEventsCompanion Function({
      Value<String> id,
      Value<String> postId,
      Value<String> target,
      Value<DateTime> sharedAt,
      Value<String?> liveUrl,
      Value<int> rowid,
    });

final class $$ShareEventsTableReferences extends BaseReferences<_$AppDatabase, $ShareEventsTable, ShareEventRow> {
  $$ShareEventsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PostsTable _postIdTable(_$AppDatabase db) => db.posts.createAlias('share_events__post_id__posts__id');

  $$PostsTableProcessedTableManager get postId {
    final $_column = $_itemColumn<String>('post_id')!;

    final manager = $$PostsTableTableManager($_db, $_db.posts).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_postIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ShareEventsTableFilterComposer extends Composer<_$AppDatabase, $ShareEventsTable> {
  $$ShareEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get target =>
      $composableBuilder(column: $table.target, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get sharedAt =>
      $composableBuilder(column: $table.sharedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get liveUrl =>
      $composableBuilder(column: $table.liveUrl, builder: (column) => ColumnFilters(column));

  $$PostsTableFilterComposer get postId {
    final $$PostsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.postId,
      referencedTable: $db.posts,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$PostsTableFilterComposer(
            $db: $db,
            $table: $db.posts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShareEventsTableOrderingComposer extends Composer<_$AppDatabase, $ShareEventsTable> {
  $$ShareEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get target =>
      $composableBuilder(column: $table.target, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get sharedAt =>
      $composableBuilder(column: $table.sharedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get liveUrl =>
      $composableBuilder(column: $table.liveUrl, builder: (column) => ColumnOrderings(column));

  $$PostsTableOrderingComposer get postId {
    final $$PostsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.postId,
      referencedTable: $db.posts,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$PostsTableOrderingComposer(
            $db: $db,
            $table: $db.posts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShareEventsTableAnnotationComposer extends Composer<_$AppDatabase, $ShareEventsTable> {
  $$ShareEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get target => $composableBuilder(column: $table.target, builder: (column) => column);

  GeneratedColumn<DateTime> get sharedAt => $composableBuilder(column: $table.sharedAt, builder: (column) => column);

  GeneratedColumn<String> get liveUrl => $composableBuilder(column: $table.liveUrl, builder: (column) => column);

  $$PostsTableAnnotationComposer get postId {
    final $$PostsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.postId,
      referencedTable: $db.posts,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$PostsTableAnnotationComposer(
            $db: $db,
            $table: $db.posts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShareEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShareEventsTable,
          ShareEventRow,
          $$ShareEventsTableFilterComposer,
          $$ShareEventsTableOrderingComposer,
          $$ShareEventsTableAnnotationComposer,
          $$ShareEventsTableCreateCompanionBuilder,
          $$ShareEventsTableUpdateCompanionBuilder,
          (ShareEventRow, $$ShareEventsTableReferences),
          ShareEventRow,
          PrefetchHooks Function({bool postId})
        > {
  $$ShareEventsTableTableManager(_$AppDatabase db, $ShareEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$ShareEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$ShareEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$ShareEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> postId = const Value.absent(),
                Value<String> target = const Value.absent(),
                Value<DateTime> sharedAt = const Value.absent(),
                Value<String?> liveUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShareEventsCompanion(
                id: id,
                postId: postId,
                target: target,
                sharedAt: sharedAt,
                liveUrl: liveUrl,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String postId,
                required String target,
                required DateTime sharedAt,
                Value<String?> liveUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShareEventsCompanion.insert(
                id: id,
                postId: postId,
                target: target,
                sharedAt: sharedAt,
                liveUrl: liveUrl,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable<$ShareEventsTable, ShareEventRow>(table), $$ShareEventsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({postId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (postId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.postId,
                                referencedTable: $$ShareEventsTableReferences._postIdTable(db),
                                referencedColumn: $$ShareEventsTableReferences._postIdTable(db).id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ShareEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShareEventsTable,
      ShareEventRow,
      $$ShareEventsTableFilterComposer,
      $$ShareEventsTableOrderingComposer,
      $$ShareEventsTableAnnotationComposer,
      $$ShareEventsTableCreateCompanionBuilder,
      $$ShareEventsTableUpdateCompanionBuilder,
      (ShareEventRow, $$ShareEventsTableReferences),
      ShareEventRow,
      PrefetchHooks Function({bool postId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PostsTableTableManager get posts => $$PostsTableTableManager(_db, _db.posts);
  $$AttachmentsTableTableManager get attachments => $$AttachmentsTableTableManager(_db, _db.attachments);
  $$CollectionsTableTableManager get collections => $$CollectionsTableTableManager(_db, _db.collections);
  $$PostCollectionsTableTableManager get postCollections =>
      $$PostCollectionsTableTableManager(_db, _db.postCollections);
  $$ShareEventsTableTableManager get shareEvents => $$ShareEventsTableTableManager(_db, _db.shareEvents);
}
