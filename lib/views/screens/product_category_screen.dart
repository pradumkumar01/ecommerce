import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce/config/app_styles.dart';
import 'package:ecommerce/config/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductCategoryScreen extends StatefulWidget {
  const ProductCategoryScreen({Key? key}) : super(key: key);

  @override
  State<ProductCategoryScreen> createState() => _ProductCategoryScreenState();
}

class _ProductCategoryScreenState extends State<ProductCategoryScreen> {
  late String categoryName;

  final Map<String, List<Map<String, dynamic>>> categoryProducts = {
    'Hoodies': [
      {
        'name': "Men's Fleece Pullover Hoodie",
        'price': '\$100.00',
        'image':
            'https://images.unsplash.com/photo-1556821552-5ff63b1c3da7?w=300&h=400&fit=crop',
      },
      {
        'name': "Fleece Pullover Skate Hoodie",
        'price': '\$150.97',
        'image':
            'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=300&h=400&fit=crop',
      },
      {
        'name': "Fleece Skate Hoodie",
        'price': '\$110.00',
        'image':
            'https://images.unsplash.com/photo-1542272604-787c62d465d1?w=300&h=400&fit=crop',
      },
      {
        'name': "Men's Ice-Dye Pullover Hoodie",
        'price': '\$128.97',
        'image':
            'https://images.unsplash.com/photo-1556821552-5ff63b1c3da7?w=300&h=400&fit=crop',
      },
      {
        'name': "Men's Vintage Hoodie",
        'price': '\$95.00',
        'image':
            'https://images.unsplash.com/photo-1556821552-5ff63b1c3da7?w=300&h=400&fit=crop',
      },
      {
        'name': "Oversized Fleece Hoodie",
        'price': '\$140.00',
        'image':
            'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=300&h=400&fit=crop',
      },
    ],
    'Accessories': [
      {
        'name': "Classic Baseball Cap",
        'price': '\$35.00',
        'image':
            'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=300&h=400&fit=crop',
      },
      {
        'name': "Wool Beanie",
        'price': '\$45.00',
        'image':
            'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=300&h=400&fit=crop',
      },
      {
        'name': "Premium Scarf",
        'price': '\$65.00',
        'image':
            'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=300&h=400&fit=crop',
      },
      {
        'name': "Sunglasses",
        'price': '\$120.00',
        'image':
            'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=300&h=400&fit=crop',
      },
    ],
    'Shorts': [
      {
        'name': "Athletic Shorts",
        'price': '\$55.00',
        'image':
            'https://images.unsplash.com/photo-1506629082632-b7cc7d1d51d7?w=300&h=400&fit=crop',
      },
      {
        'name': "Cargo Shorts",
        'price': '\$65.00',
        'image':
            'https://images.unsplash.com/photo-1506629082632-b7cc7d1d51d7?w=300&h=400&fit=crop',
      },
      {
        'name': "Denim Shorts",
        'price': '\$75.00',
        'image':
            'https://images.unsplash.com/photo-1506629082632-b7cc7d1d51d7?w=300&h=400&fit=crop',
      },
    ],
    'Shoes': [
      {
        'name': "Sneaker Pro",
        'price': '\$120.00',
        'image':
            'https://images.unsplash.com/photo-1460353581641-37baddab0fa2?w=300&h=400&fit=crop',
      },
      {
        'name': "Basketball Shoes",
        'price': '\$150.00',
        'image':
            'https://images.unsplash.com/photo-1460353581641-37baddab0fa2?w=300&h=400&fit=crop',
      },
      {
        'name': "Running Shoes",
        'price': '\$110.00',
        'image':
            'https://images.unsplash.com/photo-1460353581641-37baddab0fa2?w=300&h=400&fit=crop',
      },
    ],
    'Bags': [
      {
        'name': "Sports Duffel Bag",
        'price': '\$85.00',
        'image':
            'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=300&h=400&fit=crop',
      },
      {
        'name': "Backpack Pro",
        'price': '\$95.00',
        'image':
            'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=300&h=400&fit=crop',
      },
      {
        'name': "Crossbody Bag",
        'price': '\$75.00',
        'image':
            'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=300&h=400&fit=crop',
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    categoryName = Get.arguments ?? 'Hoodies';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final products = categoryProducts[categoryName] ?? [];

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: isDark
            ? AppColors.darkSurface
            : AppColors.lightSurface,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark ? Color(0xFF3A3A3A) : Color(0xFFF0F0F0),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            color: isDark ? AppColors.darkText : AppColors.lightText,
            onPressed: () => Get.back(),
          ),
        ),
        centerTitle: true,
        title: Text(
          '$categoryName (${products.length * 60})',
          style: AppStyles.headlineSmall.copyWith(
            color: isDark ? AppColors.darkText : AppColors.lightText,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 16,
            childAspectRatio: 0.6,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return _buildProductCard(product, isDark, context);
          },
        ),
      ),
    );
  }

  Widget _buildProductCard(
    Map<String, dynamic> product,
    bool isDark,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () {
        // Navigate to product detail screen
        Get.toNamed('/product-detail', arguments: product);
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Color(0xFF2D2D2D) : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image with favorite button
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: product['image'],
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: isDark ? Color(0xFF3A3A3A) : Color(0xFFF5F5F5),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      // Add to favorites logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Added to favorites!'),
                          duration: Duration(milliseconds: 800),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.favorite_outline,
                        color: AppColors.lightPrimary,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Product name and price
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.bodySmall.copyWith(
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product['price'],
                    style: AppStyles.bodySmall.copyWith(
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
