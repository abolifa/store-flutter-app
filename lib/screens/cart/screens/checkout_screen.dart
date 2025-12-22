import 'package:app/controllers/cart_controller.dart';
import 'package:app/controllers/checkout_controller.dart';
import 'package:app/controllers/order_controller.dart';
import 'package:app/controllers/payment_methods_controller.dart';
import 'package:app/controllers/wallet_controller.dart';
import 'package:app/models/address.dart';
import 'package:app/models/checkout.dart';
import 'package:app/models/payment_method.dart';
import 'package:app/router.dart';
import 'package:app/widgets/checkout_shimmer.dart';
import 'package:app/widgets/custom_app_bar.dart';
import 'package:app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CheckoutScreen extends StatefulWidget {
  final Address selectedAddress;
  const CheckoutScreen({super.key, required this.selectedAddress});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final CheckoutController checkoutCtrl = Get.find<CheckoutController>();
  final PaymentMethodsController paymentCtrl = Get.put(
    PaymentMethodsController(),
    permanent: false,
  );
  final CartController cartCtrl = Get.find<CartController>();
  PaymentMethod? _selectedPayment;
  final OrderController orderCtrl = Get.put(
    OrderController(),
    permanent: false,
  );

  late final TextEditingController _couponCtrl;
  late final FocusNode _couponFocus;

  @override
  void initState() {
    super.initState();
    _couponCtrl = TextEditingController();
    _couponFocus = FocusNode();

    checkoutCtrl.loadCheckout(widget.selectedAddress.id);
    paymentCtrl.fetchPaymentMethods();
  }

  @override
  void dispose() {
    _couponCtrl.dispose();
    _couponFocus.dispose();
    super.dispose();
  }

  bool get _hasUndeliverable {
    final checkout = checkoutCtrl.checkout.value;
    if (checkout == null) return false;
    return checkout.hasUndeliverableStores;
  }

  bool get _hasPayment {
    return _selectedPayment != null;
  }

  String get _confirmButtonText {
    if (_hasUndeliverable) {
      return 'منتجات خارج نطاق التوصيل';
    }
    if (!_hasPayment) {
      return 'اختر طريقة الدفع';
    }
    return 'تأكيد الطلب';
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).size.width < 360 ? 10.0 : 12.0;

    return Scaffold(
      appBar: const CustomAppBar(title: 'إنهاء الطلب'),
      body: Obx(() {
        if (checkoutCtrl.isLoading.value || paymentCtrl.isLoading.value) {
          return const CheckoutShimmer();
        }
        if (checkoutCtrl.error.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                checkoutCtrl.error.value,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final checkout = checkoutCtrl.checkout.value;
        if (checkout == null) {
          return const Center(child: Text('لم يتم تحميل الطلب'));
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(padding),
          physics: const BouncingScrollPhysics(),
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildAddressSection(),
              _buildCouponSection(),
              if (checkout.hasUndeliverableStores) ...[
                _buildUndeliverableSection(checkout.stores),
              ],
              _buildPaymentMethods(),
              _buildSummary(checkout.summary),
            ],
          ),
        );
      }),
      bottomSheet: Obx(() {
        return Padding(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: 10 + MediaQuery.of(context).padding.bottom,
          ),
          child: CustomButton(
            text: _confirmButtonText,
            height: 50,
            isDisabled: !_hasPayment || _hasUndeliverable,
            onPressed: () {
              Get.toNamed(
                Routes.orderPlace,
                arguments: {
                  'addressId': widget.selectedAddress.id,
                  'paymentMethodId': _selectedPayment!.id,
                  'couponCode': checkoutCtrl.couponCode.value,
                },
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildCouponSection() {
    return Obx(() {
      final applied = checkoutCtrl.couponCode.value != null;
      final isLoading = checkoutCtrl.isLoading.value;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _couponCtrl,
                focusNode: _couponFocus,
                enabled: !applied && !isLoading,
                textInputAction: TextInputAction.done,
                onSubmitted: (value) {
                  if (value.trim().isEmpty) return;
                  checkoutCtrl.applyCoupon(
                    value.trim(),
                    widget.selectedAddress.id,
                  );
                  _couponFocus.unfocus();
                },
                style: const TextStyle(fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'أدخل كود الخصم',
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: isLoading
                  ? null
                  : () {
                      if (applied) {
                        checkoutCtrl.removeCoupon(widget.selectedAddress.id);
                        _couponCtrl.clear();
                      } else {
                        if (_couponCtrl.text.trim().isEmpty) return;
                        checkoutCtrl.applyCoupon(
                          _couponCtrl.text.trim(),
                          widget.selectedAddress.id,
                        );
                        _couponFocus.unfocus();
                      }
                    },
              child: Text(
                applied ? 'إزالة' : 'تطبيق',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: applied ? Colors.red : Colors.green,
                ),
              ),
            ),
            const SizedBox(width: 4),
          ],
        ),
      );
    });
  }

  Widget _buildAddressSection() {
    final address = widget.selectedAddress;
    return _section(
      title: 'عنوان التوصيل',
      child: _sectionCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                "${address.landmark} ${address.street}, ${address.city}",
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const SizedBox(width: 10),
            CustomButton(
              text: 'تغيير',
              height: 30,
              width: 65,
              textStyle: TextStyle(fontSize: 12),
              backgroundColor: Colors.grey.shade200,
              foregroundColor: Colors.grey.shade700,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUndeliverableSection(List<CheckoutStore> stores) {
    final badStores = stores.where((s) => !s.isDeliverable).toList();
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'منتجات خارج نطاق التوصيل',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: badStores.length,
            separatorBuilder: (_, __) => const SizedBox(height: 6),
            itemBuilder: (context, storeIndex) {
              final store = badStores[storeIndex];
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: store.undeliverableProducts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 4),
                itemBuilder: (context, productIndex) {
                  final p = store.undeliverableProducts[productIndex];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      '• ${p.productName} (${p.quantity}x)',
                      style: const TextStyle(fontSize: 13),
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 10),
          const Text(
            'يرجى إزالة هذه المنتجات أو تغيير عنوان التوصيل',
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethods() {
    final walletCtrl = Get.find<WalletController>();
    return _section(
      title: 'طريقة الدفع',
      child: _sectionCard(
        child: Obx(() {
          final methods = paymentCtrl.paymentMethods;
          if (methods.isEmpty) {
            return const Center(child: Text('لا توجد طرق دفع متاحة'));
          }
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: methods.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final m = methods[index];
              final isSelected = _selectedPayment?.id == m.id;
              return InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  setState(() {
                    _selectedPayment = m;
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? Colors.black : Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Stack(
                    children: [
                      if (isSelected)
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 20,
                          ),
                        ),
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_paymentIcon(m.code ?? ''), size: 18),
                            const SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                '${m.name} ${m.code == 'wallet' ? '- ${walletCtrl.balance.value.toStringAsFixed(2)} د.ل' : ''}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Widget _buildSummary(CheckoutSummary summary) {
    return _section(
      title: 'ملخص الطلب',
      child: _sectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Obx(() {
              final items = cartCtrl.items.values.toList();
              if (items.isEmpty) {
                return const Center(child: Text('السلة فارغة'));
              }
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 6),
                itemBuilder: (context, index) {
                  final item = items[index];
                  final variant = item.variant;
                  final product = variant.product;
                  final lineTotal = variant.price * item.quantity;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                product?.name ?? '',
                                style: const TextStyle(fontSize: 13),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${item.quantity}x',
                              style: const TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${lineTotal.toStringAsFixed(2)} د.ل',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  );
                },
              );
            }),
            const SizedBox(height: 8),
            const Divider(height: 1),
            const SizedBox(height: 8),
            _summaryRow('المجموع', summary.subtotal),
            _summaryRow('الخصم', summary.discount),
            _summaryRow('الضريبة', summary.tax),
            _summaryRow('رسوم التوصيل', summary.delivery),
            const Divider(height: 16),
            _summaryRow('الإجمالي', summary.total, isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _section({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _sectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  IconData _paymentIcon(String code) {
    switch (code) {
      case 'credit_card':
        return LucideIcons.creditCard300;
      case 'paypal':
        return LucideIcons.wallet300;
      case 'cash':
      case 'cod':
        return LucideIcons.receipt300;
      case 'apple_pay':
        return LucideIcons.smartphone300;
      case 'wallet':
        return LucideIcons.wallet300;
      default:
        return Icons.payment;
    }
  }

  Widget _summaryRow(String label, double value, {bool isTotal = false}) {
    final style = TextStyle(
      fontSize: isTotal ? 16 : 14,
      fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style, maxLines: 1)),
          const SizedBox(width: 10),
          Text('${value.toStringAsFixed(2)} د.ل', style: style),
        ],
      ),
    );
  }
}
