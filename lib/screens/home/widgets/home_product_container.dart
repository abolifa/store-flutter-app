import 'package:app/models/product.dart';
import 'package:app/widgets/product/perks_widget.dart';
import 'package:app/widgets/product/price_widget.dart';
import 'package:app/widgets/product/product_image.dart';
import 'package:flutter/material.dart';

class HomeProductContainer extends StatelessWidget {
  final Product product;
  const HomeProductContainer({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          ProductImage(product: product),
          const SizedBox(height: 5.0),
          SizedBox(
            height: 38.0,
            child: Text(
              product.name,
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade800,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          PriceWidget(product: product),
          const SizedBox(height: 5.0),
          PerksWidget(perks: product.perks),
        ],
      ),
    );
  }
}
