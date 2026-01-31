import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/controllers/cart_controller.dart';

class CheckoutController extends GetxController {
  final cartController = Get.find<CartController>();

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipCodeController = TextEditingController();

  final RxInt currentStep = 0.obs;
  final RxBool isLoading = false.obs;
  final RxString selectedPaymentMethod = 'credit_card'.obs;
  final RxBool agreeToTerms = false.obs;

  final List<String> paymentMethods = [
    'credit_card',
    'debit_card',
    'google_pay',
    'apple_pay',
    'paypal',
  ];

  final List<String> steps = ['Shipping', 'Payment', 'Review'];

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipCodeController.dispose();
    super.onClose();
  }

  void nextStep() {
    if (currentStep.value < steps.length - 1) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  void selectPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  Future<void> placeOrder() async {
    try {
      isLoading.value = true;

      // Validate form
      if (fullNameController.text.isEmpty ||
          emailController.text.isEmpty ||
          phoneController.text.isEmpty ||
          addressController.text.isEmpty ||
          cityController.text.isEmpty ||
          stateController.text.isEmpty ||
          zipCodeController.text.isEmpty) {
        Get.snackbar(
          'Error',
          'Please fill all fields',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      if (!agreeToTerms.value) {
        Get.snackbar(
          'Error',
          'Please agree to terms and conditions',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Simulate order placement
      await Future.delayed(const Duration(seconds: 2));

      // Clear cart
      cartController.clearCart();

      // Show success
      Get.offNamedUntil('/order-success', (route) => false);

      Get.snackbar(
        'Success',
        'Order placed successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
