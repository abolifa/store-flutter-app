import 'package:app/controllers/address_controller.dart';
import 'package:app/controllers/cart_controller.dart';
import 'package:app/helpers/helpers.dart';
import 'package:app/router.dart';
import 'package:app/widgets/address_selector.dart';
import 'package:app/widgets/empty_screen.dart';
import 'package:app/widgets/product/favorite_button.dart';
import 'package:app/widgets/product/price_widget.dart';
import 'package:app/widgets/product/variant_cart_button.dart';
import 'package:app/widgets/server_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final cart = Get.find<CartController>();
  final address = Get.find<AddressController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'سلة المشتريات',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: Obx(() {
        if (cart.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (cart.items.isEmpty) {
          return const EmptyScreen(
            title: 'سلة المشتريات فارغة',
            subtitle: 'لم تقم بإضافة أي أصناف إلى سلة المشتريات بعد',
            imagePath: 'assets/images/no-products.png',
          );
        }

        return RefreshIndicator(
          onRefresh: cart.loadCart,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                AddressSelector(),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (_, __) => const SizedBox(height: 5),
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items.values.elementAt(index);
                      final variant = item.variant;
                      final product = variant.product;

                      return Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              child: Column(
                                children: [
                                  ServerImage(
                                    url: Helpers.getServerImage(
                                      variant.image ?? product?.image ?? "",
                                    ),
                                    height: 130,
                                    width: 130,
                                    fit: BoxFit.contain,
                                  ),
                                  const SizedBox(height: 8),
                                  VariantCartButton(
                                    variant: variant,
                                    width: 130,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          product?.name ?? "",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            height: 1.3,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      FavoriteButton(
                                        productId: product?.id ?? 0,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  PriceWidget(
                                    variant: variant,
                                    fontSize1: 16,
                                    fontSize2: 13,
                                  ),
                                  const SizedBox(height: 10),
                                  if ((product?.perks?.isNotEmpty ?? false))
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: product!.perks!.map((perk) {
                                          return Row(
                                            children: [
                                              const Icon(
                                                Icons.check_circle,
                                                size: 14,
                                                color: Colors.green,
                                              ),
                                              const SizedBox(width: 4),
                                              Flexible(
                                                child: Text(
                                                  perk.title ?? "",
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black54,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(
                      Routes.checkoutScreen,
                      arguments: {
                        'selectedAddress': address.selectedAddress.value,
                      },
                    );
                  },
                  child: Container(
                    height: 60,
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 6,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        const Center(
                          child: Text(
                            'إتمام الشراء',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 5,
                          top: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 2,
                            children: [
                              Text(
                                '${cart.totalCount} صنف',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '${cart.subtotal} د.ل',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Positioned(
                          left: 5,
                          top: 9,
                          child: BouncingArrow(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class BouncingArrow extends StatefulWidget {
  const BouncingArrow({super.key});

  @override
  State<BouncingArrow> createState() => _BouncingArrowState();
}

class _BouncingArrowState extends State<BouncingArrow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _tilt;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _tilt = Tween<double>(
      begin: -0.03,
      end: 0.03,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _tilt,
      builder: (context, child) {
        return Transform.rotate(angle: _tilt.value, child: child);
      },
      child: Container(
        width: 35,
        height: 35,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(Icons.arrow_forward, size: 20, color: Colors.black87),
      ),
    );
  }
}
