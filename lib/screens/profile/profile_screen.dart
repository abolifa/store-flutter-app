import 'package:app/controllers/settings_controller.dart';
import 'package:app/screens/profile/widgets/account_widget.dart';
import 'package:app/screens/profile/widgets/fast_access_widget.dart';
import 'package:app/screens/profile/widgets/footer.dart';
import 'package:app/screens/profile/widgets/main_menu.dart';
import 'package:app/screens/profile/widgets/update_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsController>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              AccountWidget(),
              SizedBox(height: 10),
              FastAccessWidget(),
              if (settings.needsUpdate.value) UpdateWidget(),
              MainMenu(),
              const SizedBox(height: 20),
              Footer(),
            ],
          ),
        ),
      ),
    );
  }
}
