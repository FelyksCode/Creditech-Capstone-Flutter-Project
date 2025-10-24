import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:math';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  
  static bool _isInitialized = false;
  
  // Notification messages
  static final List<String> _notificationMessages = [
    "Get more insights in financial transactions",
    "Check your spending patterns today",
    "New financial insights available",
    "Review your transaction history",
    "Discover spending trends this week",
    "Your financial analysis is ready",
    "Track your expenses better",
    "Optimize your financial habits"
  ];

  // Initialize the notification service
  static Future<void> initialize() async {
    if (_isInitialized) return;

    // Initialize timezone
    tz.initializeTimeZones();
    
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    _isInitialized = true;
  }

  // Handle notification tap
  static void _onNotificationTap(NotificationResponse notificationResponse) {
    print('Notification tapped: ${notificationResponse.payload}');
  }

  // Request notification permissions
  static Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.request();
      return status == PermissionStatus.granted;
    } else if (Platform.isIOS) {
      final result = await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      return result ?? false;
    }
    return true;
  }

  // Show immediate notification
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_isInitialized) await initialize();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'creditech_insights',
      'Financial Insights',
      channelDescription: 'Notifications for financial insights and tips',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      icon: '@mipmap/ic_launcher',
      color: Color(0xFF4169E1),
      enableVibration: true,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _notificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  // Schedule periodic notifications
  static Future<void> schedulePeriodicNotifications() async {
    if (!_isInitialized) await initialize();
    
    await cancelAllNotifications();
    
    // Schedule notifications at specific times: 10 AM, 1 PM, 6 PM
    final now = DateTime.now();
    final notificationTimes = [10, 13, 18]; // 10 AM, 1 PM (13:00), 6 PM (18:00)
    
    int notificationId = 1000;
    
    // Schedule for the next 7 days
    for (int day = 0; day < 7; day++) {
      final targetDate = now.add(Duration(days: day));
      
      for (int hour in notificationTimes) {
        final notificationTime = DateTime(
          targetDate.year,
          targetDate.month,
          targetDate.day,
          hour,
          0, // minutes
          0, // seconds
        );
        
        // Only schedule if the time is in the future
        if (notificationTime.isAfter(now)) {
          await _scheduleNotification(
            id: notificationId++,
            title: 'Creditech',
            body: _getRandomMessage(),
            scheduledTime: notificationTime,
          );
        }
      }
    }
    
    print('Scheduled notifications for 10 AM, 1 PM, and 6 PM for the next 7 days');
  }

  // Schedule a single notification
  static Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'creditech_insights',
      'Financial Insights',
      channelDescription: 'Notifications for financial insights and tips',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      icon: '@mipmap/ic_launcher',
      color: Color(0xFF4169E1),
      enableVibration: true,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  // Get random message
  static String _getRandomMessage() {
    final random = Random();
    return _notificationMessages[random.nextInt(_notificationMessages.length)];
  }

  // Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  // Cancel specific notification
  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  // Get pending notifications (for debugging)
  static Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notificationsPlugin.pendingNotificationRequests();
  }

  // Show test notification
  static Future<void> showTestNotification() async {
    await showNotification(
      id: 999,
      title: 'Creditech',
      body: _getRandomMessage(),
      payload: 'test_notification',
    );
  }
}
