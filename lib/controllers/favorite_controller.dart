import 'dart:convert';

import 'package:app/models/home_product.dart';
import 'package:app/services/api_service.dart';
import 'package:get/get.dart';

class FavoriteController extends GetxController {
  final RxList<HomeProduct> favorites = <HomeProduct>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  int get count => favorites.length;

  Future<void> loadFavorites() async {
    isLoading.value = true;
    error.value = '';

    try {
      final res = await ApiService.get('/favorites');

      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        favorites.value = data.map((e) => HomeProduct.fromJson(e)).toList();
      } else {
        error.value = res.body;
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  bool isFavorited(int productId) {
    return favorites.any((p) => p.id == productId);
  }

  Future<bool> toggleFavorite(int productId) async {
    try {
      final res = await ApiService.post('/favorites/toggle/$productId');

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final bool favorited = data['favorited'] == true;
        if (favorited) {
          await loadFavorites();
        } else {
          favorites.removeWhere((p) => p.id == productId);
        }
        return favorited;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<void> clearFavorites() async {
    isLoading.value = true;
    try {
      final res = await ApiService.delete('/favorites/clear');
      if (res.statusCode == 200) {
        favorites.clear();
      }
    } finally {
      isLoading.value = false;
    }
  }
}
