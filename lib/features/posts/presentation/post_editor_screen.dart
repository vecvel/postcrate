import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/notifications/reminders.dart';
import '../../../core/providers.dart';
import '../../../core/theme/pc_tokens.dart';
import '../../../core/utils/formatting.dart';
import '../../../core/widgets/widgets.dart';
import '../domain/post.dart';
import '../domain/social_app.dart';
import 'widgets/attachment_sheet.dart';
import 'widgets/attachment_thumb.dart';
import 'widgets/collections_sheet.dart';
import 'widgets/editor_pickers.dart';
import 'widgets/post_actions.dart';
import '../data/link_preview_fetcher.dart';
import '../../share/post_links.dart';
import '../../share/share_providers.dart';

/// Creates or edits a post. Holds every field a social post can carry.
class PostEditorScreen extends ConsumerStatefulWidget {
  const PostEditorScreen({super.key, this.postId});

  final String? postId;

  @override
  ConsumerState<PostEditorScreen> createState() => _PostEditorScreenState();
}

class _PostEditorScreenState extends ConsumerState<PostEditorScreen> {
  Post? _base;
  bool _isNew = true;
  bool _saving = false;
  bool _importing = false;
  String _savedSnapshot = '';

  final _title = TextEditingController();
  final _body = TextEditingController();
  final _thread = <TextEditingController>[];
  final _linkUrl = TextEditingController();
  final _linkTitle = TextEditingController();
  final _linkDescription = TextEditingController();
  final _pollQuestion = TextEditingController();
  final _pollOptions = <TextEditingController>[];
  final _place = TextEditingController();
  final _contentWarning = TextEditingController();
  final _firstComment = TextEditingController();
  final _notes = TextEditingController();
  final _variants = <SocialApp, TextEditingController>{};

