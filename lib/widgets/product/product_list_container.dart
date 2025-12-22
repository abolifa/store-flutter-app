import 'package:app/models/product.dart';
import 'package:app/widgets/product/favorite_button.dart';
import 'package:app/widgets/product/perks_widget.dart';
import 'package:app/widgets/product/price_widget.dart';
import 'package:app/widgets/product/product_cart_button.dart';
import 'package:app/widgets/product/product_image.dart';
import 'package:flutter/material.dart';

class ProductListContainer extends StatelessWidget {
  final Product product;
  const ProductListContainer({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0.0),
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.2),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductImage(
            product: product,
            height: 160,
            width: 160,
            showCartButton: false,
            showFavoriteButton: false,
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 5.0,
                horizontal: 3.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade800,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      const SizedBox(width: 12),
                      FavoriteButton(productId: product.id),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  PriceWidget(product: product),
                  const SizedBox(height: 8.0),
                  PerksWidget(perks: product.perks),
                  if (product.status != 'out_of_stock')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [ProductCartButton(product: product)],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
