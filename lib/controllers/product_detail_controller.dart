import 'package:get/get.dart';
import 'package:ecommerce/models/product_model.dart';

class ProductDetailController extends GetxController {
  final Rx<Product?> product = Rx<Product?>(null);
  final RxInt quantity = 1.obs;
  final RxBool isFavorite = false.obs;
  final RxBool isLoading = false.obs;
  final RxList<Product> relatedProducts = <Product>[].obs;
  final RxList<String> selectedImages = <String>[].obs;
  final RxInt selectedImageIndex = 0.obs;
  final RxDouble selectedRating = 0.0.obs;
  final RxList<Review> reviews = <Review>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadProductDetails();
  }

  void _loadProductDetails() {
    try {
      isLoading.value = true;

      // Mock product data
      product.value = Product(
        id: '1',
        name: 'Wireless Headphones Pro',
        description:
            'Premium quality wireless headphones with active noise cancellation and 30-hour battery life',
        price: 99.99,
        rating: 4.5,
        imageUrl: 'https://via.placeholder.com/400?text=Headphones',
        category: 'Electronics',
        inStock: true,
        reviewCount: 128,
        images: [
          'https://via.placeholder.com/400?text=Headphones1',
          'https://via.placeholder.com/400?text=Headphones2',
          'https://via.placeholder.com/400?text=Headphones3',
        ],
        sku: 'WHP-2024-001',
      );

      selectedImages.value =
          product.value?.images ?? [product.value?.imageUrl ?? ''];
      _loadRelatedProducts();
      _loadReviews();
    } finally {
      isLoading.value = false;
    }
  }

  void _loadRelatedProducts() {
    relatedProducts.addAll([
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
    ]);
  }

  void _loadReviews() {
    reviews.addAll([
      Review(
        id: '1',
        userName: 'John Doe',
        rating: 5,
        comment: 'Amazing product! Great sound quality and battery life.',
        date: '2 days ago',
        verified: true,
      ),
      Review(
        id: '2',
        userName: 'Jane Smith',
        rating: 4,
        comment: 'Good product but a bit pricey. Noise cancellation is great.',
        date: '1 week ago',
        verified: true,
      ),
      Review(
        id: '3',
        userName: 'Mike Johnson',
        rating: 4,
        comment: 'Very comfortable to wear. Sound quality is excellent.',
        date: '2 weeks ago',
        verified: true,
      ),
    ]);
  }

  void incrementQuantity() {
    quantity.value++;
  }

  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  void setQuantity(int value) {
    if (value > 0) {
      quantity.value = value;
    }
  }

  void toggleFavorite() {
    isFavorite.toggle();
  }

  void selectImage(int index) {
    selectedImageIndex.value = index;
  }

  void addToCart() {
    if (product.value != null) {
      // Add to cart logic
      Get.snackbar(
        'Added to Cart',
        '${product.value!.name} x${quantity.value} added to cart',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void buyNow() {
    if (product.value != null) {
      // Buy now logic - navigate to checkout
      Get.snackbar(
        'Processing',
        'Proceeding to checkout...',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

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
    required this.verified,
  });
}
