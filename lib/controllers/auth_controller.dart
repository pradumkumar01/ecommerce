import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/config/app_constants.dart';
import 'package:ecommerce/services/storage_service.dart';
import 'package:ecommerce/services/logger_service.dart';

class AuthController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isLoginMode = true.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isAuthenticated = false.obs;
  final RxString userEmail = ''.obs;
  final RxString userName = ''.obs;

  // Dummy users database
  final List<Map<String, String>> _dummyUsers = [
    {
      'email': 'test@example.com',
      'password': 'password123',
      'name': 'Test User',
    },
    {'email': 'demo@example.com', 'password': 'demo1234', 'name': 'Demo User'},
  ];

  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  Future<void> _checkAuthStatus() async {
    final token = await StorageService.getUserToken();
    if (token != null && token.isNotEmpty) {
      isAuthenticated.value = true;
      final savedEmail = await StorageService.getUserEmail();
      final savedName = await StorageService.getUserName();
      userEmail.value = savedEmail ?? '';
      userName.value = savedName ?? '';
    }
  }

  void toggleMode() {
    isLoginMode.toggle();
    clearErrors();
  }

  void clearErrors() {
    errorMessage.value = '';
  }

  bool _validateEmail(String email) {
    return RegExp(ValidationRegex.emailRegex).hasMatch(email);
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      clearErrors();

      // Validate inputs
      if (email.isEmpty || password.isEmpty) {
        errorMessage.value = 'Email and password are required';
        return;
      }

      if (!_validateEmail(email)) {
        errorMessage.value = ErrorMessages.invalidEmail;
        return;
      }

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Check against dummy users
      final user = _dummyUsers.firstWhereOrNull(
        (u) => u['email'] == email && u['password'] == password,
      );

      if (user == null) {
        errorMessage.value = 'Invalid email or password';
        LoggerService.error('Login failed: Invalid credentials');
        return;
      }

      // Mock token
      final mockToken = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';

      // Save token and user data
      await StorageService.saveUserToken(mockToken);
      await StorageService.saveUserEmail(email);
      await StorageService.saveUserName(user['name'] ?? 'User');

      // Update state
      isAuthenticated.value = true;
      userEmail.value = email;
      userName.value = user['name'] ?? 'User';

      LoggerService.info('Login successful for $email');
      Get.offNamed('/onboarding');
    } catch (e) {
      errorMessage.value = ErrorMessages.serverError;
      LoggerService.error('Login error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    try {
      isLoading.value = true;
      clearErrors();

      // Validate inputs
      if (firstName.isEmpty ||
          lastName.isEmpty ||
          email.isEmpty ||
          password.isEmpty) {
        errorMessage.value = 'All fields are required';
        return;
      }

      if (!_validateEmail(email)) {
        errorMessage.value = ErrorMessages.invalidEmail;
        return;
      }

      if (password.length < 6) {
        errorMessage.value = 'Password must be at least 6 characters';
        return;
      }

      // Check if email already exists
      final existingUser = _dummyUsers.firstWhereOrNull(
        (u) => u['email'] == email,
      );

      if (existingUser != null) {
        errorMessage.value = 'Email already registered';
        return;
      }

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Add new user to dummy database
      final fullName = '$firstName $lastName';
      _dummyUsers.add({'email': email, 'password': password, 'name': fullName});

      // Mock token
      final mockToken = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';

      // Save token and user data
      await StorageService.saveUserToken(mockToken);
      await StorageService.saveUserEmail(email);
      await StorageService.saveUserName(fullName);

      // Update state
      isAuthenticated.value = true;
      userEmail.value = email;
      userName.value = fullName;

      LoggerService.info('Registration successful for $email');
      Get.offNamed('/onboarding');
    } catch (e) {
      errorMessage.value = ErrorMessages.serverError;
      LoggerService.error('Registration error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      isLoading.value = true;
      clearErrors();

      if (email.isEmpty) {
        errorMessage.value = 'Email is required';
        return;
      }

      if (!_validateEmail(email)) {
        errorMessage.value = ErrorMessages.invalidEmail;
        return;
      }

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Check if email exists
      final user = _dummyUsers.firstWhereOrNull((u) => u['email'] == email);

      if (user == null) {
        errorMessage.value = 'Email not found in our records';
        return;
      }

      LoggerService.info('Password reset email sent to $email');
    } catch (e) {
      errorMessage.value = ErrorMessages.serverError;
      LoggerService.error('Reset password error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> completeOnboarding({String? gender, String? ageRange}) async {
    try {
      // Save onboarding preferences
      if (gender != null) {
        await StorageService.savePreference('gender', gender);
      }
      if (ageRange != null) {
        await StorageService.savePreference('ageRange', ageRange);
      }

      LoggerService.info('Onboarding completed');
    } catch (e) {
      LoggerService.error('Onboarding error: $e');
    }
  }

  Future<void> logout() async {
    try {
      await StorageService.clearUserToken();
      await StorageService.clearUserEmail();
      await StorageService.clearUserName();

      isAuthenticated.value = false;
      userEmail.value = '';
      userName.value = '';

      Get.offNamed(AppConstants.loginRoute);
    } catch (e) {
      LoggerService.error('Logout error: $e');
    }
  }
}
