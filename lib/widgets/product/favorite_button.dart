import 'package:app/controllers/favorite_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class FavoriteButton extends StatelessWidget {
  final int productId;
  final double size;
  final Color activeColor;
  final Color inactiveColor;

  const FavoriteButton({
    super.key,
    required this.productId,
    this.size = 22,
    this.activeColor = Colors.red,
    this.inactiveColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    final FavoriteController controller = Get.find<FavoriteController>();
    return Obx(() {
      final isFav = controller.isFavorited(productId);
      return GestureDetector(
        onTap: () => controller.toggleFavorite(productId),
        child: Icon(
          isFav ? LucideIcons.heart : LucideIcons.heartOff,
          size: size,
          color: isFav ? activeColor : inactiveColor,
        ),
      );
    });
  }
}
