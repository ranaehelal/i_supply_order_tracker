import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'services/notification_service.dart';
import 'view/order_status_screen.dart';
import 'viewmodel/order_viewmodel.dart';
import 'repository/notification_repository.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await setupFlutterNotifications();

  await FirebaseMessaging.instance.subscribeToTopic('orders');


  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request notification permission
  NotificationSettings settings = await messaging.requestPermission();

  // Print FCM token
  // Dont forget to remove this  !!!!!!!!!!!!
  String? token = await messaging.getToken();
  print("--> 📱 Device FCM Token: $token");

  // Handle notification when app is in foreground
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("📥 Foreground message received: ${message.notification?.title}");
    showFlutterNotification(message);
  });

  runApp(
    ChangeNotifierProvider(
      create: (_) => OrderViewModel(NotificationRepository()),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Order Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: OrderTrackerScreen(),
    );
  }
}