import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/config/app_styles.dart';
import 'package:ecommerce/config/app_colors.dart';
import 'package:ecommerce/controllers/profile_controller.dart';

class FavouritesScreen extends StatelessWidget {
  FavouritesScreen({Key? key}) : super(key: key);

  final ProfileController controller = Get.find<ProfileController>();
  final String? categoryId = Get.arguments;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Get category name
    String categoryName = 'My Favourites';
    if (categoryId != null) {
      final category = controller.wishlistCategories.firstWhereOrNull(
        (c) => c.id == categoryId,
      );
      if (category != null) {
        categoryName = category.name;
      }
    }

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          categoryName,
          style: AppStyles.headlineLarge.copyWith(
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        // Filter items by category if categoryId is provided
        final items = categoryId != null
            ? controller.wishlistItems
                  .where((item) => item.categoryId == categoryId)
                  .toList()
            : controller.wishlistItems;

        if (items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_outline,
                  size: 80,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
                const SizedBox(height: 16),
                Text(
                  'No favourites yet',
                  style: AppStyles.bodyLarge.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Items you like will appear here',
                  style: AppStyles.bodyMedium.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.7,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return _buildProductCard(item, isDark);
          },
        );
      }),
    );
  }

  Widget _buildProductCard(dynamic item, bool isDark) {
    return GestureDetector(
      onTap: () => Get.toNamed('/product-detail', arguments: item.productId),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image with Heart
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  // Product Image
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: item.image,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: isDark
                            ? const Color(0xFF3A3A3A)
                            : const Color(0xFFE0E0E0),
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: isDark
                            ? const Color(0xFF3A3A3A)
                            : const Color(0xFFE0E0E0),
                        child: const Icon(Icons.image, size: 40),
                      ),
                    ),
                  ),
                  // Heart Icon
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => _showRemoveConfirmation(item),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Product Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.name,
                      style: AppStyles.bodyMedium.copyWith(
                        color: isDark
                            ? AppColors.darkText
                            : AppColors.lightText,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: AppStyles.bodyLarge.copyWith(
                        color: AppColors.lightPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRemoveConfirmation(dynamic item) {
    Get.dialog(
      AlertDialog(
        title: const Text('Remove from Favourites'),
        content: Text('Remove "${item.name}" from your favourites?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              controller.removeFromWishlist(item.id);
              Get.back();
              Get.snackbar(
                'Removed',
                '${item.name} removed from favourites',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.grey[800],
                colorText: Colors.white,
                margin: const EdgeInsets.all(20),
                borderRadius: 10,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}
