// File: lib/notification_service.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


// Global obj
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

/// Initialize FCM & local notification setup
Future<void> setupFlutterNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
  InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: DarwinInitializationSettings(),
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Create a notification channel for Android
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'order_channel', // ID
    'Order Updates', // Name
    description: 'This channel is for order status notifications.',
    importance: Importance.max,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}



/// Show local notification manually when app is in foreground
void showFlutterNotification(RemoteMessage message) {
  print("🔔 Running showFlutterNotification...");

  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

  print("✅ Notification title: ${notification?.title}");
  print("✅ Notification body: ${notification?.body}");

  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title ?? "No Title",
      notification.body ?? "No Body",
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'order_channel',
          'Order Updates',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: message.data.toString(),

    );
  } else {
    print("⚠️ Notification or Android data is null.");
  }
}

Future<void> showSimpleNotification({
  required String title,
  required String body,
}) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    'order_channel',
    'Order Updates',
    channelDescription: 'This channel is for order status notifications.',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: true,
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

  await flutterLocalNotificationsPlugin.show(
    0,
    title,
    body,
    platformChannelSpecifics,
  );
}