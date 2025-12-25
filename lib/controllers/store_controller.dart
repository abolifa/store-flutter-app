import 'dart:convert';

import 'package:app/models/store_perks.dart';
import 'package:app/services/api_service.dart';
import 'package:get/get.dart';

class StoreController extends GetxController {
  final RxBool isLoading = false.obs;
  final Rxn<StorePerks> storePerks = Rxn<StorePerks>();
  final RxString error = ''.obs;

  Future<void> fetchStorePerks({required int storeId}) async {
    try {
      isLoading.value = true;
      error.value = '';
      final res = await ApiService.get('/stores/$storeId/perks');
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        storePerks.value = StorePerks.fromJson(data);
      } else {
        error.value = data['message'] ?? 'Failed to load store perks';
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
