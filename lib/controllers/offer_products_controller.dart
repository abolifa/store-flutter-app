import 'dart:convert';

import 'package:app/controllers/paginated_controller.dart';
import 'package:app/models/brand.dart';
import 'package:app/models/product.dart';
import 'package:app/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class OfferProductsController extends GetxController {
  final int offerId;
  late final PaginatedController<Product> pagination;

  OfferProductsController({required this.offerId});

  final RxString sortBy = ''.obs;
  final RxList<Brand> availableBrands = <Brand>[].obs;
  final RxnString selectedBrandId = RxnString();
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();

    pagination = PaginatedController<Product>(
      endpoint: '/offers/$offerId',
      fromJson: (data) => Product.fromJson(data),
    );

    _fetchBrands();
    pagination.fetchPage();
  }

  Future<void> _fetchBrands() async {
    try {
      final res = await ApiService.get('/brands');
      if (res.statusCode == 200) {
        final body = res.body;
        if (body.isEmpty) return;
        final decoded = jsonDecode(body);
        final List<dynamic> list;

        if (decoded is List) {
          list = decoded;
        } else if (decoded is Map && decoded['data'] is List) {
          list = decoded['data'];
        } else {
          return;
        }

        availableBrands.assignAll(
          list
              .map((e) => Brand.fromJson(Map<String, dynamic>.from(e)))
              .toList(),
        );
      }
    } catch (e, st) {
      debugPrint('Error fetching brands: $e\n$st');
    }
  }

  void setSearch(String query) {
    searchQuery.value = query;
    pagination.setSearch(query);
  }

  void setBrand(String? id) {
    selectedBrandId.value = id;
    if (id == null || id.isEmpty) {
      pagination.removeFilter('brand_id');
    } else {
      pagination.setFilter('brand_id', id);
    }
  }

  void setPriceRange(double? min, double? max) {
    if (min != null) pagination.setFilter('price_from', min);
    if (max != null) pagination.setFilter('price_to', max);
    if (min == null && max == null) {
      pagination.removeFilter('price_from');
      pagination.removeFilter('price_to');
    }
  }

  void setSort(String sortOption) {
    sortBy.value = sortOption;
    pagination.setFilter('sort', sortOption);
  }

  void clearAllFilters() {
    sortBy.value = '';
    selectedBrandId.value = null;
    searchQuery.value = '';
    pagination.clearFilters();
  }

  // Pagination helpers
  Future<void> refreshPage() async => pagination.refreshPage();
  Future<void> loadMore() async => pagination.loadMore();
}
