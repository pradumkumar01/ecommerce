import 'package:get/get.dart';
import 'package:ecommerce/config/app_constants.dart';
import 'package:ecommerce/views/screens/home_screen.dart';
import 'package:ecommerce/views/screens/auth_screen.dart';
import 'package:ecommerce/views/screens/splash_screen.dart';
import 'package:ecommerce/views/screens/product_list_screen.dart';
import 'package:ecommerce/views/screens/product_detail_screen.dart';
import 'package:ecommerce/views/screens/cart_screen.dart';
import 'package:ecommerce/views/screens/checkout_screen.dart';

class AppPages {
  static const String initial = AppConstants.splashRoute;

  static final pages = [
    GetPage(
      name: AppConstants.splashRoute,
      page: () => const SplashScreen(),
      transition: Transition.fade,
    ),
    GetPage(
      name: AppConstants.loginRoute,
      page: () => const AuthScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppConstants.homeRoute,
      page: () => const HomeScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppConstants.productListRoute,
      page: () => const ProductListScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppConstants.productDetailRoute,
      page: () => const ProductDetailScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppConstants.cartRoute,
      page: () => const CartScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppConstants.checkoutRoute,
      page: () => const CheckoutScreen(),
      transition: Transition.rightToLeft,
    ),
  ];
}
