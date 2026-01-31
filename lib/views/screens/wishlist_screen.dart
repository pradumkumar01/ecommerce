import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce/config/app_styles.dart';
import 'package:ecommerce/config/app_colors.dart';
import 'package:ecommerce/controllers/profile_controller.dart';

class WishlistScreen extends StatelessWidget {
  WishlistScreen({Key? key}) : super(key: key);

  final ProfileController controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          'Wishlist',
          style: AppStyles.headlineLarge.copyWith(
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.wishlistCategories.isEmpty) {
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
                  'Your wishlist is empty',
                  style: AppStyles.bodyLarge.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Start adding items you love!',
                  style: AppStyles.bodyMedium.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Get.offAllNamed('/home'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightPrimary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    'Browse Products',
                    style: AppStyles.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: controller.wishlistCategories.length,
          itemBuilder: (context, index) {
            final category = controller.wishlistCategories[index];
            return _buildCategoryItem(category, isDark);
          },
        );
      }),
    );
  }

  Widget _buildCategoryItem(dynamic category, bool isDark) {
    return GestureDetector(
      onTap: () => Get.toNamed('/favourites', arguments: category.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Category Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF3A3A3A)
                    : const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  _getCategoryIcon(category.iconName),
                  size: 28,
                  color: AppColors.lightPrimary,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Category Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: AppStyles.bodyLarge.copyWith(
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${category.productCount} Products',
                    style: AppStyles.bodySmall.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // Arrow Icon
            Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String iconName) {
    switch (iconName) {
      case 'favorite':
        return Icons.favorite;
      case 'tshirt':
        return Icons.checkroom;
      case 'pants':
        return Icons.straighten;
      case 'shoes':
        return Icons.sports_gymnastics;
      case 'accessories':
        return Icons.watch;
      case 'bags':
        return Icons.shopping_bag;
      default:
        return Icons.category;
    }
  }
}
