import 'package:app/helpers/helpers.dart';
import 'package:app/models/product.dart';
import 'package:app/widgets/product/price_widget.dart';
import 'package:app/widgets/product/variant_cart_button.dart';
import 'package:app/widgets/server_image.dart';
import 'package:flutter/material.dart';

class VariantSelectorSheet extends StatelessWidget {
  final Product product;
  final Function(ProductVariant) onVariantSelected;

  const VariantSelectorSheet({
    super.key,
    required this.product,
    required this.onVariantSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final v = product.variants ?? [];

    return Container(
      padding: const EdgeInsets.only(top: 16, bottom: 32),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 12),

          Text(
            "اختر النوع",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 8),
          Text(
            product.name,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),

          Divider(thickness: 0.5, height: 32, color: Colors.grey.shade300),

          Flexible(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: v.map((v) {
                  return InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      onVariantSelected(v);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: ServerImage(
                              url: Helpers.getServerImage(v.image ?? ''),
                              width: 55,
                              height: 55,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${v.measurement ?? ''} ${v.unit?.symbol ?? ''}",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                PriceWidget(variant: v),
                                if (v.product?.status == 'out_of_stock')
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      "غير متوفر حالياً",
                                      style: TextStyle(
                                        color: Colors.red.shade600,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          VariantCartButton(variant: v, parentProduct: product),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
