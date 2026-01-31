import 'package:get/get.dart';
import 'package:ecommerce/config/app_constants.dart';
import 'package:ecommerce/views/screens/home_screen.dart';
import 'package:ecommerce/views/screens/splash_screen.dart';
import 'package:ecommerce/views/screens/product_list_screen.dart';
import 'package:ecommerce/views/screens/product_detail_screen.dart';
import 'package:ecommerce/views/screens/cart_screen.dart';
import 'package:ecommerce/views/screens/checkout_screen.dart';
import 'package:ecommerce/views/screens/login_screen.dart';
import 'package:ecommerce/views/screens/register_screen.dart';
import 'package:ecommerce/views/screens/forgot_password_screen.dart';
import 'package:ecommerce/views/screens/onboarding_screen.dart';
import 'package:ecommerce/views/screens/category_list_screen.dart';
import 'package:ecommerce/views/screens/product_category_screen.dart';
import 'package:ecommerce/views/screens/notification_screen.dart';
import 'package:ecommerce/views/screens/orders_screen.dart';
import 'package:ecommerce/views/screens/order_details_screen.dart';
import 'package:ecommerce/views/screens/order_success_screen.dart';
import 'package:ecommerce/views/screens/profile_screen.dart';
import 'package:ecommerce/views/screens/address_screen.dart';
import 'package:ecommerce/views/screens/add_address_screen.dart';
import 'package:ecommerce/views/screens/payment_screen.dart';
import 'package:ecommerce/views/screens/add_card_screen.dart';
import 'package:ecommerce/views/screens/wishlist_screen.dart';
import 'package:ecommerce/views/screens/favourites_screen.dart';
import 'package:ecommerce/bindings/notification_binding.dart';
import 'package:ecommerce/bindings/order_binding.dart';
import 'package:ecommerce/bindings/profile_binding.dart';

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
      page: () => const LoginScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppConstants.registerRoute,
      page: () => const RegisterScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppConstants.homeRoute,
      page: () => const HomeScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppConstants.notificationRoute,
      page: () => NotificationScreen(),
      binding: NotificationBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: '/orders',
      page: () => OrdersScreen(),
      binding: OrderBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: '/order-details',
      page: () => OrderDetailsScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: '/forgot-password',
      page: () => const ForgotPasswordScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: '/onboarding',
      page: () => const OnboardingScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: '/category-list',
      page: () => const CategoryListScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: '/product-category',
      page: () => const ProductCategoryScreen(),
      transition: Transition.rightToLeft,
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
    GetPage(
      name: '/order-success',
      page: () => const OrderSuccessScreen(),
      transition: Transition.fade,
    ),
    GetPage(
      name: '/profile',
      page: () => ProfileScreen(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: '/address',
      page: () => AddressScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: '/add-address',
      page: () => AddAddressScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: '/payment',
      page: () => PaymentScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: '/add-card',
      page: () => AddCardScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: '/wishlist',
      page: () => WishlistScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: '/favourites',
      page: () => FavouritesScreen(),
      transition: Transition.rightToLeft,
    ),
  ];
}
