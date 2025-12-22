import 'package:app/controllers/auth_controller.dart';
import 'package:app/controllers/cart_controller.dart';
import 'package:app/controllers/favorite_controller.dart';
import 'package:app/controllers/settings_controller.dart';
import 'package:app/helpers/helpers.dart';
import 'package:app/models/session.dart';
import 'package:app/router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthController auth = Get.find<AuthController>();
  final SettingsController settings = Get.find<SettingsController>();
  final FavoritesController fav = Get.find<FavoritesController>();
  final CartController cart = Get.find<CartController>();

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      final savedLat = Session.get<double>(SessionKey.keyLatitude);
      final savedLng = Session.get<double>(SessionKey.keyLongitude);
      debugPrint('Saved Location: lat=$savedLat, lng=$savedLng');
      await settings.fetchSettings();
      if (settings.isMaintenanceMode) {
        Get.offAllNamed(Routes.maintenance);
        return;
      }
      await _ensureLocationAvailable();
      final success = await auth.tryAutoLogin();
      if (success) {
        await fav.loadFavorites();
        await cart.loadCart();
      }
      if (!mounted) return;
      Get.offAllNamed(Routes.home);
    } catch (e) {
      debugPrint('Splash initialization error: $e');
      // Get.offAllNamed(Routes.locationRequired);
    }
  }

  Future<void> _ensureLocationAvailable() async {
    double? lat = Session.get<double>(SessionKey.keyLatitude);
    double? lng = Session.get<double>(SessionKey.keyLongitude);
    if (lat != null && lng != null) return;
    try {
      final position = await Helpers.determinePosition().timeout(
        const Duration(seconds: 5),
      );
      debugPrint('Location is Granted: $position');
      await Session.set(SessionKey.keyLatitude, position.latitude);
      await Session.set(SessionKey.keyLongitude, position.longitude);
    } catch (e) {
      debugPrint('⚠️ Location error: $e');
      await Session.set(SessionKey.keyLatitude, 32.8872);
      await Session.set(SessionKey.keyLongitude, 13.1913);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CupertinoActivityIndicator(
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
