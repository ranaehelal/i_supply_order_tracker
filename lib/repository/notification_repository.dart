import '../services/notification_service.dart';

class NotificationRepository {
  Future<void> showLocalNotification({
    required String title,
    required String body,
  }) async {
    await showSimpleNotification(title: title, body: body);
  }
}
