import 'dart:convert';

import 'package:app/models/product.dart';
import 'package:app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoritesController extends GetxController {
  final RxList<Product> favorites = <Product>[].obs;
  final RxBool isLoading = false.obs;
  final RxnString error = RxnString();

  Future<void> loadFavorites() async {
    isLoading.value = true;
    error.value = null;
    try {
      final response = await ApiService.get("/favorites");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        favorites.clear();

        if (data["favorites"] != null && data["favorites"] is List) {
          for (var fav in data["favorites"]) {
            if (fav["product"] != null) {
              favorites.add(Product.fromJson(fav["product"]));
            }
          }
        }
      } else {
        error.value = "فشل تحميل المفضلة (${response.statusCode})";
      }
    } catch (e) {
      error.value = e.toString();
      debugPrint("⚠️ Error loading favorites: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Add or remove a product from favorites
  Future<void> toggleFavorite(int productId) async {
    try {
      final response = await ApiService.post("/favorites/toggle/$productId");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // You can adapt this logic if your backend uses boolean instead of string
        if (data["status"] == "added") {
          await loadFavorites();
        } else if (data["status"] == "removed") {
          favorites.removeWhere((p) => p.id == productId);
        }
      } else {
        debugPrint("⚠️ Toggle failed (${response.statusCode})");
      }
    } catch (e) {
      debugPrint("⚠️ Error toggling favorite: $e");
    }
  }

  /// Check if a product is in favorites
  bool isFavorite(int productId) {
    return favorites.any((p) => p.id == productId);
  }

  /// Return count of favorites
  int get favoriteCount => favorites.length;

  /// Clear all favorites
  Future<void> clearFavorites() async {
    isLoading.value = true;
    error.value = null;

    try {
      final response = await ApiService.delete("/favorites/clear");
      if (response.statusCode == 200) {
        favorites.clear();
      } else {
        error.value = "فشل مسح المفضلة (${response.statusCode})";
      }
    } catch (e) {
      error.value = e.toString();
      debugPrint("⚠️ Error clearing favorites: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
