// viewmodel/order_viewmodel.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/order_status_enum.dart';
import '../repository/notification_repository.dart';
import '../services/fcm_service.dart';

class OrderViewModel extends ChangeNotifier {
  final NotificationRepository notificationRepo;

  OrderViewModel(this.notificationRepo);

  OrderStatus _status = OrderStatus.pending;

  OrderStatus get status => _status;

  Future<void> updateStatus(OrderStatus newStatus) async {
    if (newStatus.index > _status.index) {
      final oldStatus = _status;
      _status = newStatus;
      notifyListeners();

      // Save to Firestore
      await FirebaseFirestore.instance
          .collection('orders')
          .doc('order_123')
          .set({'status': newStatus.asString});

      // Notifications

      await notificationRepo.showLocalNotification(
        title: 'Order Status Update 🚚',
        body: 'Order status updated from ${oldStatus.label} to ${newStatus.label}',
      );
      try {
        await sendFCMTOTopic(
          topic: 'orders',
          title: 'Order Status Update - Pharma Seller',
          body: 'Your order status changed from ${oldStatus.label} to ${newStatus.label}',
        );
      }catch (e) {
        print('Error sending FCM notification: $e');
      }


    }
  }

  Future<void> cancelOrder() async {
    final oldStatus = _status;
    _status = OrderStatus.cancelled;
    notifyListeners();
    // Save to Firestore
    await FirebaseFirestore.instance
        .collection('orders')
        .doc('order_123')
        .set({'status': _status.asString});


    // Show local notification for cancellation
    await notificationRepo.showLocalNotification(
      title: 'Order Cancelled ❌',
      body: 'Your order has been cancelled',
    );

    try {
      await sendFCMTOTopic(
        topic: 'orders',
        title: 'Order Cancelled - Pharma Seller',
        body: 'Your order has been cancelled',
      );
    } catch (e) {
      print('Error sending FCM notification: $e');
    }
  }
  // Reset order to start from beginning (for demo purposes)
  Future<void> resetOrder() async {
    _status = OrderStatus.pending;
    notifyListeners();

    // Save to Firestore
    await FirebaseFirestore.instance
        .collection('orders')
        .doc('order_123')
        .set({'status': _status.asString});


    // Show local notification for reset
    await notificationRepo.showLocalNotification(
      title: 'New Order Started ',
      body: 'Starting a new order tracking demo',
    );

    // Send FCM notification for reset
    try {
      await sendFCMTOTopic(
        topic: 'orders',
        title: 'New Order - Pharma Seller',
        body: 'Starting a new order tracking demo',
      );
    } catch (e) {
      print('Error sending FCM notification: $e');
    }
  }
  // Check if order is in final state
  bool get isOrderInFinalState =>
      _status == OrderStatus.delivered || _status == OrderStatus.cancelled;

  }

