import 'dart:io';

import 'package:app/services/api_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class FcmService extends GetxService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  String? fcmToken;

  Future<FcmService> init() async {
    await _requestPermission();
    await _initToken();
    _listenTokenRefresh();
    _listenForeground();
    _listenOnMessageOpened();
    return this;
  }

  Future<void> _requestPermission() async {
    await _messaging.requestPermission();
  }

  Future<void> _initToken() async {
    fcmToken = await _messaging.getToken();
  }

  void _listenTokenRefresh() {
    _messaging.onTokenRefresh.listen((token) {
      fcmToken = token;
    });
  }

  void _listenForeground() {
    FirebaseMessaging.onMessage.listen((message) {});
  }

  void _listenOnMessageOpened() {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {});
  }

  Future<void> syncToken() async {
    if (fcmToken == null) return;
    await ApiService.post(
      '/fcm',
      data: {'fcm_token': fcmToken, 'platform': Platform.operatingSystem},
    );
  }
}
