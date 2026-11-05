import 'package:intl/intl.dart';

DateTime dayOf(DateTime t) => DateTime(t.year, t.month, t.day);

/// Section label for a calendar day: Today, Yesterday, weekday, or a date.
String dayLabel(DateTime t, {DateTime? now}) {
  final today = dayOf(now ?? DateTime.now());
  final d = dayOf(t);
  final diff = today.difference(d).inDays;
  if (diff == 0) return 'Today';
  if (diff == 1) return 'Yesterday';
  if (diff > 1 && diff < 7) return DateFormat.EEEE().format(d);
  if (d.year == today.year) return DateFormat.MMMMd().format(d);
  return DateFormat.yMMMMd().format(d);
}

String timeLabel(DateTime t) => DateFormat.jm().format(t);

String dateTimeLabel(DateTime t) => '${dayLabel(t)}, ${timeLabel(t)}';

/// Compact "ago" label for stats: now, 5m, 2h, 3d, or a short date.
String agoLabel(DateTime? t, {DateTime? now}) {
  if (t == null) return 'Never';
  final d = (now ?? DateTime.now()).difference(t);
  if (d.inMinutes < 1) return 'Now';
  if (d.inMinutes < 60) return '${d.inMinutes}m';
  if (d.inHours < 24) return '${d.inHours}h';
  if (d.inDays < 7) return '${d.inDays}d';
  return DateFormat.MMMd().format(t);
}

String fileSizeLabel(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(0)} KB';
  if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
}

/// 0:42, 3:05, 1:02:09
String durationLabel(int ms) {
  final total = (ms / 1000).round();
  final h = total ~/ 3600, m = (total % 3600) ~/ 60, s = total % 60;
  final ss = s.toString().padLeft(2, '0');
  return h > 0 ? '$h:${m.toString().padLeft(2, '0')}:$ss' : '$m:$ss';
}

String bitrateLabel(int bps) {
  if (bps >= 1000000) return '${(bps / 1000000).toStringAsFixed(bps >= 10000000 ? 0 : 1)} Mbps';
  if (bps >= 1000) return '${(bps / 1000).round()} kbps';
  return '$bps bps';
}

/// Simplest whole-number aspect ratio, or a decimal ratio when it isn't neat.
String aspectLabel(int w, int h) {
  int gcd(int a, int b) => b == 0 ? a : gcd(b, a % b);
  final g = gcd(w, h);
  final rw = w ~/ g, rh = h ~/ g;
  if (rw <= 32 && rh <= 32) return '$rw:$rh';
  return '${(w / h).toStringAsFixed(2)}:1';
}
