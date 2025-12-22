import 'dart:convert';

import 'package:app/services/api_service.dart';
import 'package:get/get.dart';

enum PlaceOrderState { idle, placing, success, checkoutChanged, error }

class OrderController extends GetxController {
  final Rx<PlaceOrderState> state = PlaceOrderState.idle.obs;

  final RxnInt orderId = RxnInt();
  final RxnString orderReference = RxnString();

  final RxnString errorMessage = RxnString();
  final Rx<Map<String, dynamic>?> checkoutIssues = Rx<Map<String, dynamic>?>(
    null,
  );

  Future<bool> placeOrder({
    required int addressId,
    required int paymentMethodId,
    String? couponCode,
    String? notes,
  }) async {
    if (state.value == PlaceOrderState.placing) return false;

    state.value = PlaceOrderState.placing;
    errorMessage.value = null;
    checkoutIssues.value = null;
    orderId.value = null;
    orderReference.value = null;

    try {
      final res = await ApiService.post(
        '/orders',
        data: {
          'address_id': addressId,
          'payment_method_id': paymentMethodId,
          if (couponCode != null && couponCode.isNotEmpty)
            'coupon_code': couponCode,
          if (notes != null && notes.isNotEmpty) 'notes': notes,
        },
      );

      final data = jsonDecode(res.body) as Map<String, dynamic>;
      if (res.statusCode == 201 && data['status'] == 'success') {
        orderId.value = data['order']['id'];
        orderReference.value = data['order']['reference'];
        state.value = PlaceOrderState.success;
        return true;
      }

      if (res.statusCode == 409 && data['status'] == 'checkout_changed') {
        checkoutIssues.value = Map<String, dynamic>.from(data['issues']);
        state.value = PlaceOrderState.checkoutChanged;
        return false;
      }

      errorMessage.value = data['message'] ?? 'Unable to place order';
      state.value = PlaceOrderState.error;
      return false;
    } catch (e) {
      errorMessage.value = 'Network error';
      state.value = PlaceOrderState.error;
      return false;
    }
  }

  void reset() {
    state.value = PlaceOrderState.idle;
    orderId.value = null;
    orderReference.value = null;
    errorMessage.value = null;
    checkoutIssues.value = null;
  }
}
