import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;

    // Inicializar zonas horarias
    tzdata.initializeTimeZones();
    try {
      final tzName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(tzName));
    } catch (_) {
      // Fallback a UTC si falla la detección
    }

    // Configurar Android
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/launcher_icon',
    );

    // Configurar iOS
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    // Inicializar plugin
    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: _onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: _onBackgroundTap,
    );

    _initialized = true;
  }

  static void _onNotificationTap(NotificationResponse response) {
    // Manejar tap en notificación cuando la app está abierta
    debugPrint('Notification tapped: ${response.payload}');
  }

  @pragma('vm:entry-point')
  static void _onBackgroundTap(NotificationResponse response) {
    // Manejar tap en notificación cuando la app estaba cerrada
    debugPrint('Background notification tapped: ${response.payload}');
  }

  static Future<bool> requestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (android != null) {
      final granted = await android.requestNotificationsPermission();
      return granted ?? false;
    }

    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();

    if (ios != null) {
      final granted = await ios.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    return true;
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'billing_reminders',
        'Recordatorios de Cobro',
        channelDescription: 'Notificaciones de cobros pendientes',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _plugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  static Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id);
  }

  static Future<void> cancelAllNotifications() async {
    await _plugin.cancelAll();
  }

  static Future<void> scheduleBillingReminders({
    required List<Map<String, dynamic>> reminders,
  }) async {
    await cancelAllNotifications();

    final now = tz.TZDateTime.now(tz.local);

    for (int i = 0; i < reminders.length; i++) {
      final reminder = reminders[i];
      final reminderDate = DateTime.parse(reminder['reminder_date'] as String);
      final companyName = reminder['company_name'] as String? ?? 'Empresa';
      final amount = reminder['amount'] as double?;

      const notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'billing_reminders',
          'Recordatorios de Cobro',
          channelDescription: 'Notificaciones de cobros pendientes',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      );

      // Schedule 3 days before
      final date3 = reminderDate.subtract(const Duration(days: 3));
      final notify3 = tz.TZDateTime(tz.local, date3.year, date3.month, date3.day, 9, 0);

      if (notify3.isAfter(now)) {
        final amountStr = amount != null
            ? '\$${amount.toStringAsFixed(0)} COP'
            : '';
        await _plugin.zonedSchedule(
          i * 2,
          'Cobro en 3 dias',
          '$companyName - $amountStr vence el ${reminderDate.day}/${reminderDate.month}',
          notify3,
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        );
      }

      // Schedule 1 day before
      final date1 = reminderDate.subtract(const Duration(days: 1));
      final notify1 = tz.TZDateTime(tz.local, date1.year, date1.month, date1.day, 9, 0);

      if (notify1.isAfter(now)) {
        final amountStr = amount != null
            ? '\$${amount.toStringAsFixed(0)} COP'
            : '';
        await _plugin.zonedSchedule(
          i * 2 + 1,
          'Cobro manana',
          '$companyName - $amountStr vence manana',
          notify1,
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        );
      }
    }
  }
}
