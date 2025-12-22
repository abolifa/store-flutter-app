import 'dart:convert';

import 'package:app/models/payment_method.dart';
import 'package:app/services/api_service.dart';
import 'package:get/get.dart';

class PaymentMethodsController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<PaymentMethod> paymentMethods = <PaymentMethod>[].obs;
  final RxString error = ''.obs;

  Future<void> fetchPaymentMethods() async {
    try {
      isLoading.value = true;
      error.value = '';

      final res = await ApiService.get('/payment-methods');

      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        paymentMethods.assignAll(data.map((e) => PaymentMethod.fromJson(e)));
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
