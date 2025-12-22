import 'package:app/controllers/favorite_controller.dart';
import 'package:app/router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class FavoriteBadgeButton extends StatelessWidget {
  const FavoriteBadgeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoritesController controller = Get.find<FavoritesController>();

    return Obx(() {
      final count = controller.favorites.length;

      return InkWell(
        onTap: () {
          Get.toNamed(Routes.favorites);
        },
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Icon(
                LucideIcons.heart,
                color: Colors.grey.shade600,
                size: 24,
              ),
            ),
            if (count > 0)
              Positioned(
                right: 4,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    count > 9 ? '9+' : '$count',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}
