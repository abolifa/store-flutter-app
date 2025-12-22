import 'dart:convert';

import 'package:app/models/product.dart';
import 'package:app/services/api_service.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  final RxList<Product> products = <Product>[].obs;
  final RxBool isLoading = false.obs;
  final RxnString error = RxnString();

  Future<void> fetchProductsByIds(List<int> ids) async {
    if (ids.isEmpty) return;
    isLoading.value = true;
    try {
      final res = await ApiService.get(
        "/products/ids",
        params: {"ids": jsonEncode(ids)},
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200 && data['data'] != null) {
        final List<dynamic> items = data['data'];
        products.assignAll(items.map((e) => Product.fromJson(e)).toList());
        error.value = null;
      } else {
        products.clear();
        error.value = data['message'] ?? 'unknown_error';
      }
    } catch (e) {
      products.clear();
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void clear() {
    products.clear();
    error.value = null;
  }
}
