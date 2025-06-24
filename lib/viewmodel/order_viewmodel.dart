// viewmodel/order_viewmodel.dart
import 'package:flutter/material.dart';
import '../model/order_status_enum.dart';
import '../repository/notification_repository.dart';

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

      await notificationRepo.showLocalNotification(
        title: 'Order Status Update 🚚',
        body: 'Order status updated from ${oldStatus.label} to ${newStatus.label}',
      );
    }
  }

  void cancelOrder() {
    _status = OrderStatus.cancelled;
    notifyListeners();
  }
}
