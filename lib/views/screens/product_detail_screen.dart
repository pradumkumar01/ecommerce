import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce/config/app_styles.dart';
import 'package:ecommerce/config/app_colors.dart';
import 'package:ecommerce/controllers/product_detail_controller.dart';
import 'package:ecommerce/controllers/cart_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductDetailController());
    final cartController = Get.find<CartController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.product.value == null) {
          return const Center(child: Text('Product not found'));
        }

        return CustomScrollView(
          slivers: [
            // Product Image with AppBar
            SliverToBoxAdapter(child: _buildProductImage(controller, isDark)),
            // Product Details
            SliverToBoxAdapter(
              child: _buildProductDetails(controller, isDark, context),
            ),
          ],
        );
      }),
      bottomNavigationBar: Obx(() {
        if (controller.product.value == null) return const SizedBox.shrink();
        return _buildBottomBar(controller, cartController, isDark);
      }),
    );
  }

  Widget _buildProductImage(ProductDetailController controller, bool isDark) {
    return Stack(
      children: [
        // Product Image
        Container(
          height: 380,
          width: double.infinity,
          color: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF5F5F5),
          child: CachedNetworkImage(
            imageUrl: controller.product.value?.imageUrl ?? '',
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) =>
                const Icon(Icons.image_not_supported_outlined, size: 60),
          ),
        ),
        // Back button and favorite
        Positioned(
          top: MediaQuery.of(Get.context!).padding.top + 8,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCircleButton(
                icon: Icons.arrow_back_ios_new,
                onTap: () => Get.back(),
                isDark: isDark,
              ),
              Obx(
                () => _buildCircleButton(
                  icon: controller.isFavorite.value
                      ? Icons.favorite
                      : Icons.favorite_outline,
                  onTap: controller.toggleFavorite,
                  isDark: isDark,
                  iconColor: controller.isFavorite.value ? Colors.red : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isDark,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF3A3A3A) : Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 20,
          color:
              iconColor ?? (isDark ? AppColors.darkText : AppColors.lightText),
        ),
      ),
    );
  }

  Widget _buildProductDetails(
    ProductDetailController controller,
    bool isDark,
    BuildContext context,
  ) {
    final product = controller.product.value!;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Name
          Text(
            product.name,
            style: AppStyles.headlineMedium.copyWith(
              color: isDark ? AppColors.darkText : AppColors.lightText,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),

          // Price
          Text(
            '\$${product.price.toStringAsFixed(0)}',
            style: AppStyles.headlineSmall.copyWith(
              color: AppColors.lightPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // Size Selector
          _buildSizeSelector(controller, isDark, context),
          const SizedBox(height: 20),

          // Color Selector
          _buildColorSelector(controller, isDark, context),
          const SizedBox(height: 20),

          // Quantity Selector
          _buildQuantitySelector(controller, isDark),
          const SizedBox(height: 24),

          // Description
          Text(
            product.description,
            style: AppStyles.bodySmall.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),

          // Shipping & Returns
          _buildShippingInfo(isDark),
          const SizedBox(height: 24),

          // Reviews Section
          _buildReviewsSection(controller, isDark),
        ],
      ),
    );
  }

  Widget _buildSizeSelector(
    ProductDetailController controller,
    bool isDark,
    BuildContext context,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Size',
          style: AppStyles.bodyMedium.copyWith(
            color: isDark ? AppColors.darkText : AppColors.lightText,
            fontWeight: FontWeight.w500,
          ),
        ),
        GestureDetector(
          onTap: () => _showSizeBottomSheet(controller, isDark, context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Obx(
                  () => Text(
                    controller.selectedSize.value,
                    style: AppStyles.bodySmall.copyWith(
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildColorSelector(
    ProductDetailController controller,
    bool isDark,
    BuildContext context,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Color',
          style: AppStyles.bodyMedium.copyWith(
            color: isDark ? AppColors.darkText : AppColors.lightText,
            fontWeight: FontWeight.w500,
          ),
        ),
        GestureDetector(
          onTap: () => _showColorBottomSheet(controller, isDark, context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Obx(
                  () => Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: controller.getColorFromName(
                        controller.selectedColor.value,
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? Colors.white24 : Colors.black12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuantitySelector(
    ProductDetailController controller,
    bool isDark,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Quantity',
          style: AppStyles.bodyMedium.copyWith(
            color: isDark ? AppColors.darkText : AppColors.lightText,
            fontWeight: FontWeight.w500,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              // Decrease button
              GestureDetector(
                onTap: controller.decreaseQuantity,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.lightPrimary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.remove,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
              // Quantity
              Obx(
                () => Container(
                  width: 50,
                  alignment: Alignment.center,
                  child: Text(
                    '${controller.quantity.value}',
                    style: AppStyles.bodyMedium.copyWith(
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              // Increase button
              GestureDetector(
                onTap: controller.increaseQuantity,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.lightPrimary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShippingInfo(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Shipping & Returns',
          style: AppStyles.bodyMedium.copyWith(
            color: isDark ? AppColors.darkText : AppColors.lightText,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Free standard shipping and free 60-day returns',
          style: AppStyles.bodySmall.copyWith(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsSection(ProductDetailController controller, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reviews',
          style: AppStyles.bodyMedium.copyWith(
            color: isDark ? AppColors.darkText : AppColors.lightText,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),

        // Rating Summary
        Row(
          children: [
            Text(
              '4.5',
              style: AppStyles.headlineLarge.copyWith(
                color: isDark ? AppColors.darkText : AppColors.lightText,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ratings',
                  style: AppStyles.bodySmall.copyWith(
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '213 Reviews',
                  style: AppStyles.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Reviews List
        ...controller.reviews
            .take(2)
            .map((review) => _buildReviewCard(review, isDark)),
      ],
    );
  }

  Widget _buildReviewCard(dynamic review, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: isDark
                    ? const Color(0xFF3A3A3A)
                    : const Color(0xFFE0E0E0),
                child: Text(
                  review.userName[0],
                  style: TextStyle(
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: AppStyles.bodySmall.copyWith(
                        color: isDark
                            ? AppColors.darkText
                            : AppColors.lightText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          index < review.rating
                              ? Icons.star
                              : Icons.star_border,
                          size: 14,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review.comment,
            style: AppStyles.bodySmall.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            review.date,
            style: AppStyles.bodySmall.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(
    ProductDetailController controller,
    CartController cartController,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Price
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\$${controller.product.value?.price.toStringAsFixed(0) ?? '0'}',
                    style: AppStyles.headlineSmall.copyWith(
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Add to Bag button
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () => controller.addToCart(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Add to Bag',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSizeBottomSheet(
    ProductDetailController controller,
    bool isDark,
    BuildContext context,
  ) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Size',
                  style: AppStyles.headlineSmall.copyWith(
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Icon(
                    Icons.close,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...controller.availableSizes
                .map(
                  (size) => Obx(() {
                    final isSelected = controller.selectedSize.value == size;
                    return GestureDetector(
                      onTap: () {
                        controller.selectSize(size);
                        Get.back();
                      },
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.lightPrimary
                              : (isDark
                                    ? const Color(0xFF2D2D2D)
                                    : const Color(0xFFF5F5F5)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              size,
                              style: AppStyles.bodyMedium.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : (isDark
                                          ? AppColors.darkText
                                          : AppColors.lightText),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (isSelected) ...[
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }),
                )
                .toList(),
            const SizedBox(height: 16),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showColorBottomSheet(
    ProductDetailController controller,
    bool isDark,
    BuildContext context,
  ) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Color',
                  style: AppStyles.headlineSmall.copyWith(
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Icon(
                    Icons.close,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...controller.availableColors
                .map(
                  (colorName) => Obx(() {
                    final isSelected =
                        controller.selectedColor.value == colorName;
                    final color = controller.getColorFromName(colorName);
                    return GestureDetector(
                      onTap: () {
                        controller.selectColor(colorName);
                        Get.back();
                      },
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.lightPrimary
                              : (isDark
                                    ? const Color(0xFF2D2D2D)
                                    : const Color(0xFFF5F5F5)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black12,
                                  width: 2,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              colorName,
                              style: AppStyles.bodyMedium.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : (isDark
                                          ? AppColors.darkText
                                          : AppColors.lightText),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            if (isSelected)
                              const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 20,
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                )
                .toList(),
            const SizedBox(height: 16),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
