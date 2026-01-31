import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce/config/app_styles.dart';
import 'package:ecommerce/config/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CategoryListScreen extends StatelessWidget {
  const CategoryListScreen({Key? key}) : super(key: key);

  final List<Map<String, String>> categories = const [
    {
      'name': 'Hoodies',
      'image':
          'https://images.unsplash.com/photo-1556821552-5ff63b1c3da7?w=200&h=200&fit=crop',
    },
    {
      'name': 'Accessories',
      'image':
          'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=200&h=200&fit=crop',
    },
    {
      'name': 'Shorts',
      'image':
          'https://images.unsplash.com/photo-1506629082632-b7cc7d1d51d7?w=200&h=200&fit=crop',
    },
    {
      'name': 'Shoes',
      'image':
          'https://images.unsplash.com/photo-1460353581641-37baddab0fa2?w=200&h=200&fit=crop',
    },
    {
      'name': 'Bags',
      'image':
          'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=200&h=200&fit=crop',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          'Shop by Categories',
          style: AppStyles.headlineSmall.copyWith(
            color: isDark ? AppColors.darkText : AppColors.lightText,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return _buildCategoryCard(category, isDark, context);
          },
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    Map<String, String> category,
    bool isDark,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () {
        // Navigate to products in this category
        Get.toNamed('/product-category', arguments: category['name']);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isDark ? Color(0xFF2D2D2D) : Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Category image
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: isDark ? Color(0xFF3A3A3A) : Color(0xFFEBEBEB),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: CachedNetworkImage(
                  imageUrl: category['image']!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: isDark ? Color(0xFF3A3A3A) : Color(0xFFEBEBEB),
                  ),
                ),
              ),
            ),
            // Category name
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  category['name']!,
                  style: AppStyles.headlineSmall.copyWith(
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            // Arrow icon
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Icon(
                Icons.arrow_forward_ios,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
