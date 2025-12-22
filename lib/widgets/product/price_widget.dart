import 'package:app/helpers/helpers.dart';
import 'package:app/models/product.dart';
import 'package:flutter/material.dart';

class PriceWidget extends StatelessWidget {
  final Product? product;
  final ProductVariant? variant;
  final double? fontSize1;
  final double? fontSize2;
  final double? fontSize3;

  const PriceWidget({
    super.key,
    this.product,
    this.variant,
    this.fontSize1,
    this.fontSize2,
    this.fontSize3,
  });

  @override
  Widget build(BuildContext context) {
    final ProductVariant? activeVariant =
        variant ??
        (product?.variants != null && product!.variants!.isNotEmpty
            ? product!.variants!.first
            : null);

    if (activeVariant == null) return const SizedBox.shrink();

    final double price = activeVariant.price;
    final double discount = (activeVariant.discount ?? 0).clamp(
      0,
      double.infinity,
    );

    final bool hasDiscount = discount > 0 && price > 0 && discount < price;

    final double discountedPrice = hasDiscount ? (price - discount) : price;

    final int discountPercentage = hasDiscount
        ? ((discount / price) * 100).round().clamp(1, 100)
        : 0;

    final formattedPrice = Helpers.formatPriceFixed(discountedPrice);
    final parts = formattedPrice.split('.');

    return SizedBox(
      height: 30,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        spacing: 4,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: parts[0],
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: fontSize1 ?? 16,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: '.${parts.length > 1 ? parts[1] : '00'}',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: fontSize2 ?? 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 3.0),
            child: Text(
              'د.ل',
              style: TextStyle(
                fontSize: fontSize2 ?? 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          if (hasDiscount)
            Text(
              price.toStringAsFixed(0),
              style: TextStyle(
                fontSize: fontSize2 ?? 13,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade400,
                decoration: TextDecoration.lineThrough,
                decorationThickness: 0.5,
              ),
            ),
          if (hasDiscount)
            Text(
              "$discountPercentage%",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: fontSize2 ?? 13,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
        ],
      ),
    );
  }
}
