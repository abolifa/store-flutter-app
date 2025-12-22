import 'dart:convert';

import 'package:app/models/brand.dart';
import 'package:app/services/api_service.dart';
import 'package:get/get.dart';

class BrandsController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isMoreLoading = false.obs;
  final RxBool hasMore = true.obs;
  final RxList<Brand> items = <Brand>[].obs;
  final RxString error = ''.obs;

  int _page = 1;
  final int _perPage = 12;

  @override
  void onInit() {
    super.onInit();
    fetchFirstPage();
  }

  Future<void> fetchFirstPage() async {
    _page = 1;
    hasMore.value = true;
    items.clear();
    await _fetch();
  }

  Future<void> loadMore() async {
    if (isMoreLoading.value || !hasMore.value) return;
    _page++;
    await _fetch(isMore: true);
  }

  Future<void> refreshPage() async {
    await fetchFirstPage();
  }

  Future<void> _fetch({bool isMore = false}) async {
    try {
      if (isMore) {
        isMoreLoading.value = true;
      } else {
        isLoading.value = true;
        error.value = '';
      }

      final res = await ApiService.get(
        '/brands?page=$_page&per_page=$_perPage',
      );

      if (res.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(res.body);

        final List<Brand> fetched = (data['data'] as List)
            .map((e) => Brand.fromJson(e))
            .toList();

        items.addAll(fetched);
        hasMore.value = data['has_more'] == true;
      } else {
        error.value = 'Failed to load brands';
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }
}
