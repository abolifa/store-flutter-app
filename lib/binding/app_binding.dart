import 'package:app/controllers/address_controller.dart';
import 'package:app/controllers/auth_controller.dart';
import 'package:app/controllers/cart_controller.dart';
import 'package:app/controllers/checkout_controller.dart';
import 'package:app/controllers/favorite_controller.dart';
import 'package:app/controllers/settings_controller.dart';
import 'package:app/controllers/wallet_controller.dart';
import 'package:app/services/fcm_service.dart';
import 'package:app/services/notification_service.dart';
import 'package:get/get.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
    Get.put(SettingsController(), permanent: true);
    Get.put(FavoritesController(), permanent: true);
    Get.put(CartController(), permanent: true);
    Get.put(CheckoutController(), permanent: true);
    Get.putAsync(() => FcmService().init(), permanent: true);
    Get.putAsync(() => NotificationService().init(), permanent: true);
    Get.lazyPut<AddressController>(() => AddressController(), fenix: true);
    Get.lazyPut<WalletController>(() => WalletController(), fenix: true);
  }
}
