import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:i_supply_order_tracker/model/order_status_enum.dart';
import 'package:provider/provider.dart';
import 'services/notification_service.dart';
import 'view/order_tracker_screen.dart';
import 'viewmodel/order_viewmodel.dart';
import 'repository/notification_repository.dart';

// Handle background messages
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("📥 Background message received: ${message.notification?.title}");
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await setupFlutterNotifications();

  await FirebaseMessaging.instance.subscribeToTopic('orders');


  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request notification permission
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );


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
  FirebaseFirestore.instance
      .collection('orders')
      .doc('order_123')
      .snapshots()
      .listen((docSnapshot) {
    if (docSnapshot.exists) {
      final statusStr = docSnapshot.data()?['status'];
      final status = (statusStr as String?)?.toOrderStatus();
      if (status != null) {
        final vm = Provider.of<OrderViewModel>(
          navigatorKey.currentContext!,
          listen: false,
        );
        if (status != vm.status) {
          vm.updateStatus(status);
        }
      }
    }
  });


}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
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