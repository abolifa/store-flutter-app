import 'dart:io';

import 'package:app/controllers/auth_controller.dart';
import 'package:app/controllers/settings_controller.dart';
import 'package:app/widgets/app_dialog.dart';
import 'package:app/widgets/custom_button.dart';
import 'package:app/widgets/social_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final settings = Get.find<SettingsController>();
    return Column(
      children: [
        Obx(() {
          if (!auth.isAuthenticated.value) {
            return const SizedBox.shrink();
          }
          return CustomButton(
            text: 'تسجيل الخروج',
            onPressed: () async {
              await showCupertinoDialogBox(
                context: context,
                title: 'خروج؟',
                message: 'هل أنت متأكد من تسجيل الخروج',
                onConfirm: () async {
                  await auth.logout();
                  Get.back();
                },
              );
            },
            backgroundColor: Colors.white,
            foregroundColor: Colors.grey.shade800,
            icon: Icon(LucideIcons.power300),
            textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          );
        }),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 10, bottom: 30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Column(
            spacing: 10,
            children: [
              TextButton(
                onPressed: () {},
                child: Text(
                  'بِع معنا',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Divider(
                color: Colors.grey.shade200,
                thickness: 0.7,
                indent: 20,
                endIndent: 20,
              ),
              SocialIcons(),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 5,
          children: [
            Text(
              "نسخة التطبيق",
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
            ),
            Text(
              Platform.isAndroid
                  ? settings.settings.value?.androidAppVersion.toString() ?? ""
                  : settings.settings.value?.iosAppVersion.toString() ?? "",
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateTime.now().year.toString(),
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            Text('©', style: TextStyle(fontSize: 13, color: Colors.grey)),
            Text('|', style: TextStyle(fontSize: 13, color: Colors.grey)),
            Text(
              settings.settings.value?.siteName ?? '',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            Text(
              'جميع الحقوق محفوظة',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
