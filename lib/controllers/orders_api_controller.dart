import 'dart:convert';

import 'package:app/models/order.dart';
import 'package:app/services/api_service.dart';
import 'package:get/get.dart';

class OrdersApiController extends GetxController {
  final RxList<Order> orders = <Order>[].obs;
  final Rxn<Order> order = Rxn<Order>();
  final RxBool isLoading = false.obs;
  final RxBool isMoreLoading = false.obs;
  final RxInt currentPage = 1.obs;
  final RxnString nextPageUrl = RxnString();
  final RxBool isLoadingOrder = false.obs;

  bool get hasMore => nextPageUrl.value != null;

  Future<void> fetch({int page = 1}) async {
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      final res = await ApiService.get('/orders?page=$page');

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        final paginator = decoded['data'];

        final List<Order> fetched = (paginator['data'] as List)
            .map((e) => Order.fromJson(Map<String, dynamic>.from(e)))
            .toList();

        orders.assignAll(fetched);
        currentPage.value = paginator['current_page'];
        nextPageUrl.value = paginator['next_page_url'];
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchOrder(int orderId) async {
    if (isLoadingOrder.value) return;

    isLoadingOrder.value = true;
    try {
      final res = await ApiService.get('/orders/$orderId');
      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        order.value = Order.fromJson(
          Map<String, dynamic>.from(decoded['data']),
        );
      }
    } finally {
      isLoadingOrder.value = false;
    }
  }

  Future<void> loadMore() async {
    if (!hasMore || isMoreLoading.value) return;

    isMoreLoading.value = true;

    try {
      final res = await ApiService.getUrl(nextPageUrl.value!);

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        final paginator = decoded['data'];

        final List<Order> fetched = (paginator['data'] as List)
            .map((e) => Order.fromJson(Map<String, dynamic>.from(e)))
            .toList();

        orders.addAll(fetched);
        currentPage.value = paginator['current_page'];
        nextPageUrl.value = paginator['next_page_url'];
      }
    } finally {
      isMoreLoading.value = false;
    }
  }

  @override
  Future<void> refresh() async {
    orders.clear();
    await fetch(page: 1);
  }
}
