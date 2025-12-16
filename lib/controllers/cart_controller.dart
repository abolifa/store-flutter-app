import 'dart:convert';

import 'package:app/models/product.dart';
import 'package:app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartItem {
  final ProductVariant variant;
  int quantity;
  CartItem({required this.variant, required this.quantity});
}

class CartController extends GetxController {
  final RxMap<int, CartItem> items = <int, CartItem>{}.obs;
  final RxBool isLoading = false.obs;
  final RxnString error = RxnString();

  double get subtotal => items.values.fold(
    0.0,
    (t, i) =>
        t + ((i.variant.price) - (i.variant.discount ?? 0.0)) * i.quantity,
  );

  int get totalCount => items.values.fold(0, (t, i) => t + i.quantity);
  Set<int> get variantIds => items.keys.toSet();

  bool hasVariant(int variantId) => items.containsKey(variantId);
  int quantityOf(int variantId) => items[variantId]?.quantity ?? 0;

  /// 🛒 Load Cart from API
  Future<void> loadCart() async {
    isLoading.value = true;
    error.value = null;

    try {
      final response = await ApiService.get("/cart");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        items.clear();

        final cartItems = data["cart"]?["items"];
        if (cartItems != null && cartItems is List) {
          for (var item in cartItems) {
            if (item["variant"] != null) {
              final variant = ProductVariant.fromJson(item["variant"]);
              final qty = item["quantity"] ?? 1;
              items[variant.id] = CartItem(variant: variant, quantity: qty);
            }
          }
        }
      } else {
        error.value = "فشل تحميل السلة (${response.statusCode})";
      }
    } catch (e) {
      error.value = e.toString();
      debugPrint("⚠️ Error loading cart: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleVariant(
    ProductVariant variant, {
    Product? parentProduct,
  }) async {
    try {
      if (variant.product == null && parentProduct != null) {
        variant = ProductVariant(
          id: variant.id,
          productId: variant.productId,
          product: parentProduct,
          unitId: variant.unitId,
          measurement: variant.measurement,
          sku: variant.sku,
          price: variant.price,
          discount: variant.discount,
          color: variant.color,
          barcode: variant.barcode,
          image: variant.image,
          unit: variant.unit,
        );
      }

      final response = await ApiService.post("/cart/toggle/${variant.id}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["removed"] == true) {
          items.remove(variant.id);
        } else if (data["added"] == true) {
          items[variant.id] = CartItem(variant: variant, quantity: 1);
        }
      } else {
        debugPrint("⚠️ Toggle failed (${response.statusCode})");
      }
    } catch (e) {
      debugPrint("⚠️ Toggle error: $e");
    } finally {
      items.refresh();
    }
  }

  Future<void> increaseVariant(int variantId) async {
    try {
      await ApiService.post("/cart/increase/$variantId");
      items[variantId]?.quantity = (items[variantId]?.quantity ?? 0) + 1;
      items.refresh();
    } catch (e) {
      debugPrint("⚠️ Increase error: $e");
    }
  }

  /// 🔽 Decrease quantity
  Future<void> decreaseVariant(int variantId) async {
    try {
      final response = await ApiService.post("/cart/decrease/$variantId");
      final data = jsonDecode(response.body);

      if (data["message"] == "item_removed") {
        items.remove(variantId);
      } else {
        final current = items[variantId];
        if (current != null && current.quantity > 1) {
          current.quantity--;
        } else {
          items.remove(variantId);
        }
      }
      items.refresh();
    } catch (e) {
      debugPrint("⚠️ Decrease error: $e");
    }
  }

  /// 🗑️ Clear all items in cart
  Future<void> clearCart() async {
    try {
      await ApiService.delete("/cart/clear");
      items.clear();
    } catch (e) {
      debugPrint("⚠️ Clear error: $e");
    } finally {
      items.refresh();
    }
  }
}
