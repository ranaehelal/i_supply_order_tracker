//lib/services/fcm_service.dart
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/auth_io.dart';

Future<void> sendFCMTOTopic({
  required String topic,
  required String title,
  required String body,
}) async {

  final serviceAccount = File('lib/keys/isupplyordertracker-firebase-adminsdk-fbsvc-7c5684ea3f.json');

  final serviceAccountJson = json.decode(await serviceAccount.readAsString());

  final accountCredentials = ServiceAccountCredentials.fromJson(serviceAccountJson);

  final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

  final authClient = await clientViaServiceAccount(accountCredentials, scopes);

  final fcmMessaging = FirebaseMessaging.instance;
  final fcmMessage = {
    "message": {
      "topic": topic,
      "notification": {
        "title": title,
        "body": body,
      }
    },
    "android": {
    "priority": "high",
    },
    "apns": {
    "headers": {
    "apns-priority": "10"
    },
    }
  };

  final projectId = serviceAccountJson['project_id'];

  final url = 'https://fcm.googleapis.com/v1/projects/$projectId/messages:send';

  final response = await authClient.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(fcmMessage),
  );

  print(" FCM sent: ${response.statusCode}");
  print("Response: ${response.body}");


}