import 'package:app/controllers/global_seach_controller.dart';
import 'package:app/models/session.dart';
import 'package:app/screens/home/widgets/home_product_container.dart';
import 'package:app/widgets/product/product_list_container.dart';
import 'package:app/widgets/product_fiter_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchProductsScreen extends StatelessWidget {
  const SearchProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(GlobalSearchController());

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ProductFilterBar(
              hintText: 'ابحث عن المنتجات...',
              backButton: true,
              brands: ctrl.availableBrands,
              selectedBrand: ctrl.selectedBrandId.value,
              onSearchChanged: ctrl.setSearch,
              onBrandSelected: ctrl.setBrand,
              onPriceRangeSelected: ctrl.setPriceRange,
              onSortSelected: (sort) {
                if (sort.startsWith('view:')) {
                  final view = sort.split(':')[1];
                  ctrl.viewType.value = view;
                  Session.set(SessionKey.productViewType, view);
                } else {
                  ctrl.setSort(sort);
                }
              },
              onClearAll: ctrl.clearAllFilters,
            ),
            Expanded(
              child: Obx(() {
                if (ctrl.pagination.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (ctrl.pagination.error.value != null) {
                  return Center(child: Text(ctrl.pagination.error.value!));
                }

                final products = ctrl.pagination.items;
                if (products.isEmpty) {
                  return const Center(child: Text('لا توجد نتائج'));
                }

                final isGrid = ctrl.viewType.value == 'grid';

                return NotificationListener<ScrollNotification>(
                  onNotification: (scroll) {
                    if (scroll.metrics.pixels >=
                        scroll.metrics.maxScrollExtent - 200) {
                      ctrl.loadMore();
                    }
                    return false;
                  },
                  child: isGrid
                      ? GridView.builder(
                          padding: const EdgeInsets.all(5),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5,
                                childAspectRatio: 0.54,
                              ),
                          itemCount: products.length,
                          itemBuilder: (context, i) {
                            final product = products[i];
                            return HomeProductContainer(product: product);
                          },
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(5),
                          itemCount: products.length,
                          separatorBuilder: (context, i) =>
                              const SizedBox(height: 5),
                          itemBuilder: (context, i) {
                            final product = products[i];
                            return ProductListContainer(product: product);
                          },
                        ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
