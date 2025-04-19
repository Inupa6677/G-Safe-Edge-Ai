import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static void initializeNotifications() {
    AwesomeNotifications().initialize(
      null,  // Use default icon
      [
        NotificationChannel(
          channelKey: 'danger_alerts',
          channelName: 'Danger Alerts',
          channelDescription: 'Notification channel for driving alerts',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
        ),
      ],
    );
  }

  static void showDangerNotification() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'danger_alerts',
        title: '⚠️ Dangerous Driving Detected!',
        body: 'Drive slow and be careful on the road.',
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }
}
