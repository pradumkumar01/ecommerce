import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce/models/product_model.dart';

class ProductListController extends GetxController {
  final RxList<Product> allProducts = <Product>[].obs;
  final RxList<Product> filteredProducts = <Product>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = 'All'.obs;
  final RxString sortBy = 'Popularity'.obs;
  final RxBool showFilters = false.obs;

  final List<String> sortOptions = [
    'Popularity',
    'Price: Low to High',
    'Price: High to Low',
    'Newest',
    'Rating',
  ];
  final List<String> categories = [
    'All',
    'Electronics',
    'Fashion',
    'Home & Garden',
    'Sports',
    'Books',
  ];
  final Rx<RangeValues> priceRange = Rx<RangeValues>(const RangeValues(0, 500));

  @override
  void onInit() {
    super.onInit();
    _initializeProducts();
  }

  void _initializeProducts() {
    isLoading.value = true;
    try {
      // Mock data - same as in HomeController
      allProducts.addAll([
        Product(
          id: '1',
          name: 'Wireless Headphones',
          description:
              'High-quality wireless headphones with noise cancellation',
          price: 99.99,
          rating: 4.5,
          imageUrl: 'https://via.placeholder.com/300?text=Headphones',
          category: 'Electronics',
          inStock: true,
          reviewCount: 128,
        ),
        Product(
          id: '2',
          name: 'Smart Watch',
          description: 'Feature-rich smartwatch with health tracking',
          price: 199.99,
          rating: 4.7,
          imageUrl: 'https://via.placeholder.com/300?text=SmartWatch',
          category: 'Electronics',
          inStock: true,
          reviewCount: 256,
        ),
        Product(
          id: '3',
          name: 'Running Shoes',
          description: 'Comfortable running shoes for everyday use',
          price: 89.99,
          rating: 4.3,
          imageUrl: 'https://via.placeholder.com/300?text=Shoes',
          category: 'Fashion',
          inStock: true,
          reviewCount: 89,
        ),
        Product(
          id: '4',
          name: 'Coffee Maker',
          description: 'Programmable coffee maker with timer',
          price: 45.99,
          rating: 4.2,
          imageUrl: 'https://via.placeholder.com/300?text=CoffeeMaker',
          category: 'Home & Garden',
          inStock: true,
          reviewCount: 67,
        ),
        Product(
          id: '5',
          name: 'Yoga Mat',
          description: 'Non-slip yoga mat for workouts',
          price: 29.99,
          rating: 4.4,
          imageUrl: 'https://via.placeholder.com/300?text=YogaMat',
          category: 'Sports',
          inStock: true,
          reviewCount: 145,
        ),
        Product(
          id: '6',
          name: 'Flutter Guide',
          description: 'Complete guide to Flutter development',
          price: 34.99,
          rating: 4.6,
          imageUrl: 'https://via.placeholder.com/300?text=Book',
          category: 'Books',
          inStock: true,
          reviewCount: 234,
        ),
        Product(
          id: '7',
          name: 'Portable Charger',
          description: '20000mAh portable power bank',
          price: 59.99,
          rating: 4.4,
          imageUrl: 'https://via.placeholder.com/300?text=PowerBank',
          category: 'Electronics',
          inStock: true,
          reviewCount: 178,
        ),
        Product(
          id: '8',
          name: 'Winter Jacket',
          description: 'Warm waterproof winter jacket',
          price: 149.99,
          rating: 4.5,
          imageUrl: 'https://via.placeholder.com/300?text=Jacket',
          category: 'Fashion',
          inStock: false,
          reviewCount: 96,
        ),
      ]);
      _applyFiltersAndSort();
    } finally {
      isLoading.value = false;
    }
  }

  void _applyFiltersAndSort() {
    // Filter by category
    List<Product> filtered = allProducts.where((product) {
      final categoryMatch =
          selectedCategory.value == 'All' ||
          product.category == selectedCategory.value;
      final priceMatch =
          product.price >= priceRange.value.start &&
          product.price <= priceRange.value.end;
      final searchMatch =
          searchQuery.isEmpty ||
          product.name.toLowerCase().contains(searchQuery.value.toLowerCase());
      return categoryMatch && priceMatch && searchMatch;
    }).toList();

    // Sort
    switch (sortBy.value) {
      case 'Price: Low to High':
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price: High to Low':
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Rating':
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Newest':
        // Assume newer items are at the end
        filtered = filtered.reversed.toList();
        break;
      case 'Popularity':
      default:
        // Sort by review count
        filtered.sort(
          (a, b) => (b.reviewCount ?? 0).compareTo(a.reviewCount ?? 0),
        );
    }

    filteredProducts.value = filtered;
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    _applyFiltersAndSort();
  }

  void updateCategory(String category) {
    selectedCategory.value = category;
    _applyFiltersAndSort();
  }

  void updateSortOption(String option) {
    sortBy.value = option;
    _applyFiltersAndSort();
  }

  void updatePriceRange(RangeValues values) {
    priceRange.value = values;
    _applyFiltersAndSort();
  }

  void toggleFilters() {
    showFilters.toggle();
  }

  void resetFilters() {
    searchQuery.value = '';
    selectedCategory.value = 'All';
    priceRange.value = const RangeValues(0, 500);
    sortBy.value = 'Popularity';
    _applyFiltersAndSort();
  }
}
