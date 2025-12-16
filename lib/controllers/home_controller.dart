import 'dart:convert';

import 'package:app/models/home_data.dart';
import 'package:app/services/api_service.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxBool isLoading = false.obs;
  final Rxn<HomeData> homeData = Rxn<HomeData>();
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHomeData();
  }

  Future<void> fetchHomeData() async {
    try {
      isLoading.value = true;
      error.value = '';
      final res = await ApiService.get('/home');
      if (res.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(res.body);
        homeData.value = HomeData.fromJson(data);
      } else {
        error.value = 'Failed to load home data';
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshHome() async {
    await fetchHomeData();
  }
}
