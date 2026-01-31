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

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
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

  bool _validatePassword(String password) {
    return password.length >= 6; // Simple validation for demo
  }

  bool _validateForm() {
    if (emailController.text.isEmpty) {
      errorMessage.value = ErrorMessages.fieldRequired;
      return false;
    }

    if (!_validateEmail(emailController.text)) {
      errorMessage.value = ErrorMessages.invalidEmail;
      return false;
    }

    if (passwordController.text.isEmpty) {
      errorMessage.value = ErrorMessages.fieldRequired;
      return false;
    }

    if (!_validatePassword(passwordController.text)) {
      errorMessage.value = 'Password must be at least 6 characters';
      return false;
    }

    if (!isLoginMode.value) {
      if (nameController.text.isEmpty) {
        errorMessage.value = ErrorMessages.fieldRequired;
        return false;
      }

      if (passwordController.text != confirmPasswordController.text) {
        errorMessage.value = ErrorMessages.passwordMismatch;
        return false;
      }
    }

    return true;
  }

  Future<void> login() async {
    if (!_validateForm()) {
      return;
    }

    try {
      isLoading.value = true;
      clearErrors();

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock token
      final mockToken = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';

      // Save token
      await StorageService.saveUserToken(mockToken);

      LoggerService.info('Login successful');
      Get.offNamed(AppConstants.homeRoute);
    } catch (e) {
      errorMessage.value = ErrorMessages.serverError;
      LoggerService.error('Login error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    if (!_validateForm()) {
      return;
    }

    try {
      isLoading.value = true;
      clearErrors();

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock token
      final mockToken = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';

      // Save token
      await StorageService.saveUserToken(mockToken);

      LoggerService.info('Registration successful');
      Get.offNamed(AppConstants.homeRoute);
    } catch (e) {
      errorMessage.value = ErrorMessages.serverError;
      LoggerService.error('Registration error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await StorageService.clearUserToken();
      Get.offNamed(AppConstants.loginRoute);
    } catch (e) {
      LoggerService.error('Logout error: $e');
    }
  }
}
