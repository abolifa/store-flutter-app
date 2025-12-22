import 'package:app/controllers/category_product_controller.dart';
import 'package:app/models/session.dart';
import 'package:app/screens/home/widgets/home_product_container.dart';
import 'package:app/widgets/custom_app_bar.dart';
import 'package:app/widgets/empty_screen.dart';
import 'package:app/widgets/product/product_list_container.dart';
import 'package:app/widgets/product_fiter_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class CategoryProductScreen extends StatefulWidget {
  final int categoryId;
  final String? categoryName;
  const CategoryProductScreen({
    super.key,
    required this.categoryId,
    this.categoryName,
  });

  @override
  State<CategoryProductScreen> createState() => _CategoryProductScreenState();
}

class _CategoryProductScreenState extends State<CategoryProductScreen> {
  late final CategoryProductsController controller;
  final ScrollController _gridController = ScrollController();
  final ScrollController _listController = ScrollController();

  void _attach(ScrollController c) {
    c.addListener(() {
      if (!c.hasClients) return;
      if (c.position.pixels >= c.position.maxScrollExtent - 200) {
        controller.loadMore();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      CategoryProductsController(categoryId: widget.categoryId),
    );
    _attach(_gridController);
    _attach(_listController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.categoryName ?? 'المنتجات'),
      body: Column(
        children: [
          Obx(
            () => ProductFilterBar(
              onSearchChanged: controller.setSearch,
              onSortSelected: controller.setSort,
              debounceMilliseconds: 1000,
              brands: controller.availableBrands,
              selectedBrand: controller.selectedBrandId.value,
              onBrandSelected: controller.setBrand,
              onPriceRangeSelected: controller.setPriceRange,
            ),
          ),
          Expanded(
            child: Obx(() {
              final c = controller.pagination;
              if (c.isLoading.value && c.items.isEmpty) {
                final viewType = Session.get<String>(
                  SessionKey.productViewType,
                );
                final isGrid = viewType != ProductViewType.list.name;
                return isGrid ? _buildShimmerGrid() : _buildShimmerList();
              }

              if (c.error.value != null) {
                return Center(child: Text('خطأ: ${c.error.value}'));
              }
              if (c.items.isEmpty) {
                return EmptyScreen(
                  title: 'لم يتم العثور على منتجات',
                  subtitle: 'لا توجد منتجات في هذا القسم حالياً.',
                  imagePath: 'assets/images/no-products.png',
                  height: 0.5,
                );
              }

              final viewType = Session.get<String>(SessionKey.productViewType);
              final isGrid = viewType != ProductViewType.list.name;
              return RefreshIndicator(
                onRefresh: controller.refreshPage,
                child: isGrid
                    ? GridView.builder(
                        controller: _gridController,
                        padding: const EdgeInsets.all(5),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 5,
                              childAspectRatio: 0.60,
                            ),
                        itemCount:
                            c.items.length + (c.isMoreLoading.value ? 2 : 0),
                        itemBuilder: (context, index) {
                          if (index >= c.items.length) {
                            return _buildShimmerCard(height: 165);
                          }
                          final product = c.items[index];
                          return HomeProductContainer(product: product);
                        },
                      )
                    : ListView.separated(
                        controller: _listController,
                        padding: const EdgeInsets.all(5),
                        separatorBuilder: (_, __) => const SizedBox(height: 5),
                        itemCount:
                            c.items.length + (c.isMoreLoading.value ? 2 : 0),
                        itemBuilder: (context, index) {
                          if (index >= c.items.length) {
                            return _buildShimmerCard();
                          }
                          final product = c.items[index];
                          return ProductListContainer(product: product);
                        },
                      ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        childAspectRatio: 0.58,
      ),
      itemBuilder: (_, __) => _buildShimmerCard(),
    );
  }

  Widget _buildShimmerList() {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      separatorBuilder: (_, __) => const SizedBox(height: 5),
      itemCount: 6,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey.withValues(alpha: 0.2),
        highlightColor: Colors.grey.withValues(alpha: 0.05),
        child: Container(
          height: 165,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerCard({double? height}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withValues(alpha: 0.2),
      highlightColor: Colors.grey.withValues(alpha: 0.05),
      child: Container(
        height: height,
        decoration: BoxDecoration(color: Colors.white),
      ),
    );
  }
}
