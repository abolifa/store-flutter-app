import 'package:app/controllers/cart_controller.dart';
import 'package:app/controllers/checkout_controller.dart';
import 'package:app/controllers/order_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

enum OrderPlaceUiState { placing, success }

class OrderPlaceScreen extends StatefulWidget {
  final int addressId;
  final int paymentMethodId;
  final String? couponCode;
  const OrderPlaceScreen({
    super.key,
    required this.addressId,
    required this.paymentMethodId,
    this.couponCode,
  });

  @override
  State<OrderPlaceScreen> createState() => _OrderPlaceScreenState();
}

class _OrderPlaceScreenState extends State<OrderPlaceScreen> {
  final OrderController orderCtrl = Get.find<OrderController>();
  final CheckoutController checkoutCtrl = Get.find<CheckoutController>();
  final CartController cartCtrl = Get.find<CartController>();

  @override
  void initState() {
    super.initState();
    _placeOrder();
  }

  OrderPlaceUiState _uiState = OrderPlaceUiState.placing;
  Future<void> _placeOrder() async {
    final success = await orderCtrl.placeOrder(
      addressId: widget.addressId,
      paymentMethodId: widget.paymentMethodId,
      couponCode: widget.couponCode,
    );

    if (!mounted) return;

    if (success) {
      cartCtrl.clearCart();
      setState(() {
        _uiState = OrderPlaceUiState.success;
      });
      return;
    }

    if (orderCtrl.state.value == PlaceOrderState.checkoutChanged) {
      Get.back();
      checkoutCtrl.loadCheckout(widget.addressId);
      Get.snackbar(
        'تغيرت تفاصيل الطلب',
        'يرجى مراجعة الطلب قبل المتابعة',
        backgroundColor: Colors.orange.shade100,
      );
      return;
    }

    Get.back();
    Get.snackbar(
      'فشل تأكيد الطلب',
      orderCtrl.errorMessage.value ?? 'حدث خطأ غير متوقع',
      backgroundColor: Colors.red.shade100,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _uiState == OrderPlaceUiState.success,
      child: Scaffold(
        body: Center(
          child: _uiState == OrderPlaceUiState.placing
              ? _placingView()
              : _successView(),
        ),
      ),
    );
  }

  Widget _placingView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CupertinoActivityIndicator(),
        const SizedBox(height: 10),
        const Text(
          'جاري تأكيد الطلب...',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _successView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Lottie.asset(
          'assets/animations/order_success.json',
          width: 150,
          height: 150,
          fit: BoxFit.cover,
          repeat: false,
        ),
        const SizedBox(height: 16),
        const Text(
          'تم تأكيد الطلب بنجاح!',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            Get.offAllNamed('/orders');
          },
          child: const Text('عرض الطلبات'),
        ),
      ],
    );
  }
}
