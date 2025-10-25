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

    try {
      // Initialize timezone with device timezone
      tz.initializeTimeZones();
      
      // Set local timezone - try common timezones or fallback to UTC
      String timezoneName;
      try {
        // Try to detect timezone based on system time offset
        final now = DateTime.now();
        final utcOffset = now.timeZoneOffset.inHours;
        
        // Map common UTC offsets to timezone names
        switch (utcOffset) {
          case -8: timezoneName = 'America/Los_Angeles'; break;
          case -5: timezoneName = 'America/New_York'; break;
          case 0: timezoneName = 'UTC'; break;
          case 1: timezoneName = 'Europe/London'; break;
          case 7: timezoneName = 'Asia/Jakarta'; break; // WIB
          case 8: timezoneName = 'Asia/Singapore'; break;
          case 9: timezoneName = 'Asia/Tokyo'; break;
          default: timezoneName = 'UTC';
        }
      } catch (e) {
        timezoneName = 'UTC';
      }
      
      try {
        tz.setLocalLocation(tz.getLocation(timezoneName));
      } catch (e) {
        tz.setLocalLocation(tz.UTC);
      }
      
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

      // Create notification channel for Android
      if (Platform.isAndroid) {
        await _createNotificationChannel();
      }

      _isInitialized = true;
    } catch (e) {
      // Don't set _isInitialized to true if initialization fails
    }
  }

  // Handle notification tap
  static void _onNotificationTap(NotificationResponse notificationResponse) {
    // Handle notification tap - can add navigation logic here if needed
  }

  // Create notification channel for Android
  static Future<void> _createNotificationChannel() async {
    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'creditech_insights',
        'Financial Insights',
        description: 'Notifications for financial insights and tips',
        importance: Importance.defaultImportance,
        playSound: true,
        enableVibration: true,
      );

      await androidPlugin.createNotificationChannel(channel);
    }
  }

  // Request notification permissions
  static Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      // Request basic notification permission
      final notificationStatus = await Permission.notification.request();
      bool hasNotificationPermission = notificationStatus == PermissionStatus.granted;
      
      // For Android 12+ (API 31+), also request exact alarm permission
      try {
        await Permission.scheduleExactAlarm.request();
      } catch (e) {
        // Exact alarm permission may not be needed on older Android versions
      }
      return hasNotificationPermission;
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
    if (!_isInitialized) {
      await initialize();
      if (!_isInitialized) {
        return;
      }
    }
    
    try {
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
          
          // Only schedule if the time is in the future (with 1 minute buffer)
          if (notificationTime.isAfter(now.add(const Duration(minutes: 1)))) {
            try {
              await _scheduleNotification(
                id: notificationId++,
                title: 'Creditech',
                body: _getRandomMessage(),
                scheduledTime: notificationTime,
              );
            } catch (e) {
              // Failed to schedule this specific notification, continue with others
            }
          }
        }
      }
    } catch (e) {
      // Error scheduling periodic notifications
    }
  }

  // Schedule a single notification
  static Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    try {
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
        enableLights: true,
        playSound: true,
        // Additional Android settings for reliability
        ongoing: false,
        autoCancel: true,
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

      // Convert to timezone-aware DateTime
      final tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);
      
      // Verify the scheduled time is in the future
      final now = tz.TZDateTime.now(tz.local);
      if (!tzScheduledTime.isAfter(now)) {
        return;
      }

      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tzScheduledTime,
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
        matchDateTimeComponents: null, // Don't repeat, schedule once
      );
    } catch (e) {
      rethrow;
    }
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


}
