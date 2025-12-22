import 'package:app/controllers/category_controller.dart';
import 'package:app/helpers/helpers.dart';
import 'package:app/router.dart';
import 'package:app/widgets/search_bar_global.dart';
import 'package:app/widgets/server_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with TickerProviderStateMixin {
  final CategoryController controller = Get.put(CategoryController());
  final RxInt expandedIndex = (-1).obs;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        controller.loadMore();
      }
    });
  }

  void _onCategoryTap(int globalIndex, dynamic category) {
    final hasChildren =
        (category.children != null && category.children!.isNotEmpty);

    if (!hasChildren) {
      Get.toNamed(
        Routes.categoryProducts,
        arguments: {'categoryId': category.id, 'categoryName': category.name},
      );
      return;
    }

    expandedIndex.value = (expandedIndex.value == globalIndex)
        ? -1
        : globalIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SearchBarGlobal(),
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value && controller.items.isEmpty) {
          return const Center(child: CupertinoActivityIndicator());
        } else if (controller.error.value.isNotEmpty) {
          return Center(child: Text('Error: ${controller.error.value}'));
        } else if (controller.items.isEmpty) {
          // No categories available
          return SizedBox();
        }

        final List<Widget> listChildren = <Widget>[];
        for (int i = 0; i < controller.items.length; i += 3) {
          final items = controller.items.skip(i).take(3).toList();
          final rowChildren = List.generate(items.length, (j) {
            final globalIndex = i + j;
            final category = items[j];
            final bool isExpanded = expandedIndex.value == globalIndex;

            return Expanded(
              child: GestureDetector(
                onTap: () => _onCategoryTap(globalIndex, category),
                child: Container(
                  margin: const EdgeInsets.all(4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ServerImage(
                        url: Helpers.getServerImage(category.image ?? ""),
                        width: double.infinity,
                        fit: BoxFit.contain,
                        height: 170,
                        backgroundColor: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: isExpanded
                            ? Border.all(color: Colors.grey.shade400, width: 2)
                            : null,
                      ),
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          category.name,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });

          while (rowChildren.length < 3) {
            rowChildren.add(const Expanded(child: SizedBox.shrink()));
          }
          listChildren.add(
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: rowChildren,
            ),
          );
          listChildren.add(
            _RowExpansionSlot(
              key: ValueKey('row-expansion-$i'),
              vsync: this,
              isActive:
                  (expandedIndex.value >= i &&
                  expandedIndex.value < i + items.length),
              expandedCategory:
                  (expandedIndex.value >= i &&
                      expandedIndex.value < i + items.length)
                  ? controller.items[expandedIndex.value]
                  : null,
            ),
          );
        }

        ever(controller.isMoreLoading, (loading) {
          if (loading == true) {
            Future.delayed(const Duration(milliseconds: 100), () {
              if (_scrollController.hasClients) {
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent + 100,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              }
            });
          }
        });

        return RefreshIndicator(
          onRefresh: () => controller.refreshPage(),
          child: Stack(
            children: [
              // the list itself
              ListView(
                controller: _scrollController,
                padding: const EdgeInsets.only(
                  left: 8,
                  right: 8,
                  top: 8,
                  bottom: 56,
                ), // leave space under content
                children: listChildren,
              ),

              // guaranteed-visible loader overlay at the bottom
              Obx(
                () => AnimatedSlide(
                  duration: const Duration(milliseconds: 200),
                  offset: controller.isMoreLoading.value
                      ? Offset.zero
                      : const Offset(0, 1),
                  curve: Curves.easeOut,
                  child: IgnorePointer(
                    ignoring: true, // don't block touches
                    child: SafeArea(
                      top: false,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 8,
                                  spreadRadius: 0,
                                  offset: Offset(0, 2),
                                  color: Color(0x22000000),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  CupertinoActivityIndicator(
                                    color: Colors.black,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'جاري تحميل المزيد...',
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _RowExpansionSlot extends StatelessWidget {
  final TickerProvider vsync;
  final bool isActive;
  final dynamic expandedCategory;

  const _RowExpansionSlot({
    super.key,
    required this.vsync,
    required this.isActive,
    required this.expandedCategory,
  });

  @override
  Widget build(BuildContext context) {
    final Widget expandedChild =
        (isActive &&
            expandedCategory != null &&
            (expandedCategory.children?.isNotEmpty ?? false))
        ? Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListView.separated(
              itemCount: expandedCategory.children.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, subIndex) {
                final subCategory = expandedCategory.children[subIndex];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    leading: ServerImage(
                      url: Helpers.getServerImage(subCategory.image ?? ""),
                      width: 50,
                      height: 50,
                      fit: BoxFit.contain,
                      backgroundColor: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    title: Text(
                      subCategory.name,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      Get.toNamed(
                        Routes.categoryProducts,
                        arguments: {
                          'categoryId': subCategory.id,
                          'categoryName': subCategory.name,
                        },
                      );
                    },
                  ),
                );
              },
            ),
          )
        : const SizedBox.shrink();

    return ClipRect(
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: Alignment.topCenter,
        child: expandedChild,
      ),
    );
  }
}
