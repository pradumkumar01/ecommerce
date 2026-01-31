import 'package:ecommerce/config/app_constants.dart';
import 'package:get/get.dart';
import 'package:ecommerce/models/product_model.dart';
import 'package:ecommerce/services/storage_service.dart';
import 'package:ecommerce/services/logger_service.dart';

class CartController extends GetxController {
  final RxList<CartItem> cartItems = <CartItem>[].obs;
  final RxBool isLoading = false.obs;

  // Pricing
  final Rx<double> subtotal = 0.0.obs;
  final Rx<double> taxRate = 0.1.obs; // 10% tax
  final Rx<double> taxAmount = 0.0.obs;
  final Rx<double> shippingCost = 0.0.obs;
  final Rx<double> total = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCart();
  }

  void _loadCart() {
    try {
      final cartData = StorageService.getCartData();
      if (cartData != null) {
        cartItems.value = cartData
            .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      _calculateTotals();
    } catch (e) {
      LoggerService.error('Error loading cart: $e');
    }
  }

  void _calculateTotals() {
    // Calculate subtotal
    subtotal.value = cartItems.fold(0.0, (sum, item) => sum + item.total);

    // Calculate tax
    taxAmount.value = subtotal.value * taxRate.value;

    // Set shipping cost (free if over $100)
    shippingCost.value = subtotal.value > 100 ? 0.0 : 9.99;

    // Calculate total
    total.value = subtotal.value + taxAmount.value + shippingCost.value;
  }

  void _saveCart() {
    try {
      StorageService.saveCartData(
        cartItems.map((item) => item.toJson()).toList(),
      );
    } catch (e) {
      LoggerService.error('Error saving cart: $e');
    }
  }

  void addToCart(
    Product product, {
    int quantity = 1,
    String? size,
    String? color,
  }) {
    try {
      // Create a unique key based on product id, size, and color
      final itemKey = '${product.id}_${size ?? ''}_${color ?? ''}';

      final existingItem = cartItems.firstWhereOrNull(
        (item) =>
            '${item.product.id}_${item.size ?? ''}_${item.color ?? ''}' ==
            itemKey,
      );

      if (existingItem != null) {
        final index = cartItems.indexOf(existingItem);
        cartItems[index] = CartItem(
          product: product,
          quantity: existingItem.quantity + quantity,
          size: size,
          color: color,
        );
      } else {
        cartItems.add(
          CartItem(
            product: product,
            quantity: quantity,
            size: size,
            color: color,
          ),
        );
      }

      _calculateTotals();
      _saveCart();

      Get.snackbar(
        'Added to Cart',
        '${product.name} added successfully',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      LoggerService.error('Error adding to cart: $e');
    }
  }

  void removeFromCart(String productId) {
    try {
      cartItems.removeWhere((item) => item.product.id == productId);
      _calculateTotals();
      _saveCart();
    } catch (e) {
      LoggerService.error('Error removing from cart: $e');
    }
  }

  void updateQuantity(String productId, int newQuantity) {
    try {
      if (newQuantity <= 0) {
        removeFromCart(productId);
        return;
      }

      final index = cartItems.indexWhere(
        (item) => item.product.id == productId,
      );
      if (index != -1) {
        cartItems[index] = CartItem(
          product: cartItems[index].product,
          quantity: newQuantity,
        );
        _calculateTotals();
        _saveCart();
      }
    } catch (e) {
      LoggerService.error('Error updating quantity: $e');
    }
  }

  void incrementQuantity(String productId) {
    final item = cartItems.firstWhereOrNull(
      (item) => item.product.id == productId,
    );
    if (item != null) {
      updateQuantity(productId, item.quantity + 1);
    }
  }

  void decrementQuantity(String productId) {
    final item = cartItems.firstWhereOrNull(
      (item) => item.product.id == productId,
    );
    if (item != null) {
      updateQuantity(productId, item.quantity - 1);
    }
  }

  void clearCart() {
    try {
      cartItems.clear();
      _calculateTotals();
      _saveCart();
    } catch (e) {
      LoggerService.error('Error clearing cart: $e');
    }
  }

  int get cartItemCount =>
      cartItems.fold(0, (sum, item) => sum + item.quantity);

  bool get isEmpty => cartItems.isEmpty;

  bool get isNotEmpty => cartItems.isNotEmpty;

  void applyCoupon(String code) {
    // Coupon logic
    Get.snackbar(
      'Coupon',
      'Coupon "$code" applied successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void proceedToCheckout() {
    if (isNotEmpty) {
      Get.toNamed(AppConstants.checkoutRoute);
    } else {
      Get.snackbar(
        'Empty Cart',
        'Please add items to cart before checkout',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
