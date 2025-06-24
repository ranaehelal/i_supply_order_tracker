//lib/OrderStatus.dart
import 'package:flutter/material.dart';

enum OrderStatus {
  pending,
  confirmed,
  shipped,
  delivered,
  cancelled,
}

extension OrderStatusExtension on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.pending:
        return "Pending";
      case OrderStatus.confirmed:
        return "Confirmed";
      case OrderStatus.shipped:
        return "Shipped";
      case OrderStatus.delivered:
        return "Delivered";
      case OrderStatus.cancelled:
        return "Cancelled";
    }
  }

  IconData get icon {
    switch (this) {
      case OrderStatus.pending:
        return Icons.hourglass_empty;
      case OrderStatus.confirmed:
        return Icons.check_circle;
      case OrderStatus.shipped:
        return Icons.local_shipping;
      case OrderStatus.delivered:
        return Icons.flag;
      case OrderStatus.cancelled:
        return Icons.cancel;
    }
  }

  Color get color {
    switch (this) {
      case OrderStatus.pending:
        return Colors.grey;
      case OrderStatus.confirmed:
        return Colors.blue;
      case OrderStatus.shipped:
        return Colors.orange;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  int get indexInTrack {
    switch (this) {
      case OrderStatus.pending:
        return 0;
      case OrderStatus.confirmed:
        return 1;
      case OrderStatus.shipped:
        return 2;
      case OrderStatus.delivered:
        return 3;
      case OrderStatus.cancelled:
        return -1;
    }
  }

  String get description {
    switch (this) {
      case OrderStatus.pending:
        return "Order is waiting for confirmation";
      case OrderStatus.confirmed:
        return "Order has been confirmed and is being prepared";
      case OrderStatus.shipped:
        return "Order is on its way to you";
      case OrderStatus.delivered:
        return "Order has been delivered successfully";
      case OrderStatus.cancelled:
        return "Order has been cancelled";
    }
  }
}


