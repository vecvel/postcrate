import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../features/posts/domain/post.dart';

/// Local notifications for post reminders. Times are scheduled as absolute
/// UTC instants, so no time zone database is needed and daylight saving
/// changes can't shift them.
class Reminders {
  Reminders._();

  static final instance = Reminders._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;

  /// Called with the post id when the user taps a reminder.
  void Function(String postId)? onOpen;

  static bool get _supported => !kIsWeb && (Platform.isIOS || Platform.isAndroid);

  static int idFor(String postId) {
    var h = 0;
    for (final unit in postId.codeUnits) {
      h = (h * 31 + unit) & 0x7fffffff;
    }
    return h;
  }

  Future<void> init() async {
    if (!_supported || _ready) return;
    try {
      await _plugin.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher_monochrome'),
          iOS: DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
          ),
        ),
        onDidReceiveNotificationResponse: (r) {
          if (r.payload != null) onOpen?.call(r.payload!);
        },
      );
      _ready = true;
    } on MissingPluginException {
      // Tests and unsupported hosts.
    }
  }

  /// The post id when the app was opened from a reminder, once.
  Future<String?> launchPostId() async {
    if (!_ready) return null;
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details?.didNotificationLaunchApp != true) return null;
    return details?.notificationResponse?.payload;
  }

  Future<bool> _askPermission() async {
    if (Platform.isIOS) {
      return await _plugin
              .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
              ?.requestPermissions(alert: true, sound: true, badge: true) ??
          false;
    }
    return await _plugin
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission() ??
        true;
  }

  static const _details = NotificationDetails(
    android: AndroidNotificationDetails(
      'reminders',
      'Post reminders',
      channelDescription: 'Reminders you set on posts',
      importance: Importance.high,
      priority: Priority.high,
    ),
    iOS: DarwinNotificationDetails(),
  );

  /// Schedules or cancels the post's reminder to match its current state.
  /// Returns false when the user declined notifications.
  Future<bool> sync(Post post, {bool askPermission = true}) async {
    if (!_ready) return true;
    final id = idFor(post.id);
    final at = post.reminderAt;
    if (at == null || !at.isAfter(DateTime.now()) || post.status == PostStatus.archived) {
      await _plugin.cancel(id: id);
      return true;
    }
    if (askPermission && !await _askPermission()) return false;
    await _plugin.zonedSchedule(
      id: id,
      scheduledDate: tz.TZDateTime.from(at.toUtc(), tz.UTC),
      notificationDetails: _details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      title: 'Time to post',
      body: post.preview.length > 120 ? '${post.preview.substring(0, 117)}...' : post.preview,
      payload: post.id,
    );
    return true;
  }

  Future<void> cancel(String postId) async {
    if (_ready) await _plugin.cancel(id: idFor(postId));
  }

  /// Re-schedules every future reminder (after launch or a restore).
  Future<void> syncAll(List<Post> posts) async {
    if (!_ready) return;
    await _plugin.cancelAll();
    for (final p in posts) {
      await sync(p, askPermission: false);
    }
  }
}
