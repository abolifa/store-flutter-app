import 'package:app/controllers/auth_controller.dart';
import 'package:app/controllers/favorite_controller.dart';
import 'package:app/helpers/constants.dart';
import 'package:app/router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class FavoriteButton extends StatelessWidget {
  final int productId;

  const FavoriteButton({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final FavoriteController controller = Get.find<FavoriteController>();
    final AuthController authController = Get.find<AuthController>();

    return Obx(() {
      final isFav = controller.isFavorited(productId);

      return InkWell(
        onTap: () async {
          if (!authController.isAuthenticated.value) {
            Get.toNamed(Routes.login);
            return;
          }
          final bool favorited = await controller.toggleFavorite(productId);
          if (!context.mounted) return;
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(
                      favorited ? LucideIcons.heart : LucideIcons.heartOff,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      favorited
                          ? 'تمت الإضافة للمفضلة'
                          : 'تمت الإزالة من المفضلة',
                    ),
                  ],
                ),
                backgroundColor: Colors.grey.shade800,
                duration: const Duration(seconds: 2),
              ),
            );
        },
        child: Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: [Constants.boxShadow],
          ),
          child: Icon(
            isFav ? Icons.favorite : LucideIcons.heart,
            size: 22,
            color: isFav ? Colors.redAccent : Colors.grey.shade400,
          ),
        ),
      );
    });
  }
}
