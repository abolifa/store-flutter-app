import 'package:app/controllers/cart_controller.dart';
import 'package:app/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class VariantCartButton extends StatelessWidget {
  final ProductVariant variant;
  final Product? parentProduct;
  final double? width;
  const VariantCartButton({
    super.key,
    required this.variant,
    this.parentProduct,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final CartController cart = Get.find<CartController>();

    return Obx(() {
      final inCart = cart.hasVariant(variant.id);
      final qty = cart.quantityOf(variant.id);

      return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 35,
        width: width ?? 150,
        padding: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(0),
        ),
        child: inCart
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _iconButton("-", () async {
                    HapticFeedback.mediumImpact();
                    await cart.decreaseVariant(variant.id);
                  }),
                  Text(
                    '$qty',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  _iconButton("+", () async {
                    HapticFeedback.mediumImpact();
                    await cart.increaseVariant(variant.id);
                  }),
                ],
              )
            : InkWell(
                onTap: () async {
                  HapticFeedback.mediumImpact();
                  await cart.toggleVariant(
                    variant,
                    parentProduct: parentProduct,
                  );
                },
                child: Center(
                  child: Row(
                    spacing: 5,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.shoppingCart,
                        size: 18,
                        color: Colors.grey.shade700,
                      ),
                      Text(
                        "أضف للسلة",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      );
    });
  }

  Widget _iconButton(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: Colors.grey.shade200),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
