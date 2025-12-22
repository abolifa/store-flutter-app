import 'dart:convert';

import 'package:app/models/settings.dart';
import 'package:app/services/api_service.dart';
import 'package:app/services/version_helper.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  final RxBool isLoading = false.obs;
  final Rxn<Settings> settings = Rxn<Settings>();
  final RxMap<String, dynamic> singleSetting = <String, dynamic>{}.obs;
  final RxString error = ''.obs;
  final RxBool needsUpdate = false.obs;
  Settings? get _settings => settings.value;

  @override
  void onInit() {
    super.onInit();
    fetchSettings();
  }

  Future<void> fetchSettings() async {
    try {
      isLoading.value = true;
      error.value = '';
      final res = await ApiService.get('/settings');
      if (res.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(res.body);
        settings.value = Settings.fromJson(data);
        await checkForUpdate();
      } else {
        error.value = 'Failed to load settings';
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSetting(String key) async {
    try {
      isLoading.value = true;
      error.value = '';
      final res = await ApiService.get('/settings/$key');
      if (res.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(res.body);
        singleSetting.assignAll(data);
      } else {
        error.value = 'Setting not found';
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkForUpdate() async {
    final s = settings.value;
    if (s == null) return;
    final currentVersion = await AppVersionService.getAppVersion();
    String? requiredVersion;
    if (GetPlatform.isAndroid) {
      requiredVersion = s.androidAppVersion;
    } else if (GetPlatform.isIOS) {
      requiredVersion = s.iosAppVersion;
    }
    if (requiredVersion == null || requiredVersion.isEmpty) {
      needsUpdate.value = false;
      return;
    }
    needsUpdate.value = VersionHelper.isLowerThan(
      currentVersion,
      requiredVersion,
    );
  }

  bool get isMaintenanceMode {
    final s = _settings;
    if (GetPlatform.isAndroid) {
      return s?.androidMaintenanceMode ?? false;
    } else if (GetPlatform.isIOS) {
      return s?.iosMaintenanceMode ?? false;
    }
    return false;
  }
}
