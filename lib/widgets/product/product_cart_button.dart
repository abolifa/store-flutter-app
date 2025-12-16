import 'package:app/controllers/auth_controller.dart';
import 'package:app/controllers/cart_controller.dart';
import 'package:app/models/product.dart';
import 'package:app/router.dart';
import 'package:app/widgets/product/variant_selector_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ProductCartButton extends StatefulWidget {
  final Product product;
  const ProductCartButton({super.key, required this.product});

  @override
  State<ProductCartButton> createState() => _ProductCartButtonState();
}

class _ProductCartButtonState extends State<ProductCartButton>
    with SingleTickerProviderStateMixin {
  final CartController cart = Get.find<CartController>();
  final AuthController auth = Get.find<AuthController>();
  bool expanded = false;
  bool showControllers = false;

  @override
  Widget build(BuildContext context) {
    final variants = widget.product.variants ?? [];
    final bool hasVariants = variants.length > 1;
    final bool isOutOfStock =
        widget.product.status.toLowerCase() == 'out_of_stock' ||
        widget.product.status == 'out';

    return Opacity(
      opacity: isOutOfStock ? 0.5 : 1,
      child: IgnorePointer(
        ignoring: isOutOfStock,
        child: Obx(() {
          final totalInCart = variants.fold<int>(
            0,
            (sum, v) => sum + cart.quantityOf(v.id),
          );

          if (hasVariants) {
            final inCart = totalInCart > 0;
            return GestureDetector(
              onTap: () {
                if (!auth.isAuthenticated.value) {
                  Get.toNamed(Routes.login);
                  return;
                }
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => VariantSelectorSheet(
                    product: widget.product,
                    onVariantSelected: (variant) async {
                      await cart.toggleVariant(
                        variant,
                        parentProduct: widget.product,
                      );
                    },
                  ),
                );
              },
              child: Container(
                height: 42,
                width: 45,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: inCart ? Colors.blue.shade400 : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: inCart
                    ? Text(
                        '$totalInCart+',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      )
                    : Icon(
                        Icons.add_shopping_cart,
                        color: Colors.grey.shade600,
                        size: 18,
                      ),
              ),
            );
          }

          // ✅ Normal single variant logic
          final isInCart = totalInCart > 0;
          if (isInCart && !expanded) {
            expanded = true;
            _delayedShowControllers();
          } else if (!isInCart && expanded) {
            expanded = false;
            showControllers = false;
          }

          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutBack,
            height: 40,
            width: expanded ? 110 : 45,
            decoration: BoxDecoration(
              color: expanded ? Colors.blue : Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutBack,
              child: showControllers
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _circleButton(
                            icon: LucideIcons.trash2,
                            onTap: () async {
                              HapticFeedback.mediumImpact();
                              if (variants.isEmpty) return;
                              await cart.decreaseVariant(variants.first.id);
                            },
                            color: Colors.white,
                          ),
                          Flexible(
                            child: Center(
                              child: Text(
                                '$totalInCart',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          _circleButton(
                            icon: Icons.add,
                            onTap: () async {
                              HapticFeedback.mediumImpact();
                              if (variants.isEmpty) return;
                              await cart.increaseVariant(variants.first.id);
                            },
                            color: Colors.white,
                          ),
                        ],
                      ),
                    )
                  : IconButton(
                      icon: Icon(
                        Icons.add_shopping_cart,
                        color: expanded
                            ? Colors.transparent
                            : Colors.grey.shade600,
                        size: 18,
                      ),
                      onPressed: () async {
                        HapticFeedback.mediumImpact();
                        if (!auth.isAuthenticated.value) {
                          Get.toNamed(Routes.login);
                          return;
                        }
                        if (variants.isNotEmpty) {
                          await cart.toggleVariant(
                            variants.first,
                            parentProduct: widget.product,
                          );
                        }
                        setState(() => expanded = true);
                        _delayedShowControllers();
                      },
                    ),
            ),
          );
        }),
      ),
    );
  }

  void _delayedShowControllers() {
    Future.delayed(const Duration(milliseconds: 180), () {
      if (mounted && expanded) {
        setState(() => showControllers = true);
      }
    });
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color?.withValues(alpha: 0.2),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}
