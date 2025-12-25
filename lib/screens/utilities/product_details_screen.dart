import 'package:app/controllers/product_details_controller.dart';
import 'package:app/helpers/helpers.dart';
import 'package:app/screens/home/widgets/home_product_container.dart';
import 'package:app/widgets/product/expandable_html.dart';
import 'package:app/widgets/product/perks_widget.dart';
import 'package:app/widgets/product/price_widget.dart';
import 'package:app/widgets/product/product_image_gallery.dart';
import 'package:app/widgets/product/product_normal_cart_button.dart';
import 'package:app/widgets/product_rating_section.dart';
import 'package:app/widgets/product_seller_widget.dart';
import 'package:app/widgets/search_bar_global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailsScreen extends StatelessWidget {
  final int productId;
  const ProductDetailsScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final ProductDetailsController ctrl = Get.put(
      ProductDetailsController(productId),
    );

    return Scaffold(
      appBar: SearchBarGlobal(showBackButton: true),
      body: Obx(() {
        if (ctrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (ctrl.error.value != null) {
          return Center(
            child: Text(
              ctrl.error.value!,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final product = ctrl.product.value;
        if (product == null) {
          return const Center(child: Text('المنتج غير موجود'));
        }
        return RefreshIndicator(
          onRefresh: () async => ctrl.refreshAll(),
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    if (product.brand != null)
                      Text(
                        product.brand!.name,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                    ProductImageGallery(
                      product: product,
                      mainImage: product.image ?? '',
                      images: product.images ?? [],
                    ),
                    const SizedBox(height: 5),
                    PriceWidget(
                      product: product,
                      fontSize1: 20,
                      fontSize2: 18,
                      bottomSpacing: 4,
                    ),
                    PerksWidget(perks: product.perks ?? [], fontSize: 15),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              if (Helpers.hasMeaningfulHtml(product.description))
                ExpandableHtml(html: product.description ?? ''),
              const SizedBox(height: 12),
              if (product.storeId != null)
                ProductSellerWidget(store: product.store!),
              if (product.storeId != null) const SizedBox(height: 12),
              ProductRatingSection(product: product),
              const SizedBox(height: 12),
              Obx(() {
                if (ctrl.isRelatedLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (ctrl.relatedProducts.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'لا توجد منتجات مشابهة',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  );
                }
                return Container(
                  width: double.infinity,
                  height: 400,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'منتجات مشابهة',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade900,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: ctrl.relatedProducts.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final p = ctrl.relatedProducts[index];
                            return SizedBox(
                              width: 180,
                              child: HomeProductContainer(product: p),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 50),
            ],
          ),
        );
      }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 5),
        child: Obx(() {
          final product = ctrl.product.value;
          if (product == null) {
            return const SizedBox.shrink();
          }
          return ProductNormalCartButton(product: product);
        }),
      ),
    );
  }
}
