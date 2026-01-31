import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:get/get.dart';
import 'package:ecommerce/config/app_styles.dart';
import 'package:ecommerce/config/app_colors.dart';
import 'package:ecommerce/controllers/product_detail_controller.dart';
import 'package:ecommerce/views/widgets/common_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductDetailController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Product Details',
        showBackButton: true,
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                controller.isFavorite.value
                    ? Icons.favorite
                    : Icons.favorite_outline,
                color: AppColors.lightError,
              ),
              onPressed: controller.toggleFavorite,
            ),
          ),
          IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {}),
        ],
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const LoadingWidget()
            : controller.product.value == null
            ? const ErrorWidget(message: 'Product not found')
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Carousel
                    _buildImageCarousel(controller, isDark),
                    // Product Info
                    _buildProductInfo(controller, isDark),
                    // Description
                    _buildDescription(controller, isDark),
                    // Specifications
                    _buildSpecifications(controller, isDark),
                    // Reviews Section
                    _buildReviewsSection(controller, isDark),
                    // Related Products
                    _buildRelatedProducts(controller, isDark),
                    const SizedBox(height: AppStyles.spacingLarge),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: Obx(
        () => controller.product.value == null
            ? const SizedBox.shrink()
            : Container(
                padding: const EdgeInsets.all(AppStyles.spacing),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurface
                      : AppColors.lightSurface,
                  boxShadow: AppStyles.shadowListMedium,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'Add to Cart',
                        onPressed: controller.addToCart,
                        isOutlined: true,
                      ),
                    ),
                    const SizedBox(width: AppStyles.spacing),
                    Expanded(
                      child: CustomButton(
                        text: 'Buy Now',
                        onPressed: controller.buyNow,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildImageCarousel(ProductDetailController controller, bool isDark) {
    return Container(
      color: isDark ? AppColors.darkSurface : AppColors.lightBackground,
      child: Column(
        children: [
          // Main Image
          SizedBox(
            height: 300,
            child: Obx(
              () => CachedNetworkImage(
                imageUrl: controller
                    .selectedImages[controller.selectedImageIndex.value],
                fit: BoxFit.contain,
                placeholder: (context, url) => const LoadingWidget(),
                errorWidget: (context, url, error) =>
                    Icon(Icons.image_outlined, size: AppStyles.iconXXLarge),
              ),
            ),
          ),
          const SizedBox(height: AppStyles.spacing),
          // Thumbnail Images
          if (controller.selectedImages.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppStyles.spacing,
              ),
              child: Obx(
                () => Row(
                  children: List.generate(
                    controller.selectedImages.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(
                        right: AppStyles.spacingSmall,
                      ),
                      child: GestureDetector(
                        onTap: () => controller.selectImage(index),
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  controller.selectedImageIndex.value == index
                                  ? (isDark
                                        ? AppColors.darkPrimary
                                        : AppColors.lightPrimary)
                                  : (isDark
                                        ? AppColors.darkBorder
                                        : AppColors.lightBorder),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(
                              AppStyles.radiusMedium,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              AppStyles.radiusMedium,
                            ),
                            child: CachedNetworkImage(
                              imageUrl: controller.selectedImages[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: AppStyles.spacing),
        ],
      ),
    );
  }

  Widget _buildProductInfo(ProductDetailController controller, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(AppStyles.spacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Name
          Text(
            controller.product.value?.name ?? '',
            style: AppStyles.displaySmall,
          ),
          const SizedBox(height: AppStyles.spacingSmall),
          // Rating
          Row(
            children: [
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < (controller.product.value?.rating.toInt() ?? 0)
                        ? Icons.star
                        : Icons.star_outline,
                    color: AppColors.starColor,
                    size: AppStyles.iconMedium,
                  );
                }),
              ),
              const SizedBox(width: AppStyles.spacingSmall),
              Text(
                '${controller.product.value?.rating ?? 0}',
                style: AppStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: AppStyles.spacingSmall),
              Text(
                '(${controller.product.value?.reviewCount ?? 0} reviews)',
                style: AppStyles.bodySmall.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppStyles.spacing),
          // Price and Stock
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Price',
                    style: AppStyles.bodySmall.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  Text(
                    '\$${controller.product.value?.price ?? 0}',
                    style: AppStyles.displayMedium.copyWith(
                      color: isDark
                          ? AppColors.darkPrimary
                          : AppColors.lightPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppStyles.spacing,
                  vertical: AppStyles.spacingSmall,
                ),
                decoration: BoxDecoration(
                  color: controller.product.value?.inStock ?? false
                      ? AppColors.lightSuccess.withOpacity(0.2)
                      : AppColors.lightError.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppStyles.radiusMedium),
                ),
                child: Text(
                  controller.product.value?.inStock ?? false
                      ? 'In Stock'
                      : 'Out of Stock',
                  style: AppStyles.labelMedium.copyWith(
                    color: controller.product.value?.inStock ?? false
                        ? AppColors.lightSuccess
                        : AppColors.lightError,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppStyles.spacing),
          // Quantity Selector
          Text('Quantity', style: AppStyles.titleMedium),
          const SizedBox(height: AppStyles.spacingSmall),
          Obx(
            () => Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
                borderRadius: BorderRadius.circular(AppStyles.radiusMedium),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: controller.decrementQuantity,
                    icon: const Icon(Icons.remove),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        '${controller.quantity.value}',
                        style: AppStyles.titleLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: controller.incrementQuantity,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(ProductDetailController controller, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(AppStyles.spacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Description', style: AppStyles.headlineMedium),
          const SizedBox(height: AppStyles.spacingSmall),
          Text(
            controller.product.value?.description ?? '',
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

  Widget _buildSpecifications(ProductDetailController controller, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(AppStyles.spacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Specifications', style: AppStyles.headlineMedium),
          const SizedBox(height: AppStyles.spacing),
          _buildSpecRow('Brand', 'Premium Audio', isDark),
          _buildSpecRow(
            'Model',
            controller.product.value?.sku ?? 'N/A',
            isDark,
          ),
          _buildSpecRow('Color', 'Black', isDark),
          _buildSpecRow('Warranty', '1 Year', isDark),
          _buildSpecRow('Shipping', 'Free Worldwide', isDark),
        ],
      ),
    );
  }

  Widget _buildSpecRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppStyles.spacingSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppStyles.bodyMedium.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          Text(
            value,
            style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection(ProductDetailController controller, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(AppStyles.spacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Customer Reviews', style: AppStyles.headlineMedium),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See All',
                  style: AppStyles.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.darkPrimary
                        : AppColors.lightPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppStyles.spacing),
          Obx(
            () => Column(
              children: controller.reviews
                  .take(3)
                  .map((review) => _buildReviewCard(review, isDark))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(dynamic review, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  review.userName,
                  style: AppStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    ...List.generate(5, (index) {
                      return Icon(
                        index < review.rating ? Icons.star : Icons.star_outline,
                        color: AppColors.starColor,
                        size: AppStyles.iconSmall,
                      );
                    }),
                    const SizedBox(width: AppStyles.spacingSmall),
                    if (review.verified)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppStyles.spacingSmall,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.lightSuccess.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(
                            AppStyles.radiusSmall,
                          ),
                        ),
                        child: Text(
                          'Verified',
                          style: AppStyles.labelSmall.copyWith(
                            color: AppColors.lightSuccess,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            Text(
              review.date,
              style: AppStyles.bodySmall.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppStyles.spacingSmall),
        Text(
          review.comment,
          style: AppStyles.bodyMedium.copyWith(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: AppStyles.spacing),
        Divider(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        const SizedBox(height: AppStyles.spacing),
      ],
    );
  }

  Widget _buildRelatedProducts(
    ProductDetailController controller,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.all(AppStyles.spacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Related Products', style: AppStyles.headlineMedium),
          const SizedBox(height: AppStyles.spacing),
          Obx(
            () => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: controller.relatedProducts.map((product) {
                  return Padding(
                    padding: const EdgeInsets.only(right: AppStyles.spacing),
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to related product
                      },
                      child: Container(
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            AppStyles.radiusMedium,
                          ),
                          border: Border.all(
                            color: isDark
                                ? AppColors.darkBorder
                                : AppColors.lightBorder,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(
                                  AppStyles.radiusMedium,
                                ),
                                topRight: Radius.circular(
                                  AppStyles.radiusMedium,
                                ),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: product.imageUrl,
                                fit: BoxFit.cover,
                                height: 120,
                                width: 150,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(
                                AppStyles.spacingSmall,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppStyles.labelMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '\$${product.price}',
                                    style: AppStyles.labelMedium.copyWith(
                                      color: isDark
                                          ? AppColors.darkPrimary
                                          : AppColors.lightPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
