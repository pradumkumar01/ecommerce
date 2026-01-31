import 'package:get_storage/get_storage.dart';
import 'package:ecommerce/config/app_constants.dart';

class StorageService {
  static final GetStorage _storage = GetStorage();

  static Future<void> init() async {
    await GetStorage.init();
  }

  // Save data
  static Future<void> write(String key, dynamic value) async {
    await _storage.write(key, value);
  }

  // Read data
  static dynamic read(String key) {
    return _storage.read(key);
  }

  // Check if key exists
  static bool hasKey(String key) {
    return _storage.hasData(key);
  }

  // Remove data
  static Future<void> remove(String key) async {
    await _storage.remove(key);
  }

  // Clear all data
  static Future<void> clear() async {
    await _storage.erase();
  }

  // User Token
  static String? getUserToken() {
    return read(AppConstants.userTokenKey);
  }

  static Future<void> saveUserToken(String token) async {
    await write(AppConstants.userTokenKey, token);
  }

  static Future<void> clearUserToken() async {
    await remove(AppConstants.userTokenKey);
  }

  // Theme
  static bool? getThemeMode() {
    return read(AppConstants.themeKey);
  }

  static Future<void> setThemeMode(bool isDarkMode) async {
    await write(AppConstants.themeKey, isDarkMode);
  }

  // First Time
  static bool isFirstTime() {
    return read(AppConstants.isFirstTimeKey) ?? true;
  }

  static Future<void> setFirstTime(bool value) async {
    await write(AppConstants.isFirstTimeKey, value);
  }

  // Cart
  static List<dynamic>? getCartData() {
    return read(AppConstants.cartDataKey);
  }

  static Future<void> saveCartData(List<dynamic> cartData) async {
    await write(AppConstants.cartDataKey, cartData);
  }

  static Future<void> clearCartData() async {
    await remove(AppConstants.cartDataKey);
  }
}
