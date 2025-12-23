import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationService extends GetxService {
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  Future<NotificationService> init() async {
    await _initLocalNotifications();
    _listenForeground();
    _listenTapFromBackground();
    return this;
  }

  Future<void> _initLocalNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);

    await _local.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null) {
          _handlePayload(jsonDecode(response.payload!));
        }
      },
    );

    const channel = AndroidNotificationChannel(
      'default_channel',
      'Notifications',
      importance: Importance.max,
    );

    await _local
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  void _listenForeground() {
    FirebaseMessaging.onMessage.listen((message) {
      _showLocalNotification(message);
    });
  }

  void _listenTapFromBackground() {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handlePayload(message.data);
    });
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await _local.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      notification.title,
      notification.body,
      details,
      payload: jsonEncode(message.data),
    );
  }

  void _handlePayload(Map<String, dynamic> data) {
    final type = data['type'];

    if (type == null) return;

    switch (type) {
      case 'offer':
        Get.toNamed('/offers/${data['offer_id']}');
        break;

      case 'order':
        Get.toNamed('/orders/${data['order_id']}');
        break;

      case 'wallet':
        Get.toNamed('/wallet');
        break;

      default:
        Get.toNamed('/');
    }
  }
}
