import 'package:app/controllers/paginated_controller.dart';
import 'package:app/models/brand.dart';
import 'package:app/models/product.dart';
import 'package:get/get.dart';

class BrandProductsController extends GetxController {
  final int brandId;
  late final PaginatedController<Product> pagination;

  BrandProductsController({required this.brandId});

  final RxString sortBy = ''.obs;
  final RxDouble? minPrice = RxDouble(0);
  final RxDouble? maxPrice = RxDouble(0);
  final RxString searchQuery = ''.obs;
  final RxList<Brand> availableBrands = <Brand>[].obs;
  final RxnString selectedCategoryId = RxnString();

  @override
  void onInit() {
    super.onInit();
    pagination = PaginatedController<Product>(
      endpoint: '/brands/$brandId/products',
      fromJson: (data) => Product.fromJson(data),
    );

    pagination.fetchPage();
  }

  void setSearch(String query) {
    searchQuery.value = query;
    pagination.setSearch(query);
  }

  void setCategory(String? id) {
    selectedCategoryId.value = id;
    if (id == null || id.isEmpty) {
      pagination.removeFilter('category_id');
    } else {
      pagination.setFilter('category_id', id);
    }
  }

  void setPriceRange(double? min, double? max) {
    if (min != null) {
      pagination.setFilter('price_from', min);
    } else {
      pagination.removeFilter('price_from');
    }

    if (max != null) {
      pagination.setFilter('price_to', max);
    } else {
      pagination.removeFilter('price_to');
    }
  }

  void setSort(String sortOption) {
    sortBy.value = sortOption;
    pagination.setFilter('sort', sortOption);
  }

  void clearAllFilters() {
    sortBy.value = '';
    minPrice?.value = 0;
    maxPrice?.value = 0;
    searchQuery.value = '';
    selectedCategoryId.value = null;
    pagination.clearFilters();
  }

  Future<void> refreshPage() async => pagination.refreshPage();
  Future<void> loadMore() async => pagination.loadMore();
}
