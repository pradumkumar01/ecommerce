import 'package:get/get.dart';
import 'package:ecommerce/services/storage_service.dart';

class ThemeController extends GetxController {
  final RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initTheme();
  }

  void _initTheme() {
    final savedTheme = StorageService.getThemeMode();
    isDarkMode.value = savedTheme ?? false;
  }

  void toggleTheme() {
    isDarkMode.toggle();
    StorageService.setThemeMode(isDarkMode.value);
  }

  void setTheme(bool isDark) {
    isDarkMode.value = isDark;
    StorageService.setThemeMode(isDark);
  }
}
