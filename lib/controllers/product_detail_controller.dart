import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce/models/product_model.dart';
import 'package:ecommerce/controllers/cart_controller.dart';

class Review {
  final String id;
  final String userName;
  final int rating;
  final String comment;
  final String date;
  final bool verified;

  Review({
    required this.id,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
    this.verified = false,
  });
}

class ProductDetailController extends GetxController {
  final Rx<Product?> product = Rx<Product?>(null);
  final RxInt quantity = 1.obs;
  final RxBool isFavorite = false.obs;
  final RxBool isLoading = false.obs;
  final RxList<Product> relatedProducts = <Product>[].obs;
  final RxList<String> selectedImages = <String>[].obs;
  final RxInt selectedImageIndex = 0.obs;
  final RxList<Review> reviews = <Review>[].obs;

  // Size and Color
  final RxString selectedSize = 'S'.obs;
  final RxString selectedColor = 'Orange'.obs;
  final List<String> availableSizes = ['S', 'M', 'L', 'XL', '2XL'];
  final List<String> availableColors = [
    'Orange',
    'Black',
    'Red',
    'Yellow',
    'Blue',
  ];

  @override
  void onInit() {
    super.onInit();
    _loadProductDetails();
  }

  void _loadProductDetails() {
    try {
      isLoading.value = true;

      // Get product from arguments or load mock data
      final args = Get.arguments;
      if (args != null && args is Product) {
        product.value = args;
      } else {
        // Mock product data
        product.value = Product(
          id: '1',
          name: "Men's Harrington Jacket",
          description:
              'Built for life and made to last, this full-zip corduroy jacket is part of our Nike Life collection. The spacious fit gives you plenty of room to layer underneath, while the soft corduroy keeps it casual and timeless.',
          price: 148,
          rating: 4.5,
          imageUrl:
              'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=400&h=500&fit=crop',
          category: 'Jackets',
          inStock: true,
          reviewCount: 213,
          images: [
            'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=400&h=500&fit=crop',
            'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=400&h=500&fit=crop',
          ],
        );
      }

      selectedImages.value =
          product.value?.images ?? [product.value?.imageUrl ?? ''];
      _loadReviews();
    } finally {
      isLoading.value = false;
    }
  }

  void _loadReviews() {
    reviews.addAll([
      Review(
        id: '1',
        userName: 'Alex Morgan',
        rating: 4,
        comment:
            'Great! translates the heritage, creativity, and innovation into a streetcar collection. From simple tees to distinctive accessories.',
        date: '10days ago',
        verified: true,
      ),
      Review(
        id: '2',
        userName: 'Alex Morgan',
        rating: 3,
        comment:
            'Great! translates the heritage, creativity, and innovation into a streetcar collection. From simple tees to distinctive accessories.',
        date: '10days ago',
        verified: true,
      ),
    ]);
  }

  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
    Get.snackbar(
      isFavorite.value ? 'Added to Favorites' : 'Removed from Favorites',
      isFavorite.value
          ? '${product.value?.name} has been added to your favorites'
          : '${product.value?.name} has been removed from favorites',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void selectSize(String size) {
    selectedSize.value = size;
  }

  void selectColor(String color) {
    selectedColor.value = color;
  }

  void increaseQuantity() {
    if (quantity.value < 10) {
      quantity.value++;
    }
  }

  void decreaseQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  Color getColorFromName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'orange':
        return Colors.orange;
      case 'black':
        return Colors.black;
      case 'red':
        return Colors.red;
      case 'yellow':
        return Colors.amber;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'lemon':
        return const Color(0xFFE8E060);
      default:
        return Colors.grey;
    }
  }

  void addToCart() {
    if (product.value == null) return;

    try {
      final cartController = Get.find<CartController>();
      final productToAdd = product.value!.copyWith(quantity: quantity.value);
      cartController.addToCart(
        productToAdd,
        quantity: quantity.value,
        size: selectedSize.value,
        color: selectedColor.value,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add to cart',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void buyNow() {
    addToCart();
    Get.toNamed('/cart');
  }
}
