import 'package:app/controllers/auth_controller.dart';
import 'package:app/controllers/favorite_controller.dart';
import 'package:app/router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class FavoriteButton extends StatefulWidget {
  final int productId;
  const FavoriteButton({super.key, required this.productId});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool _isProcessing = false;
  final FavoritesController favCtrl = Get.find<FavoritesController>();
  final AuthController authCtrl = Get.find<AuthController>();

  Future<void> _handleToggle() async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    await favCtrl.toggleFavorite(widget.productId);

    final newFav = favCtrl.isFavorite(widget.productId);
    if (mounted) {
      if (!authCtrl.isAuthenticated.value) {
        Get.toNamed(Routes.login);
        setState(() => _isProcessing = false);
        return;
      }
      Get.closeAllSnackbars();
      GetSnackBar(
        message: newFav
            ? 'تمت إضافة المنتج إلى المفضلة'
            : 'تمت إزالة المنتج من المفضلة',
        duration: const Duration(seconds: 2),
      ).show();
    }

    HapticFeedback.lightImpact();
    setState(() => _isProcessing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isFav = favCtrl.isFavorite(widget.productId);
      return InkWell(
        onTap: _isProcessing ? null : _handleToggle,
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          width: 35,
          height: 35,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _isProcessing ? Colors.grey.shade100 : Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.grey.shade300, width: 0.7),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 2.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: _isProcessing
              ? const SizedBox(
                  width: 14,
                  height: 14,
                  child: CupertinoActivityIndicator(radius: 7),
                )
              : Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : Colors.grey,
                  size: 20,
                ),
        ),
      );
    });
  }
}
