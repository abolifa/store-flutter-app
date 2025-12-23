import 'package:app/modals/map_modal.dart';
import 'package:app/models/address.dart';
import 'package:app/screens/auth/login_screen.dart';
import 'package:app/screens/auth/register_screen.dart';
import 'package:app/screens/cart/screens/checkout_screen.dart';
import 'package:app/screens/cart/screens/order_place_screen.dart';
import 'package:app/screens/categories/category_product_screen.dart';
import 'package:app/screens/main_home_screen.dart';
import 'package:app/screens/profile/screens/address_form.dart';
import 'package:app/screens/profile/screens/address_screen.dart';
import 'package:app/screens/profile/screens/qr_code_screen.dart';
import 'package:app/screens/profile/screens/rich_html_view.dart';
import 'package:app/screens/profile/screens/wallet_screen.dart';
import 'package:app/screens/splash_screen.dart';
import 'package:app/screens/utilities/brand_products_screen.dart';
import 'package:app/screens/utilities/brands_screen.dart';
import 'package:app/screens/utilities/favorites_screen.dart';
import 'package:app/screens/utilities/maintenance_screen.dart';
import 'package:app/screens/utilities/no_address_screen.dart';
import 'package:app/screens/utilities/offer_products_screen.dart';
import 'package:app/screens/utilities/product_details_screen.dart';
import 'package:app/screens/utilities/products_by_id_screen.dart';
import 'package:app/screens/utilities/search_products_screen.dart';
import 'package:app/screens/utilities/slider_products_screen.dart';
import 'package:get/get.dart';

class Routes {
  static const splash = '/';
  static const home = '/home';

  static const login = '/login';
  static const register = '/register';

  static const maintenance = '/maintenance';

  static const categories = '/categories';
  static const categoryProducts = '/category-products';
  static const brands = '/brands';
  static const brandProducts = '/brand-products';
  static const searchProducts = '/search-products';
  static const productsByIds = '/products-by-ids';

  static const favorites = '/favorites';

  static const addressScreen = '/address-screen';
  static const addressForm = '/address-form';
  static const mapModal = '/map-modal';
  static const qrCodeScreen = '/qr-code-screen';
  static const staticPage = '/static-pages';
  static const offerProducts = '/offer-products';
  static const sliderProducts = '/slider-products';
  static const checkoutScreen = '/checkout-screen';
  static const orderPlace = '/order-place';
  static const wallet = '/wallet';
  static const productDetails = '/product-details';

  static final pages = [
    GetPage(name: splash, page: () => SplashScreen()),

    GetPage(
      name: home,
      page: () {
        final index = Get.arguments ?? 0;
        return MainHomeScreen(initialIndex: index);
      },
    ),

    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: register, page: () => RegisterScreen()),

    GetPage(name: maintenance, page: () => MaintenanceScreen()),

    GetPage(
      name: categoryProducts,
      page: () {
        final args = Get.arguments;
        int categoryId = 0;
        String? categoryName;
        if (args is Map) {
          categoryId = int.tryParse('${args['categoryId'] ?? 0}') ?? 0;
          categoryName = args['categoryName']?.toString();
        }
        return CategoryProductScreen(
          categoryId: categoryId,
          categoryName: categoryName,
        );
      },
    ),

    GetPage(
      name: brandProducts,
      page: () {
        final args = Get.arguments;
        int brandId = 0;
        String? brandName;
        if (args is Map) {
          brandId = int.tryParse('${args['brandId'] ?? 0}') ?? 0;
          brandName = args['brandName']?.toString();
        }
        return BrandProductScreen(brandId: brandId, brandName: brandName);
      },
    ),

    GetPage(name: brands, page: () => BrandsScreen()),
    GetPage(name: searchProducts, page: () => const SearchProductsScreen()),

    GetPage(
      name: productsByIds,
      page: () {
        final args = Get.arguments;
        List<int> productIds = [];
        if (args is Map) {
          if (args['productIds'] is List<int>) {
            productIds = args['productIds'];
          } else if (args['productIds'] is List<dynamic>) {
            productIds = (args['productIds'] as List)
                .map((e) => int.tryParse('$e') ?? 0)
                .where((id) => id != 0)
                .toList();
          }
        }
        return ProductsByIdsScreen(productIds: productIds);
      },
    ),

    GetPage(name: favorites, page: () => const FavoritesScreen()),

    GetPage(name: addressScreen, page: () => const AddressScreen()),

    GetPage(
      name: addressForm,
      page: () {
        final args = Get.arguments;
        if (args is Map && args.containsKey('address')) {
          return AddressForm(
            address: args['address'],
            prefilled: args['prefilled'],
          );
        }
        return AddressForm(prefilled: args?['prefilled']);
      },
    ),

    GetPage(
      name: mapModal,
      page: () {
        final args = Get.arguments;
        Address? address;
        if (args is Address) {
          address = args;
        } else if (args is Map<String, dynamic>) {
          try {
            address = Address.fromJson(args);
          } catch (_) {
            address = null;
          }
        }
        return MapModal(address: address);
      },
    ),
    GetPage(name: qrCodeScreen, page: () => QrCodeScreen()),
    GetPage(
      name: staticPage,
      page: () {
        final args = Get.arguments as Map<String, dynamic>?;
        final title = args?['title']?.toString() ?? '';
        final settingKey = args?['settingKey']?.toString() ?? '';
        return RichHtmlView(title: title, settingKey: settingKey);
      },
    ),
    GetPage(
      name: offerProducts,
      page: () {
        final args = Get.arguments;
        int offerId = 0;
        if (args is Map) {
          offerId = int.tryParse('${args['offerId'] ?? 0}') ?? 0;
        }
        return OfferProductsScreen(offerId: offerId);
      },
    ),
    GetPage(
      name: sliderProducts,
      page: () {
        final args = Get.arguments;
        int sliderId = 0;
        if (args is Map) {
          sliderId = int.tryParse('${args['sliderId'] ?? 0}') ?? 0;
        }
        return SliderProductsScreen(sliderId: sliderId);
      },
    ),
    GetPage(
      name: checkoutScreen,
      page: () {
        final args = Get.arguments;
        if (args is! Map || args['selectedAddress'] is! Address) {
          return NoAddressScreen();
        }
        return CheckoutScreen(
          selectedAddress: args['selectedAddress'] as Address,
        );
      },
    ),
    GetPage(
      name: orderPlace,
      page: () {
        final args = Get.arguments as Map<String, dynamic>?;
        final addressId = args?['addressId'] is int
            ? args!['addressId'] as int
            : int.tryParse('${args?['addressId'] ?? 0}') ?? 0;
        final paymentMethodId = args?['paymentMethodId'] is int
            ? args!['paymentMethodId'] as int
            : int.tryParse('${args?['paymentMethodId'] ?? 0}') ?? 0;
        final couponCode = args?['couponCode']?.toString();
        return OrderPlaceScreen(
          addressId: addressId,
          paymentMethodId: paymentMethodId,
          couponCode: couponCode,
        );
      },
    ),
    GetPage(name: wallet, page: () => const WalletScreen()),
    GetPage(
      name: productDetails,
      page: () {
        final args = Get.arguments;
        int productId = 0;
        if (args is Map) {
          productId = int.tryParse('${args['productId'] ?? 0}') ?? 0;
        }
        return ProductDetailsScreen(productId: productId);
      },
    ),
  ];
}
