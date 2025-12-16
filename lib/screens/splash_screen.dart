import 'package:app/controllers/auth_controller.dart';
import 'package:app/controllers/settings_controller.dart';
import 'package:app/models/settings.dart';
import 'package:app/router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthController authController = Get.find<AuthController>();
  final SettingsController settingsController = Get.find<SettingsController>();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _waitForSettings();

    final settings = settingsController.settings.value;

    if (settings == null) {
      Get.offAllNamed(Routes.home);
      return;
    }

    if (_isMaintenance(settings)) {
      Get.offAllNamed('/maintenance');
      return;
    }

    await authController.tryAutoLogin();
    Get.offAllNamed(Routes.home);
  }

  Future<void> _waitForSettings() async {
    while (settingsController.isLoading.value ||
        settingsController.settings.value == null) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  bool _isMaintenance(Settings settings) {
    if (GetPlatform.isAndroid) {
      return settings.androidMaintenanceMode == true;
    }

    if (GetPlatform.isIOS) {
      return settings.iosMaintenanceMode == true;
    }

    return settings.webMaintenanceMode == true;
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
