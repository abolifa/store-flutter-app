import 'package:app/controllers/favorite_controller.dart';
import 'package:app/widgets/app_dialog.dart';
import 'package:app/widgets/custom_app_bar.dart';
import 'package:app/widgets/empty_screen.dart';
import 'package:app/widgets/product/perks_widget.dart';
import 'package:app/widgets/product/price_widget.dart';
import 'package:app/widgets/product/product_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart' show LucideIcons;

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavoritesController>();

    return Scaffold(
      appBar: CustomAppBar(title: 'المفضلة'),
      body: Obx(() {
        final favorites = controller.favorites;
        final favCount = favorites.length;

        if (controller.isLoading.value) {
          return const Center(child: CupertinoActivityIndicator());
        }

        if (favorites.isEmpty) {
          return EmptyScreen(
            title: 'قائمة المفضلة فارغة',
            subtitle: 'لم تقم بإضافة أي أصناف إلى المفضلة بعد',
            imagePath: 'assets/images/no-products.png',
          );
        }

        return Column(
          children: [
            Divider(thickness: 1, height: 1, color: Colors.grey.shade300),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 15.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200, width: 1.0),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    '$favCount ${favCount == 1 ? 'صنف' : 'أصناف'}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => controller.loadFavorites(),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade100,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(LucideIcons.share2200, size: 20),
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () async {
                      await showCupertinoDialogBox(
                        context: context,
                        title: "تأكيد",
                        message: "هل أنت متأكد من حذف جميع العناصر من المفضلة؟",
                        confirmText: "حذف",
                        cancelText: "إلغاء",
                        onConfirm: () => controller.clearFavorites(),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade100,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(LucideIcons.trash2200, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5.0),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  childAspectRatio: 0.60,
                ),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final item = favorites[index];
                  return Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.2),
                          spreadRadius: 0.5,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProductImage(product: item, height: 220.0),
                        const SizedBox(height: 8.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              PriceWidget(product: item),
                              const SizedBox(height: 8.0),
                              PerksWidget(perks: item.perks),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
