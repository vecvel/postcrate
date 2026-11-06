import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/pc_tokens.dart';
import '../../../../core/widgets/widgets.dart';

const _languages = {
  'en': 'English',
  'es': 'Spanish',
  'fr': 'French',
  'de': 'German',
  'pt': 'Portuguese',
  'it': 'Italian',
  'nl': 'Dutch',
  'hi': 'Hindi',
  'bn': 'Bengali',
  'ur': 'Urdu',
  'ar': 'Arabic',
  'tr': 'Turkish',
  'ru': 'Russian',
  'ja': 'Japanese',
  'ko': 'Korean',
  'zh': 'Chinese',
  'id': 'Indonesian',
};

String languageLabel(String? code) => code == null ? 'Not set' : (_languages[code] ?? code);

/// Returns a language code, '' for "not set", or null when dismissed.
Future<String?> pickLanguage(BuildContext context, String? current) {
  return showPcSheet<String>(
    context,
    title: 'Language',
    builder: (ctx) => PcGroup(
      children: [
        for (final e in [const MapEntry('', 'Not set'), ..._languages.entries])
          PcRow(
            title: e.value,
            trailing: (current ?? '') == e.key
                ? Icon(CupertinoIcons.checkmark, size: 18, color: ctx.pc.textPrimary)
                : null,
            onTap: () => Navigator.of(ctx).pop(e.key),
          ),
      ],
    ),
  );
}

class ReminderPick {
  const ReminderPick(this.at) : clear = false;
  const ReminderPick.clear() : at = null, clear = true;

  final DateTime? at;
  final bool clear;
}

Future<ReminderPick?> pickReminder(
  BuildContext context,
  DateTime? current, {
  String title = 'Reminder',
  String setLabel = 'Set reminder',
  String clearLabel = 'Remove reminder',
}) {
  final now = DateTime.now();
  var picked = current != null && current.isAfter(now) ? current : now.add(const Duration(hours: 1));
  return showPcSheet<ReminderPick>(
    context,
    title: title,
    builder: (ctx) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PcCard(
          padding: EdgeInsets.zero,
          child: SizedBox(
            height: 200,
            child: CupertinoTheme(
              data: CupertinoThemeData(
                brightness: Theme.of(ctx).brightness,
                textTheme: CupertinoTextThemeData(dateTimePickerTextStyle: ctx.text.bodyLarge!.copyWith(fontSize: 20)),
              ),
              child: CupertinoDatePicker(
                initialDateTime: picked,
                minimumDate: now.subtract(const Duration(minutes: 1)),
                minuteInterval: 1,
                onDateTimeChanged: (v) => picked = v,
              ),
            ),
          ),
        ),
        const SizedBox(height: PcSpace.md),
        PcButton(label: setLabel, expand: true, onPressed: () => Navigator.of(ctx).pop(ReminderPick(picked))),
        if (current != null) ...[
          const SizedBox(height: PcSpace.xs),
          PcButton.secondary(
            label: clearLabel,
            expand: true,
            onPressed: () => Navigator.of(ctx).pop(const ReminderPick.clear()),
          ),
        ],
      ],
    ),
  );
}

/// Returns the URL, '' to clear it, or null when dismissed.
Future<String?> pickLiveUrl(BuildContext context, String? current) {
  final controller = TextEditingController(text: current ?? '');
  return showPcSheet<String>(
    context,
    title: 'Link to the live post',
    builder: (ctx) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 10),
          child: Text('Paste the address of the published post so you can find it later.', style: ctx.text.bodyMedium),
        ),
        PcTextField(
          controller: controller,
          hint: 'https://',
          keyboardType: TextInputType.url,
          textCapitalization: TextCapitalization.none,
          autofocus: true,
        ),
        const SizedBox(height: PcSpace.md),
        PcButton(label: 'Save link', expand: true, onPressed: () => Navigator.of(ctx).pop(controller.text.trim())),
      ],
    ),
  ).whenComplete(controller.dispose);
}
