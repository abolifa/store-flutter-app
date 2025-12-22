import 'package:app/controllers/product_controller.dart';
import 'package:app/screens/home/widgets/home_product_container.dart';
import 'package:app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductsByIdsScreen extends StatelessWidget {
  final List<int> productIds;
  final String? title;
  const ProductsByIdsScreen({super.key, required this.productIds, this.title});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(ProductController(), permanent: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ctrl.fetchProductsByIds(productIds);
    });

    return Scaffold(
      appBar: CustomAppBar(title: title ?? 'المنتجات', isBackButton: true),
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

        if (ctrl.products.isEmpty) {
          return const Center(child: Text('لا توجد منتجات مطابقة'));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(5),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            childAspectRatio: 0.60,
          ),
          itemCount: ctrl.products.length,
          itemBuilder: (context, index) {
            final product = ctrl.products[index];
            return HomeProductContainer(product: product);
          },
        );
      }),
    );
  }
}
