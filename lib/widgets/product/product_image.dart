import 'package:app/helpers/constants.dart';
import 'package:app/helpers/helpers.dart';
import 'package:app/models/product.dart';
import 'package:app/router.dart';
import 'package:app/widgets/product/favorite_button.dart';
import 'package:app/widgets/product/product_cart_button.dart';
import 'package:app/widgets/server_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductImage extends StatelessWidget {
  final Product product;
  final double? height;
  final double? width;
  final bool showFavoriteButton;
  final bool showCartButton;
  const ProductImage({
    super.key,
    required this.product,
    this.height,
    this.width,
    this.showFavoriteButton = true,
    this.showCartButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? 220,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(3.0),
      ),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => Get.toNamed(
              Routes.productDetails,
              arguments: {'productId': product.id},
            ),
            child: ServerImage(
              url: Helpers.getServerImage(product.image),
              width: double.infinity,
              height: double.infinity,
              padding: EdgeInsets.all(5),
              backgroundColor: Colors.white,
              fit: BoxFit.contain,
            ),
          ),
          if (showFavoriteButton)
            Positioned(
              top: 5,
              left: 5,
              child: FavoriteButton(productId: product.id),
            ),
          if (product.isFeatured)
            Positioned(
              top: 5,
              right: 5,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade700,
                  borderRadius: BorderRadius.circular(50.0),
                  boxShadow: [Constants.boxShadow],
                ),
                child: Text(
                  'مميز',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          if (product.approvedReviewsCount != null &&
              product.approvedReviewsCount! > 0)
            Positioned(
              bottom: 5,
              right: 5,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50.0),
                  boxShadow: [Constants.boxShadow],
                ),
                child: Row(
                  children: [
                    Icon(Icons.star, color: Colors.green.shade500, size: 14),
                    const SizedBox(width: 3),
                    Text(
                      '${product.approvedReviewsAvgRating} (${product.approvedReviewsCount})',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (product.status != 'out_of_stock' && showCartButton)
            Positioned(
              bottom: 5,
              left: 5,
              child: ProductCartButton(product: product),
            ),
          if (product.status == 'out_of_stock')
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(3.0),
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Text(
                      'غير متوفر',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
