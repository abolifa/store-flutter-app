import 'dart:convert';

import 'package:app/models/product.dart';
import 'package:app/services/api_service.dart';
import 'package:get/get.dart';

class ProductDetailsController extends GetxController {
  final Rxn<Product> product = Rxn<Product>();
  final RxList<Product> relatedProducts = <Product>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isRelatedLoading = false.obs;
  final RxnString error = RxnString();

  final int productId;

  ProductDetailsController(this.productId);

  @override
  void onInit() {
    super.onInit();
    fetchProduct();
    fetchRelated();
  }

  Future<void> fetchProduct() async {
    isLoading.value = true;
    error.value = null;

    try {
      final res = await ApiService.get("/products/$productId");
      final data = jsonDecode(res.body);

      if (res.statusCode == 200) {
        product.value = Product.fromJson(data);
      } else {
        error.value = data['message'] ?? 'product_not_found';
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchRelated() async {
    isRelatedLoading.value = true;

    try {
      final res = await ApiService.get("/products/$productId/related");
      final data = jsonDecode(res.body);

      if (res.statusCode == 200 && data['data'] != null) {
        final List list = data['data'];
        relatedProducts.assignAll(
          list.map((e) => Product.fromJson(e)).toList(),
        );
      } else {
        relatedProducts.clear();
      }
    } catch (_) {
      relatedProducts.clear();
    } finally {
      isRelatedLoading.value = false;
    }
  }

  void refreshAll() {
    fetchProduct();
    fetchRelated();
  }
}
