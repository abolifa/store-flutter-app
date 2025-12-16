import 'package:app/controllers/settings_controller.dart';
import 'package:app/router.dart';
import 'package:app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 280,
                  child: Lottie.asset(
                    'assets/animations/maintenance.json',
                    fit: BoxFit.contain,
                  ),
                ),
                Text(
                  'نقوم حالياً بأعمال صيانة',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'نعمل على تحسين الأداء وتجربة الاستخدام.\nسيعود التطبيق للعمل قريباً.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.6,
                    color: const Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: 200,
                  child: CustomButton(
                    text: "إعادة المحاولة",
                    onPressed: () async {
                      final settingsController = Get.find<SettingsController>();
                      await settingsController.fetchSettings();
                      Get.offAllNamed(Routes.splash);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