  List<Attachment> _attachments = [];
  bool _pollOn = false;
  int _pollHours = 24;
  bool _warningOn = false;
  String? _language;
  DateTime? _reminderAt;
  List<SocialApp> _targets = [];
  List<String> _collectionIds = [];
  PostStatus _status = PostStatus.draft;
  bool _pinned = false;
  List<ShareEvent> _history = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = ref.read(postsRepositoryProvider);
    final existing = widget.postId == null ? null : await repo.getPost(widget.postId!);
    final post = existing ?? repo.newPost();
    if (!mounted) return;
    setState(() {
      _base = post;
      _isNew = existing == null;
      _fill(post);
      _savedSnapshot = _snapshot();
    });
  }

  void _fill(Post p) {
    _title.text = p.title ?? '';
    _body.text = p.body;
    for (final t in p.threadParts) {
      _thread.add(TextEditingController(text: t));
    }
    _linkUrl.text = p.link?.url ?? '';
    _linkTitle.text = p.link?.title ?? '';
    _linkDescription.text = p.link?.description ?? '';
    _pollOn = p.poll != null;
    _pollQuestion.text = p.poll?.question ?? '';
    for (final o in p.poll?.options ?? const ['', '']) {
      _pollOptions.add(TextEditingController(text: o));
    }
    _pollHours = p.poll?.durationHours ?? 24;
    _place.text = p.place?.name ?? '';
    _warningOn = p.contentWarning != null;
    _contentWarning.text = p.contentWarning ?? '';
    _firstComment.text = p.firstComment ?? '';
    _notes.text = p.notes ?? '';
    _attachments = [...p.attachments];
    _language = p.language;
    _reminderAt = p.reminderAt;
    _targets = [for (final t in p.targets) t.app];
    for (final t in p.targets) {
      _variants[t.app] = TextEditingController(text: t.variantText ?? '');
    }
    _collectionIds = [...p.collectionIds];
    _status = p.status;
    _pinned = p.pinned;
    _history = p.shareHistory;
  }

  @override
  void dispose() {
    for (final c in [
      _title,
      _body,
      _linkUrl,
      _linkTitle,
      _linkDescription,
      _pollQuestion,
      _place,
      _contentWarning,
      _firstComment,
      _notes,
      ..._thread,
      ..._pollOptions,
      ..._variants.values,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _clean(String s) => s.trim().isEmpty ? null : s.trim();

  Post _compose() {
    final base = _base!;
    final url = _clean(_linkUrl.text);
    final options = _pollOptions.map((c) => c.text.trim()).where((o) => o.isNotEmpty).toList();
    return base.copyWith(
      title: _title.text.trim(),
      body: _body.text,
      threadParts: _thread.map((c) => c.text).where((t) => t.trim().isNotEmpty).toList(),
      attachments: _attachments,
      link: () => url == null
          ? null
          : LinkPreview(url: url, title: _clean(_linkTitle.text), description: _clean(_linkDescription.text)),
      poll: () => _pollOn && _clean(_pollQuestion.text) != null
          ? Poll(question: _pollQuestion.text.trim(), options: options, durationHours: _pollHours)
          : null,
      place: () => _clean(_place.text) == null ? null : Place(name: _place.text.trim()),
      language: () => _language,
      contentWarning: () => _warningOn ? (_clean(_contentWarning.text) ?? 'Sensitive content') : null,
      firstComment: () => _clean(_firstComment.text),
      reminderAt: () => _reminderAt,
      targets: [for (final a in _targets) TargetApp(app: a, variantText: _clean(_variants[a]?.text ?? ''))],
      collectionIds: _collectionIds,
      status: _status,
      pinned: _pinned,
      notes: () => _clean(_notes.text),
      shareHistory: _history,
    );
  }

  String _snapshot() {
    final j = _compose().toJson()
      ..remove('updatedAt')
      ..remove('shareHistory')
      ..remove('status');
    return '${jsonEncode(j)}|${_status.name}';
  }

  bool get _dirty => _base != null && _snapshot() != _savedSnapshot;

  Future<Post?> _save({bool close = false}) async {
    if (_base == null || _saving) return null;
    final draft = _compose();
    if (draft.isEmpty) {
      if (close && mounted) Navigator.of(context).pop();
      return null;
    }
    setState(() => _saving = true);
    final post = draft.copyWith(updatedAt: DateTime.now());
    await ref.read(postsRepositoryProvider).save(post);
    final remindersOn = await Reminders.instance.sync(post);
    if (!remindersOn && mounted) {
      showPcToast(context, 'Turn on notifications for Postcrate in Settings to get this reminder.');
    }
    if (!mounted) return post;
    setState(() {
      _saving = false;
      _base = post;
      _isNew = false;
      _savedSnapshot = _snapshot();
    });
    if (close) Navigator.of(context).pop();
    return post;
  }

  Future<void> _share({SocialApp? app}) async {
    final post = _dirty || _isNew ? await _save() : _compose();
    if (post == null || !mounted) return;
    await sharePost(context, ref, post, app: app);
    final fresh = await ref.read(postsRepositoryProvider).getPost(post.id);
    if (fresh == null || !mounted) return;
    setState(() {
      _history = fresh.shareHistory;
      _status = fresh.status;
      _base = _base!.copyWith(status: fresh.status, shareHistory: fresh.shareHistory);
      _savedSnapshot = _snapshot();
    });
  }

  Future<void> _addMedia() async {
    final choice = await showPcSheet<String>(
      context,
      title: 'Add media',
      builder: (ctx) => PcGroup(
        children: [
          PcRow(
            title: 'Photos and videos',
            leading: const PcIconTile(icon: CupertinoIcons.photo_on_rectangle),
            onTap: () => Navigator.of(ctx).pop('gallery'),
          ),
          PcRow(
            title: 'Take photo',
            leading: const PcIconTile(icon: CupertinoIcons.camera),
            onTap: () => Navigator.of(ctx).pop('camera'),
          ),
          PcRow(
            title: 'Files',
            subtitle: 'Audio, PDF, DOCX, PPTX, TXT and more',
            leading: const PcIconTile(icon: CupertinoIcons.folder),
            onTap: () => Navigator.of(ctx).pop('files'),
          ),
        ],
      ),
    );
    if (choice == null) return;

    final picked = <(File, String)>[];
    try {
      if (choice == 'gallery') {
        for (final x in await ImagePicker().pickMultipleMedia()) {
          picked.add((File(x.path), x.name));
        }
      } else if (choice == 'camera') {
        final x = await ImagePicker().pickImage(source: ImageSource.camera);
        if (x != null) picked.add((File(x.path), x.name));
      } else {
        final files = await FilePicker.pickFiles(
          type: FileType.custom,
          allowedExtensions: AttachmentKind.allExtensions,
        );
        for (final f in files) {
          if (f.path != null) picked.add((File(f.path!), f.name));
        }
      }
    } catch (_) {
      if (mounted) showPcToast(context, "Couldn't open your media. Check Postcrate's access in Settings.");
      return;
    }
    if (picked.isEmpty) return;

    setState(() => _importing = true);
    final media = ref.read(mediaStoreProvider);
    var skipped = 0;
    for (final (file, name) in picked) {
      final a = await media.import(file, originalName: name);
      if (a == null) {
        skipped++;
      } else {
        _attachments.add(a);
      }
    }
    if (!mounted) return;
    setState(() => _importing = false);
    if (skipped > 0) showPcToast(context, '$skipped file${skipped == 1 ? '' : 's'} skipped: type not supported.');
  }

  Future<void> _editAttachment(int index) async {
    final result = await showAttachmentSheet(
      context,
      attachment: _attachments[index],
      index: index,
      count: _attachments.length,
      targets: _targets,
    );
    if (result == null || !mounted) return;
    setState(() {
      switch (result) {
        case AttachmentEdit(:final attachment):
          _attachments[index] = attachment;
        case AttachmentMove(:final delta):
          final a = _attachments.removeAt(index);
          _attachments.insert((index + delta).clamp(0, _attachments.length), a);
        case AttachmentRemove():
          _attachments.removeAt(index);
      }
    });
  }

  Future<bool> _confirmDiscard() async {
    if (!_dirty) return true;
    return showPcConfirm(
      context,
      title: 'Discard changes?',
      message: "Your edits to this post haven't been saved.",
      confirmLabel: 'Discard changes',
      destructive: true,
    );
  }

  /// Draft composed once per build for sections that only read it.
  Post? _draft;

  @override
  Widget build(BuildContext context) {
    final c = context.pc;
    final base = _base;
    _draft = base == null ? null : _compose();
    return PopScope(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _confirmDiscard() && context.mounted) {
          _savedSnapshot = _snapshot();
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              PcNavBar(
                title: _isNew ? 'New post' : 'Edit post',
                leadingLabel: _isNew ? 'Cancel' : null,
                trailing: PcButton(
                  label: 'Save',
                  compact: true,
                  loading: _saving,
                  onPressed: base == null ? null : () => _save(close: true),
                ),
              ),
              Expanded(
                child: base == null
                    ? const Center(child: CupertinoActivityIndicator())
                    : ListView(
                        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                        padding: EdgeInsets.fromLTRB(
                          PcSpace.gutter,
                          0,
                          PcSpace.gutter,
                          PcSpace.xxl + MediaQuery.viewPaddingOf(context).bottom,
                        ),
                        children: [
                          ..._postSection(context),
                          ..._mediaSection(context),
                          ..._linkSection(context),
                          ..._pollSection(context),
                          ..._detailsSection(context),
                          ..._shareSection(context),
                          ..._copySection(context),
                          ..._privateSection(context),
                          ..._historySection(context),
                          if (!_isNew) ...[
                            const SizedBox(height: PcSpace.xl),
                            PcButton.danger(
                              label: 'Delete post',
                              expand: true,
                              onPressed: () => confirmDeletePost(
                                context,
                                ref,
                                base,
                                onDeleted: () {
                                  _savedSnapshot = _snapshot();
                                  if (context.mounted) Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ],
                          const SizedBox(height: PcSpace.md),
                          Text(
                            'Created ${dateTimeLabel(base.createdAt)}${_isNew ? '' : ' · Edited ${dateTimeLabel(base.updatedAt)}'}',
                            style: context.text.bodySmall!.copyWith(color: c.textTertiary),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Sections ------------------------------------------------------------------

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(left: 2, bottom: 6, top: 10),
    child: Text(text, style: context.text.labelMedium),
  );

  List<Widget> _postSection(BuildContext context) {
    final titleLimits = _targets.where((a) => a.titleLimit != null).toList();
    return [
      const PcSectionLabel('Post'),
      PcCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _label('Title (optional, for YouTube, Reddit, Pinterest, LinkedIn articles)'),
            PcTextField(controller: _title, hint: 'Onboarding, rebuilt', onChanged: (_) => setState(() {})),
            if (titleLimits.isNotEmpty) LimitRow(text: _title.text, apps: titleLimits, useTitle: true),
            _label('Text'),
            PcTextField(
              controller: _body,
              hint: "What's this post about?",
              minLines: 5,
              maxLines: null,
              onChanged: (_) => setState(() {}),
            ),
            LimitRow(text: _body.text, apps: _targets),
            _label('Thread'),
            for (var i = 0; i < _thread.length; i++) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: PcTextField(
                      controller: _thread[i],
                      hint: 'Part ${i + 2}',
                      minLines: 2,
                      maxLines: null,
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  PcIconButton(
                    icon: CupertinoIcons.minus_circle,
                    label: 'Remove part ${i + 2}',
                    color: context.pc.textTertiary,
                    onTap: () => setState(() => _thread.removeAt(i).dispose()),
                  ),
                ],
              ),
              const SizedBox(height: 6),
            ],
            Align(
              alignment: Alignment.centerLeft,
              child: PcButton.secondary(
                label: _thread.isEmpty ? 'Add thread part' : 'Add another part',
                icon: CupertinoIcons.plus,
                compact: true,
                onPressed: () => setState(() => _thread.add(TextEditingController())),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _mediaSection(BuildContext context) => [
    PcSectionLabel(_attachments.isEmpty ? 'Media' : 'Media · ${_attachments.length}'),
    PcCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_attachments.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (var i = 0; i < _attachments.length; i++)
                  PcTap(
                    onTap: () => _editAttachment(i),
                    semanticLabel: 'Edit ${_attachments[i].fileName}',
                    child: AttachmentThumb(attachment: _attachments[i]),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text('Tap a file to add alt text, crop, reorder or remove it.', style: context.text.bodySmall),
            const SizedBox(height: 12),
          ],
          Align(
            alignment: Alignment.centerLeft,
            child: PcButton.secondary(
              label: 'Add media',
              icon: CupertinoIcons.plus,
              compact: true,
              loading: _importing,
              onPressed: _addMedia,
            ),
          ),
        ],
      ),
    ),
  ];

  List<Widget> _linkSection(BuildContext context) => [
    const PcSectionLabel('Link'),
    PcCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PcTextField(
            controller: _linkUrl,
            hint: 'https://example.com/changelog',
            keyboardType: TextInputType.url,
            textCapitalization: TextCapitalization.none,
            prefixIcon: CupertinoIcons.link,
            onChanged: (_) => setState(() {}),
          ),
          if (_linkUrl.text.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            PcTextField(controller: _linkTitle, hint: 'Preview title', onChanged: (_) => setState(() {})),
            const SizedBox(height: 8),
            PcTextField(
              controller: _linkDescription,
              hint: 'Preview description',
              maxLines: 3,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: PcButton.secondary(
                label: 'Fill from the page',
                icon: CupertinoIcons.arrow_down_doc,
                compact: true,
                loading: _fetchingPreview,
                onPressed: _fetchPreview,
              ),
            ),
          ],
        ],
      ),
    ),
  ];

  bool _fetchingPreview = false;

  Future<void> _fetchPreview() async {
    setState(() => _fetchingPreview = true);
    final preview = await LinkPreviewFetcher().fetch(_linkUrl.text);
    if (!mounted) return;
    setState(() {
      _fetchingPreview = false;
      if (preview?.title != null) _linkTitle.text = preview!.title!;
      if (preview?.description != null) _linkDescription.text = preview!.description!;
    });
    if (preview == null || (preview.title == null && preview.description == null)) {
      showPcToast(context, "Couldn't read a preview from that page.");
    }
  }

  List<Widget> _pollSection(BuildContext context) => [
    const PcSectionLabel('Poll'),
    PcCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text('Add a poll', style: context.text.bodyLarge)),
              PcSwitch(value: _pollOn, label: 'Add a poll', onChanged: (v) => setState(() => _pollOn = v)),
            ],
          ),
          if (_pollOn) ...[
            const SizedBox(height: 12),
            PcTextField(controller: _pollQuestion, hint: 'Which screen next?', onChanged: (_) => setState(() {})),
            const SizedBox(height: 8),
            for (var i = 0; i < _pollOptions.length; i++) ...[
              Row(
                children: [
                  Expanded(
                    child: PcTextField(
                      controller: _pollOptions[i],
                      hint: 'Option ${i + 1}',
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  if (_pollOptions.length > 2)
                    PcIconButton(
                      icon: CupertinoIcons.minus_circle,
                      label: 'Remove option ${i + 1}',
                      color: context.pc.textTertiary,
                      onTap: () => setState(() => _pollOptions.removeAt(i).dispose()),
                    ),
                ],
              ),
              const SizedBox(height: 6),
            ],
            if (_pollOptions.length < 4)
              Align(
                alignment: Alignment.centerLeft,
                child: PcButton.secondary(
                  label: 'Add option',
                  icon: CupertinoIcons.plus,
                  compact: true,
                  onPressed: () => setState(() => _pollOptions.add(TextEditingController())),
                ),
              ),
            _label('Runs for'),
            PcSegmented<int>(
              values: const [1, 24, 72, 168],
              selected: _pollHours,
              labelOf: (h) => h < 24 ? '$h hour' : '${h ~/ 24} day${h == 24 ? '' : 's'}',
              onChanged: (h) => setState(() => _pollHours = h),
            ),
          ],
        ],
      ),
    ),
  ];

  List<Widget> _detailsSection(BuildContext context) => [
    const PcSectionLabel('Details'),
    PcCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _label('Location'),
          PcTextField(
            controller: _place,
            hint: 'Lisbon',
            prefixIcon: CupertinoIcons.location,
            onChanged: (_) => setState(() {}),
          ),
          _label('First comment'),
          PcTextField(
            controller: _firstComment,
            hint: 'Links and extra hashtags often go here',
            maxLines: 3,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: Text('Content warning', style: context.text.bodyLarge)),
              PcSwitch(value: _warningOn, label: 'Content warning', onChanged: (v) => setState(() => _warningOn = v)),
            ],
          ),
          if (_warningOn) ...[
            const SizedBox(height: 8),
            PcTextField(controller: _contentWarning, hint: 'Spoilers', onChanged: (_) => setState(() {})),
          ],
        ],
      ),
    ),
    const SizedBox(height: PcSpace.xs),
    PcGroup(
      children: [
        PcRow(
          title: 'Language',
          leading: const PcIconTile(icon: CupertinoIcons.globe),
          trailing: Text(languageLabel(_language), style: context.text.bodyMedium),
          onTap: () async {
            final picked = await pickLanguage(context, _language);
            if (picked != null) setState(() => _language = picked.isEmpty ? null : picked);
          },
        ),
        PcRow(
          title: 'Reminder',
          subtitle: _reminderAt == null ? null : 'You get a notification then',
          leading: const PcIconTile(icon: CupertinoIcons.bell),
          trailing: Text(_reminderAt == null ? 'Off' : dateTimeLabel(_reminderAt!), style: context.text.bodyMedium),
          onTap: () async {
            final picked = await pickReminder(context, _reminderAt);
            if (picked != null) setState(() => _reminderAt = picked.clear ? null : picked.at);
          },
        ),
      ],
    ),
    if (_draft!.hashtags.isNotEmpty || _draft!.mentions.isNotEmpty) ...[
      const SizedBox(height: PcSpace.xs),
      PcCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Found in your text', style: context.text.labelMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final h in _draft!.hashtags) PcChip(label: '#$h'),
                for (final m in _draft!.mentions) PcChip(label: '@$m'),
              ],
            ),
          ],
        ),
      ),
    ],
  ];

  List<Widget> _shareSection(BuildContext context) {
    final apps = SocialApp.values.where((a) => a != SocialApp.other).toList();
    return [
      const PcSectionLabel('Share'),
      PcCard(
        padding: const EdgeInsets.symmetric(vertical: PcSpace.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: PcSpace.cardPadding),
              child: PcButton(label: 'Share to any app', icon: CupertinoIcons.share, expand: true, onPressed: () => _share()),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: PcSpace.cardPadding),
              child: _label('Planned for'),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: PcSpace.cardPadding),
              child: Row(
                children: [
                  for (final a in apps) ...[
                    if (a != apps.first) const SizedBox(width: 6),
                    PcChip(
                      label: a.label,
                      selected: _targets.contains(a),
                      onTap: () => setState(() {
                        if (_targets.contains(a)) {
                          _targets.remove(a);
                        } else {
                          _targets.add(a);
                          _variants.putIfAbsent(a, TextEditingController.new);
                        }
                      }),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      for (final a in _targets) ...[
        const SizedBox(height: PcSpace.xs),
        PcCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(child: Text(a.label, style: context.text.titleMedium)),
                  PcButton(
                    label: 'Share',
                    compact: true,
                    onPressed: () => _share(app: a),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              PcTextField(
                controller: _variants[a],
                hint: 'Text just for ${a.label} (optional)',
                minLines: 2,
                maxLines: null,
                onChanged: (_) => setState(() {}),
              ),
              LimitRow(
                text: (_variants[a]?.text.trim().isNotEmpty ?? false) ? _variants[a]!.text : _body.text,
                apps: [a],
              ),
            ],
          ),
        ),
      ],
    ];
  }

  List<Widget> _copySection(BuildContext context) {
    final p = _draft!;
    final altTexts = p.attachments.where((a) => (a.altText ?? '').isNotEmpty).toList();
    final rows = <(String, String)>[
      if ((p.title ?? '').isNotEmpty) ('Title', p.title!),
      if (p.threadParts.isNotEmpty) ('Thread parts', p.threadParts.join('\n\n')),
      if (p.firstComment != null) ('First comment', p.firstComment!),
      if (p.poll != null) ('Poll', p.poll!.asText()),
      if (p.place != null) ('Location', p.place!.name),
      if (p.contentWarning != null) ('Content warning', p.contentWarning!),
      if (altTexts.isNotEmpty)
        ('Alt text', [for (final a in altTexts) '${p.attachments.indexOf(a) + 1}. ${a.altText}'].join('\n')),
    ];
    if (rows.isEmpty) return const [];
    return [
      const PcSectionLabel('Copy for the other app'),
      Padding(
        padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
        child: Text(
          "The share sheet only carries text and files. Copy these and paste them in the app you're posting to.",
          style: context.text.bodySmall,
        ),
      ),
      PcGroup(
        children: [
          for (final (label, value) in rows)
            PcRow(
              title: label,
              subtitle: value.split('\n').first,
              trailing: Icon(CupertinoIcons.doc_on_clipboard, size: 18, color: context.pc.textTertiary),
              onTap: () async {
                await ref.read(shareServiceProvider).copy(value);
                if (context.mounted) showPcToast(context, '$label copied');
              },
            ),
        ],
      ),
    ];
  }

  List<Widget> _privateSection(BuildContext context) {
    final collections = ref.watch(collectionsProvider).value ?? const <Collection>[];
    return [
      const PcSectionLabel('Private'),
      PcCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _label('Status'),
            PcSegmented<PostStatus>(
              values: PostStatus.values,
              selected: _status,
              labelOf: (s) => s.label,
              onChanged: (s) => setState(() => _status = s),
            ),
            _label('Collections'),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final col in collections)
                  PcChip(
                    label: col.name,
                    selected: _collectionIds.contains(col.id),
                    onTap: () => setState(() {
                      _collectionIds.contains(col.id) ? _collectionIds.remove(col.id) : _collectionIds.add(col.id);
                    }),
                  ),
                PcChip(
                  label: 'New',
                  icon: CupertinoIcons.plus,
                  onTap: () async {
                    final created = await promptNewCollection(context, ref);
                    if (created != null) setState(() => _collectionIds.add(created.id));
                  },
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: Text('Pin to Home', style: context.text.bodyLarge)),
                PcSwitch(value: _pinned, label: 'Pin to Home', onChanged: (v) => setState(() => _pinned = v)),
              ],
            ),
            _label('Notes (never shared)'),
            PcTextField(
              controller: _notes,
              hint: 'Post after the demo video is up',
              minLines: 2,
              maxLines: null,
              onChanged: (_) => setState(() {}),
            ),
          ],
        ),
      ),
    ];
  }

  Future<void> _editLink(ShareEvent s) async {
    final url = await pickLiveUrl(context, s.liveUrl);
    if (url == null) return;
    final repo = ref.read(postsRepositoryProvider);
    final link = PostLinks.parse(url);
    await repo.setLiveUrl(s.id, url.isEmpty ? null : url, target: link?.app.label);
    final fresh = await repo.getPost(_base!.id);
    if (fresh != null && mounted) setState(() => _history = fresh.shareHistory);
  }

  List<Widget> _historySection(BuildContext context) {
    if (_history.isEmpty) return const [];
    return [
      const PcSectionLabel('Share history'),
      PcGroup(
        children: [
          for (final s in _history)
            PcRow(
              title: s.target,
              subtitle: s.liveUrl ?? '${dateTimeLabel(s.sharedAt)} · add the post link',
              leading: const PcIconTile(icon: CupertinoIcons.paperplane),
              onTap: s.liveUrl == null ? () => _editLink(s) : () => openPostLink(context, ref, s.liveUrl!),
              trailing: PcIconButton(
                icon: s.liveUrl == null ? CupertinoIcons.link : CupertinoIcons.pencil,
                label: s.liveUrl == null ? 'Add link' : 'Edit link',
                color: context.pc.textTertiary,
                onTap: () => _editLink(s),
              ),
            ),
        ],
      ),
    ];
  }
}

/// Character counts against each app's limit.
class LimitRow extends StatelessWidget {
  const LimitRow({super.key, required this.text, required this.apps, this.useTitle = false});

  final String text;
  final List<SocialApp> apps;
  final bool useTitle;

  @override
  Widget build(BuildContext context) {
    final c = context.pc;
    final length = text.characters.length;
    final limited = apps.where(
      (a) => (useTitle ? a.titleLimit : a.textLimit) != null && (useTitle ? a.titleLimit! : a.textLimit!) < 10000,
    );
    final items = limited.isEmpty
        ? [Text('$length characters', style: context.text.labelMedium)]
        : [
            for (final a in limited)
              Builder(
                builder: (_) {
                  final limit = useTitle ? a.titleLimit! : a.textLimit!;
                  final over = length > limit;
                  return Text(
                    '${a.label} $length/$limit',
                    style: context.text.labelMedium!.copyWith(color: over ? c.warning : c.textTertiary),
                    semanticsLabel: over ? '${a.label}: ${length - limit} over the limit' : null,
                  );
                },
              ),
          ];
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 2),
      child: Wrap(spacing: 12, runSpacing: 2, children: items),
    );
  }
}
