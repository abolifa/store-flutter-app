import 'package:app/controllers/offer_products_controller.dart';
import 'package:app/models/session.dart';
import 'package:app/screens/home/widgets/home_product_container.dart';
import 'package:app/widgets/custom_app_bar.dart';
import 'package:app/widgets/product/product_list_container.dart';
import 'package:app/widgets/product_fiter_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OfferProductsScreen extends StatelessWidget {
  final int offerId;
  final String? offerTitle;
  const OfferProductsScreen({
    super.key,
    required this.offerId,
    this.offerTitle,
  });

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(OfferProductsController(offerId: offerId));

    return Scaffold(
      appBar: CustomAppBar(title: offerTitle ?? 'عروض المنتجات'),
      body: Column(
        children: [
          Obx(
            () => ProductFilterBar(
              onSearchChanged: ctrl.setSearch,
              onSortSelected: ctrl.setSort,
              onPriceRangeSelected: ctrl.setPriceRange,
              onBrandSelected: ctrl.setBrand,
              onClearAll: ctrl.clearAllFilters,
              brands: ctrl.availableBrands,
              selectedBrand: ctrl.selectedBrandId.value,
            ),
          ),
          Expanded(
            child: Obx(() {
              final pagination = ctrl.pagination;
              if (pagination.isLoading.value && pagination.items.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (pagination.error.value != null) {
                return Center(child: Text(pagination.error.value!));
              }
              if (pagination.items.isEmpty) {
                return const Center(child: Text('لا توجد منتجات في هذا العرض'));
              }

              final viewType = Session.get<String>(SessionKey.productViewType);
              final isGrid = viewType != ProductViewType.list.name;

              return RefreshIndicator(
                onRefresh: pagination.refreshPage,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scroll) {
                    if (scroll.metrics.pixels >=
                        scroll.metrics.maxScrollExtent - 200) {
                      ctrl.loadMore();
                    }
                    return false;
                  },
                  child: isGrid
                      ? GridView.builder(
                          padding: const EdgeInsets.all(6),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 6,
                                crossAxisSpacing: 6,
                                childAspectRatio: 0.55,
                              ),
                          itemCount: pagination.items.length,
                          itemBuilder: (_, i) {
                            return HomeProductContainer(
                              product: pagination.items[i],
                            );
                          },
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(6),
                          itemCount: pagination.items.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 6),
                          itemBuilder: (_, i) {
                            return ProductListContainer(
                              product: pagination.items[i],
                            );
                          },
                        ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
