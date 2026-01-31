import 'package:get/get.dart';
import 'package:ecommerce/controllers/cart_controller.dart';

class CheckoutController extends GetxController {
  late final CartController cartController;

  final RxBool isLoading = false.obs;
  final Rx<String?> selectedAddress = Rx<String?>(null);
  final Rx<String?> selectedPaymentMethod = Rx<String?>(null);

  // Saved addresses and payment methods
  final RxList<String> savedAddresses = <String>[].obs;
  final RxList<String> savedPaymentMethods = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    cartController = Get.find<CartController>();
    _loadSavedData();
  }

  void _loadSavedData() {
    // Mock saved addresses
    savedAddresses.value = [
      '2715 Ash Dr. San Jose, South Dakota 83475',
      '1234 Oak Street, Los Angeles, CA 90001',
    ];

    // Mock saved payment methods
    savedPaymentMethods.value = ['4187', '8921'];

    // Select default
    if (savedAddresses.isNotEmpty) {
      selectedAddress.value = savedAddresses.first;
    }
    if (savedPaymentMethods.isNotEmpty) {
      selectedPaymentMethod.value = savedPaymentMethods.first;
    }
  }

  void setAddress(String address) {
    selectedAddress.value = address;
  }

  void setPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  void addNewAddress(String address) {
    savedAddresses.add(address);
    selectedAddress.value = address;
  }

  void addNewPaymentMethod(String cardLast4) {
    savedPaymentMethods.add(cardLast4);
    selectedPaymentMethod.value = cardLast4;
  }

  bool _validateCheckout() {
    if (selectedAddress.value == null) {
      Get.snackbar(
        'Error',
        'Please select a shipping address',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (selectedPaymentMethod.value == null) {
      Get.snackbar(
        'Error',
        'Please select a payment method',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (cartController.cartItems.isEmpty) {
      Get.snackbar(
        'Error',
        'Your cart is empty',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    return true;
  }

  Future<void> placeOrder() async {
    if (!_validateCheckout()) return;

    try {
      isLoading.value = true;

      // Simulate order placement
      await Future.delayed(const Duration(seconds: 2));

      // Clear cart
      cartController.clearCart();

      // Navigate to success screen
      Get.offNamed('/order-success');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to place order. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
