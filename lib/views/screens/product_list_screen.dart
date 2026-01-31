import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce/config/app_styles.dart';
import 'package:ecommerce/config/app_colors.dart';
import 'package:ecommerce/config/app_constants.dart';
import 'package:ecommerce/controllers/product_list_controller.dart';
import 'package:ecommerce/views/widgets/common_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductListController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Products',
        showBackButton: true,
        actions: [
          Obx(
            () => IconButton(
              icon: const Icon(Icons.tune),
              onPressed: controller.toggleFilters,
              color: controller.showFilters.value
                  ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                  : null,
            ),
          ),
        ],
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const LoadingWidget()
            : Column(
                children: [
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.all(AppStyles.spacing),
                    child: _buildSearchBar(controller, isDark),
                  ),
                  // Filters
                  if (controller.showFilters.value)
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Divider(
                            color: isDark
                                ? AppColors.darkBorder
                                : AppColors.lightBorder,
                          ),
                          _buildFilterSection(controller, isDark),
                          Divider(
                            color: isDark
                                ? AppColors.darkBorder
                                : AppColors.lightBorder,
                          ),
                        ],
                      ),
                    ),
                  // Products Grid
                  Expanded(
                    child: controller.filteredProducts.isEmpty
                        ? EmptyStateWidget(
                            title: 'No Products Found',
                            subtitle:
                                'Try adjusting your filters or search query',
                            icon: Icons.shopping_bag_outlined,
                            onAction: controller.resetFilters,
                            actionButtonText: 'Reset Filters',
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.all(AppStyles.spacing),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.75,
                                  crossAxisSpacing: AppStyles.spacing,
                                  mainAxisSpacing: AppStyles.spacing,
                                ),
                            itemCount: controller.filteredProducts.length,
                            itemBuilder: (context, index) {
                              final product =
                                  controller.filteredProducts[index];
                              return _buildProductCard(product, isDark);
                            },
                          ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSearchBar(ProductListController controller, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(AppStyles.radiusMedium),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search products...',
          hintStyle: AppStyles.bodyMedium.copyWith(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.search,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: AppStyles.spacingSmall,
          ),
        ),
        onChanged: controller.updateSearchQuery,
      ),
    );
  }

  Widget _buildFilterSection(ProductListController controller, bool isDark) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppStyles.spacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sort
            Text('Sort By', style: AppStyles.titleMedium),
            const SizedBox(height: AppStyles.spacingSmall),
            Obx(
              () => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppStyles.radiusMedium),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                  ),
                ),
                child: DropdownButton<String>(
                  value: controller.sortBy.value,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: controller.sortOptions
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.updateSortOption(value);
                    }
                  },
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppStyles.spacing,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppStyles.spacingLarge),

            // Category
            Text('Category', style: AppStyles.titleMedium),
            const SizedBox(height: AppStyles.spacingSmall),
            Obx(
              () => Wrap(
                spacing: AppStyles.spacingSmall,
                children: controller.categories.map((category) {
                  final isSelected =
                      controller.selectedCategory.value == category;
                  return FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      controller.updateCategory(category);
                    },
                    backgroundColor: isDark
                        ? AppColors.darkSurface
                        : AppColors.lightBackground,
                    selectedColor: isDark
                        ? AppColors.darkPrimary
                        : AppColors.lightPrimary,
                    labelStyle: AppStyles.bodySmall.copyWith(
                      color: isSelected
                          ? AppColors.white
                          : (isDark ? AppColors.darkText : AppColors.lightText),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppStyles.spacingLarge),

            // Price Range
            Text('Price Range', style: AppStyles.titleMedium),
            const SizedBox(height: AppStyles.spacingSmall),
            Obx(
              () => Column(
                children: [
                  Text(
                    '\$${controller.priceRange.value.start.toStringAsFixed(0)} - \$${controller.priceRange.value.end.toStringAsFixed(0)}',
                    style: AppStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  RangeSlider(
                    values: controller.priceRange.value,
                    min: 0,
                    max: 500,
                    onChanged: (RangeValues values) {
                      controller.updatePriceRange(values);
                    },
                    activeColor: isDark
                        ? AppColors.darkPrimary
                        : AppColors.lightPrimary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppStyles.spacingLarge),

            // Reset Button
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: 'Reset Filters',
                onPressed: controller.resetFilters,
                isOutlined: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(dynamic product, bool isDark) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppConstants.productDetailRoute);
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppStyles.radiusMedium),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppStyles.radiusMedium),
                  topRight: Radius.circular(AppStyles.radiusMedium),
                ),
                color: isDark
                    ? AppColors.darkSurface
                    : AppColors.lightBackground,
              ),
              child: Stack(
                children: [
                  Center(
                    child: CachedNetworkImage(
                      imageUrl: product.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      placeholder: (context, url) => const LoadingWidget(),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.image_outlined, size: AppStyles.iconLarge),
                    ),
                  ),
                  // Stock Badge
                  if (!product.inStock)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.black.withOpacity(0.5),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(AppStyles.radiusMedium),
                            topRight: Radius.circular(AppStyles.radiusMedium),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Out of Stock',
                            style: AppStyles.labelMedium.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: AppStyles.spacingSmall,
                    right: AppStyles.spacingSmall,
                    child: Container(
                      padding: const EdgeInsets.all(AppStyles.spacingXSmall),
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.favorite_outline,
                        size: AppStyles.iconSmall,
                        color: AppColors.lightError,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(AppStyles.spacingSmall),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.labelLarge,
                  ),
                  const SizedBox(height: AppStyles.spacingXSmall),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: AppStyles.iconSmall,
                        color: AppColors.starColor,
                      ),
                      const SizedBox(width: 4),
                      Text('${product.rating}', style: AppStyles.labelSmall),
                      const SizedBox(width: 4),
                      Text(
                        '(${product.reviewCount ?? 0})',
                        style: AppStyles.labelSmall.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppStyles.spacingSmall),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product.price}',
                        style: AppStyles.labelLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.darkPrimary
                              : AppColors.lightPrimary,
                        ),
                      ),
                      if (product.inStock)
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.add_circle_outline),
                          iconSize: AppStyles.iconMedium,
                          padding: EdgeInsets.zero,
                        ),
                    ],
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
