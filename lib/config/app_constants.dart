class AppConstants {
  // API Endpoints
  static const String baseUrl = 'https://api.example.com';
  static const int apiTimeout = 30;

  // Routes
  static const String splashRoute = '/';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String homeRoute = '/home';
  static const String productListRoute = '/products';
  static const String productDetailRoute = '/product-detail';
  static const String cartRoute = '/cart';
  static const String checkoutRoute = '/checkout';
  static const String profileRoute = '/profile';
  static const String settingsRoute = '/settings';
  static const String ordersRoute = '/orders';
  static const String orderDetailRoute = '/order-detail';
  static const String searchRoute = '/search';
  static const String favoriteRoute = '/favorites';
  static const String notificationRoute = '/notifications';

  // Preferences Keys
  static const String isFirstTimeKey = 'is_first_time';
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String themeKey = 'theme';
  static const String languageKey = 'language';
  static const String cartDataKey = 'cart_data';

  // Pagination
  static const int pageSize = 20;
  static const int initialPage = 1;

  // Animation Durations
  static const Duration shortDuration = Duration(milliseconds: 200);
  static const Duration mediumDuration = Duration(milliseconds: 500);
  static const Duration longDuration = Duration(milliseconds: 1000);

  // Strings
  static const String appName = 'ShopHub';
  static const String appVersion = '1.0.0';

  // Debounce Duration
  static const Duration debounceDuration = Duration(milliseconds: 500);

  // Retry Configuration
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);
}

class ValidationRegex {
  static const String emailRegex =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phoneRegex =
      r'^[+]?[(]?[0-9]{3}[)]?[-\s.]?[0-9]{3}[-\s.]?[0-9]{4,6}$';
  static const String passwordRegex =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  static const String nameRegex = r'^[a-zA-Z\s]{2,}$';
}

class ErrorMessages {
  static const String networkError =
      'Network error. Please check your connection.';
  static const String serverError = 'Server error. Please try again later.';
  static const String timeoutError = 'Request timeout. Please try again.';
  static const String unknownError = 'An unknown error occurred.';
  static const String noInternetError = 'No internet connection';
  static const String invalidEmail = 'Please enter a valid email address';
  static const String invalidPassword =
      'Password must be at least 8 characters with uppercase, lowercase, number, and special character';
  static const String invalidPhone = 'Please enter a valid phone number';
  static const String invalidName = 'Name must be at least 2 characters';
  static const String fieldRequired = 'This field is required';
  static const String passwordMismatch = 'Passwords do not match';
}
