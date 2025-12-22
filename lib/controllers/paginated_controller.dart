import 'dart:convert';

import 'package:app/services/api_service.dart';
import 'package:get/get.dart';

class PaginatedController<T> extends GetxController {
  final String endpoint;
  final T Function(Map<String, dynamic>) fromJson;

  final RxMap<String, dynamic> params = <String, dynamic>{}.obs;

  PaginatedController({
    required this.endpoint,
    required this.fromJson,
    Map<String, dynamic>? initialParams,
  }) {
    if (initialParams != null) params.assignAll(initialParams);
  }

  // Core reactive states
  final RxList<T> items = <T>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isMoreLoading = false.obs;
  final RxnString error = RxnString();

  final RxInt currentPage = 1.obs;
  final RxnString nextPageUrl = RxnString();
  final RxnString prevPageUrl = RxnString();

  bool get hasMore => nextPageUrl.value != null;

  Future<void> fetchPage({int page = 1}) async {
    isLoading.value = true;
    error.value = null;
    try {
      final response = await ApiService.get(
        "$endpoint?page=$page",
        params: params,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<T> fetched = (data['data'] as List)
            .map((e) => fromJson(Map<String, dynamic>.from(e)))
            .toList();

        items.assignAll(fetched);
        currentPage.value = data['current_page'] ?? 1;
        nextPageUrl.value = data['next_page_url'];
        prevPageUrl.value = data['prev_page_url'];
      } else {
        error.value = "Failed to load data (${response.statusCode})";
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (!hasMore || isMoreLoading.value) return;
    isMoreLoading.value = true;

    try {
      final url = nextPageUrl.value!;
      final response = await ApiService.getUrl(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<T> fetched = (data['data'] as List)
            .map((e) => fromJson(Map<String, dynamic>.from(e)))
            .toList();

        items.addAll(fetched);
        currentPage.value = data['current_page'] ?? currentPage.value;
        nextPageUrl.value = data['next_page_url'];
        prevPageUrl.value = data['prev_page_url'];
      } else {
        error.value = "Failed to load more (${response.statusCode})";
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isMoreLoading.value = false;
    }
  }

  Future<void> refreshPage() async {
    items.clear();
    await fetchPage(page: 1);
  }

  // ---------------------------------------------
  // 🔍 Filters & Search
  // ---------------------------------------------

  /// Add or update a filter
  void setFilter(String key, dynamic value, {bool refresh = true}) {
    if (value == null || (value is String && value.isEmpty)) {
      params.remove(key);
    } else {
      params[key] = value;
    }
    if (refresh) refreshPage();
  }

  /// Remove a specific filter
  void removeFilter(String key, {bool refresh = true}) {
    params.remove(key);
    if (refresh) refreshPage();
  }

  /// Clear all filters & search
  void clearFilters({bool refresh = true}) {
    params.clear();
    if (refresh) refreshPage();
  }

  /// Smart search handler
  void setSearch(String query, {bool refresh = true}) {
    if (query.trim().isEmpty) {
      params.remove('search');
    } else {
      params['search'] = query.trim();
    }
    if (refresh) refreshPage();
  }

  /// Set multiple filters at once
  void setFilters(Map<String, dynamic> newFilters, {bool refresh = true}) {
    params.assignAll(newFilters);
    if (refresh) refreshPage();
  }
}
