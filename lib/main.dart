import 'package:app/controllers/auth_controller.dart';
import 'package:app/controllers/favorite_controller.dart';
import 'package:app/controllers/settings_controller.dart';
import 'package:app/helpers/constants.dart';
import 'package:app/router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  if (defaultTargetPlatform == TargetPlatform.android) {
    GoogleMapsFlutterAndroid();
  }

  // Get Put
  Get.put(AuthController(), permanent: true);
  Get.put(SettingsController(), permanent: true);
  Get.put(FavoriteController(), permanent: true);
  // End Get Put
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Store App',
      navigatorKey: Get.key,
      locale: const Locale('ar', 'SA'),
      supportedLocales: const [Locale('ar', 'SA')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'NotoKufiArabic',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: Constants.scaffoldBackgroundColor,
        useMaterial3: true,
      ),
      initialRoute: '/',
      getPages: Routes.pages,
    );
  }
}
