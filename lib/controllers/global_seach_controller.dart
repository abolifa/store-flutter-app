import 'dart:convert';

import 'package:app/controllers/paginated_controller.dart';
import 'package:app/models/brand.dart';
import 'package:app/models/product.dart';
import 'package:app/models/session.dart';
import 'package:app/services/api_service.dart';
import 'package:get/get.dart';

class GlobalSearchController extends GetxController {
  late final PaginatedController<Product> pagination;

  final RxList<Brand> availableBrands = <Brand>[].obs;
  final RxnString selectedBrandId = RxnString();
  final RxString sortBy = ''.obs;
  final RxDouble? minPrice = RxDouble(0);
  final RxDouble? maxPrice = RxDouble(0);
  final RxString searchQuery = ''.obs;

  final RxString viewType = (Session.get(SessionKey.productViewType) ?? 'grid')
      .toString()
      .obs;

  @override
  void onInit() {
    super.onInit();
    pagination = PaginatedController<Product>(
      endpoint: '/products',
      fromJson: (data) => Product.fromJson(data),
    );
    _fetchBrands();
    pagination.fetchPage();
  }

  Future<void> _fetchBrands() async {
    try {
      final res = await ApiService.get('/brands');
      if (res.statusCode == 200 && res.body.isNotEmpty) {
        final decoded = jsonDecode(res.body);
        final list = decoded is List
            ? decoded
            : (decoded is Map && decoded['data'] is List
                  ? decoded['data']
                  : []);
        availableBrands.assignAll(
          list
              .map((e) => Brand.fromJson(Map<String, dynamic>.from(e)))
              .toList(),
        );
      }
    } catch (_) {}
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
    minPrice?.value = 0;
    maxPrice?.value = 0;
    searchQuery.value = '';
    pagination.clearFilters();
  }

  Future<void> refreshPage() async => pagination.refreshPage();
  Future<void> loadMore() async => pagination.loadMore();
}
