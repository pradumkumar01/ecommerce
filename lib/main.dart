import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:device_preview/device_preview.dart';
import 'package:ecommerce/config/app_styles.dart';
import 'package:ecommerce/controllers/theme_controller.dart';
import 'package:ecommerce/controllers/auth_controller.dart';
import 'package:ecommerce/controllers/home_controller.dart';
import 'package:ecommerce/controllers/product_list_controller.dart';
import 'package:ecommerce/controllers/product_detail_controller.dart';
import 'package:ecommerce/controllers/cart_controller.dart';
import 'package:ecommerce/controllers/checkout_controller.dart';
import 'package:ecommerce/controllers/notification_controller.dart';
import 'package:ecommerce/controllers/order_controller.dart';
import 'package:ecommerce/routes/app_pages.dart';
import 'package:ecommerce/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();

  // Initialize controllers
  Get.put(ThemeController());
  Get.put(AuthController());
  Get.put(HomeController());
  Get.put(ProductListController());
  Get.put(ProductDetailController());
  Get.put(CartController());
  Get.put(CheckoutController());
  Get.put(NotificationController());
  Get.put(OrderController());

  runApp(DevicePreview(enabled: true, builder: (context) => const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ShopHub',
      debugShowCheckedModeBanner: false,
      themeMode: Get.find<ThemeController>().isDarkMode.value
          ? ThemeMode.dark
          : ThemeMode.light,
      theme: AppThemeData.lightTheme(),
      darkTheme: AppThemeData.darkTheme(),
      initialRoute: AppPages.initial,
      getPages: AppPages.pages,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      builder: (context, child) {
        return DevicePreview.appBuilder(context, child);
      },
    );
  }
}
