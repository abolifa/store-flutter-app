import 'package:app/screens/auth/login_screen.dart';
import 'package:app/screens/auth/register_screen.dart';
import 'package:app/screens/main_home_screen.dart';
import 'package:app/screens/splash_screen.dart';
import 'package:app/screens/utilities/maintenance_screen.dart';
import 'package:get/get.dart';

class Routes {
  static const home = '/home';
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const maintenance = '/maintenance';

  static final pages = [
    GetPage(
      name: Routes.home,
      page: () {
        final index = Get.arguments ?? 0;
        return MainHomeScreen(initialIndex: index);
      },
    ),
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: register, page: () => RegisterScreen()),
    GetPage(name: maintenance, page: () => MaintenanceScreen()),
  ];
}
