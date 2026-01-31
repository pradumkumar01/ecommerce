import 'package:get/get.dart';
import 'package:ecommerce/models/product_model.dart';
import 'package:ecommerce/services/storage_service.dart';

class HomeController extends GetxController {
  final RxList<Product> products = <Product>[].obs;
  final RxList<Product> featuredProducts = <Product>[].obs;
  final RxList<String> categories = <String>[].obs;
  final RxInt cartItemCount = 0.obs;
  final RxBool isLoading = false.obs;
  final RxString selectedCategory = 'All'.obs;
  final RxInt currentBannerIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void fetchData() async {
    try {
      isLoading.value = true;

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock data
      _initializeCategories();
      _initializeProducts();
      _initializeFeaturedProducts();

      // Load cart count from storage
      _updateCartCount();
    } finally {
      isLoading.value = false;
    }
  }

  void _initializeCategories() {
    categories.addAll([
      'All',
      'Electronics',
      'Fashion',
      'Home & Garden',
      'Sports',
      'Books',
    ]);
  }

  void _initializeProducts() {
    products.addAll([
      Product(
        id: '1',
        name: 'Wireless Headphones',
        description: 'High-quality wireless headphones with noise cancellation',
        price: 99.99,
        rating: 4.5,
        imageUrl: 'https://via.placeholder.com/200?text=Headphones',
        category: 'Electronics',
        inStock: true,
      ),
      Product(
        id: '2',
        name: 'Smart Watch',
        description: 'Feature-rich smartwatch with health tracking',
        price: 199.99,
        rating: 4.7,
        imageUrl: 'https://via.placeholder.com/200?text=SmartWatch',
        category: 'Electronics',
        inStock: true,
      ),
      Product(
        id: '3',
        name: 'Running Shoes',
        description: 'Comfortable running shoes for everyday use',
        price: 89.99,
        rating: 4.3,
        imageUrl: 'https://via.placeholder.com/200?text=Shoes',
        category: 'Fashion',
        inStock: true,
      ),
      Product(
        id: '4',
        name: 'Coffee Maker',
        description: 'Programmable coffee maker with timer',
        price: 45.99,
        rating: 4.2,
        imageUrl: 'https://via.placeholder.com/200?text=CoffeeMaker',
        category: 'Home & Garden',
        inStock: true,
      ),
      Product(
        id: '5',
        name: 'Yoga Mat',
        description: 'Non-slip yoga mat for workouts',
        price: 29.99,
        rating: 4.4,
        imageUrl: 'https://via.placeholder.com/200?text=YogaMat',
        category: 'Sports',
        inStock: true,
      ),
      Product(
        id: '6',
        name: 'Flutter Guide',
        description: 'Complete guide to Flutter development',
        price: 34.99,
        rating: 4.6,
        imageUrl: 'https://via.placeholder.com/200?text=Book',
        category: 'Books',
        inStock: true,
      ),
    ]);
  }

  void _initializeFeaturedProducts() {
    featuredProducts.addAll(products.sublist(0, 3));
  }

  void _updateCartCount() {
    final cartData = StorageService.getCartData();
    cartItemCount.value = cartData?.length ?? 0;
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void updateBannerIndex(int index) {
    currentBannerIndex.value = index;
  }

  void updateCartCount(int count) {
    cartItemCount.value = count;
  }
}
