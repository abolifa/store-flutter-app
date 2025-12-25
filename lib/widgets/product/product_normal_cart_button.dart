import 'package:app/controllers/auth_controller.dart';
import 'package:app/controllers/cart_controller.dart';
import 'package:app/models/product.dart';
import 'package:app/router.dart';
import 'package:app/widgets/product/variant_selector_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ProductNormalCartButton extends StatelessWidget {
  final Product product;
  const ProductNormalCartButton({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final CartController cart = Get.find<CartController>();
    final AuthController auth = Get.find<AuthController>();

    final variants = product.variants ?? [];
    final bool hasVariants = variants.length > 1;
    final bool isOutOfStock =
        product.status.toLowerCase() == 'out_of_stock' ||
        product.status == 'out';

    return Obx(() {
      final totalInCart = variants.fold<int>(
        0,
        (sum, v) => sum + cart.quantityOf(v.id),
      );

      return SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: isOutOfStock
              ? null
              : () async {
                  if (!auth.isAuthenticated.value) {
                    Get.toNamed(Routes.login);
                    return;
                  }

                  if (hasVariants) {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => VariantSelectorSheet(
                        product: product,
                        onVariantSelected: (variant) async {
                          await cart.toggleVariant(
                            variant,
                            parentProduct: product,
                          );
                        },
                      ),
                    );
                    return;
                  }

                  if (variants.isEmpty) return;

                  await cart.toggleVariant(
                    variants.first,
                    parentProduct: product,
                  );
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: totalInCart > 0
                ? Colors.white
                : Colors.grey.shade800,
            foregroundColor: totalInCart > 0
                ? Colors.grey.shade800
                : Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: hasVariants
              ? totalInCart == 0
                    ? const Text(
                        'إختر النوع',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : Text(
                        'في السلة: $totalInCart',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      )
              : totalInCart == 0
              ? const Text(
                  'إضافة إلى السلة',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _iconBtn(
                      icon: LucideIcons.minus,
                      onTap: () async {
                        HapticFeedback.lightImpact();
                        await cart.decreaseVariant(variants.first.id);
                      },
                    ),
                    Text(
                      '$totalInCart',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _iconBtn(
                      icon: LucideIcons.plus,
                      onTap: () async {
                        HapticFeedback.lightImpact();
                        await cart.increaseVariant(variants.first.id);
                      },
                    ),
                  ],
                ),
        ),
      );
    });
  }

  Widget _iconBtn({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.shade300,
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }
}
