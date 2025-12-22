import 'dart:convert';

import 'package:app/models/checkout.dart';
import 'package:app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutController extends GetxController {
  final RxBool isLoading = false.obs;
  final Rx<CheckoutResponse?> checkout = Rx<CheckoutResponse?>(null);
  final RxString error = ''.obs;

  final RxnString couponCode = RxnString();

  Future<void> loadCheckout(int addressId) async {
    isLoading.value = true;
    error.value = '';

    try {
      final res = await ApiService.post(
        '/orders/checkout',
        data: {
          'address_id': addressId,
          if (couponCode.value != null && couponCode.value!.isNotEmpty)
            'coupon_code': couponCode.value,
        },
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        checkout.value = CheckoutResponse.fromJson(data);
        return;
      }

      if (res.statusCode == 422) {
        final data = jsonDecode(res.body);
        final couponErrors = data['errors']?['coupon'];
        if (couponErrors != null && couponErrors.isNotEmpty) {
          couponCode.value = null;
          Get.snackbar(
            'كود الخصم',
            _mapCouponError(couponErrors.first),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.shade50,
            colorText: Colors.red.shade800,
          );
          return;
        }
      }
      error.value = 'فشل معاينة الطلب';
    } catch (e) {
      error.value = 'خطأ في الاتصال';
    } finally {
      isLoading.value = false;
    }
  }

  void applyCoupon(String code, int addressId) {
    couponCode.value = code.trim();
    loadCheckout(addressId);
  }

  void removeCoupon(int addressId) {
    couponCode.value = null;
    loadCheckout(addressId);
  }

  String _mapCouponError(String code) {
    switch (code) {
      case 'coupon_expired':
        return 'انتهت صلاحية كود الخصم';
      case 'invalid_coupon':
        return 'كود الخصم غير صحيح';
      case 'coupon_usage_limit_reached':
        return 'تم استخدام هذا الكود من قبل';
      default:
        return 'كود الخصم غير صالح';
    }
  }
}
