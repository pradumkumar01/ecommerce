import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce/config/app_styles.dart';
import 'package:ecommerce/config/app_colors.dart';
import 'package:ecommerce/config/app_constants.dart';
import 'package:ecommerce/controllers/home_controller.dart';
import 'package:ecommerce/controllers/auth_controller.dart';
import 'package:ecommerce/controllers/theme_controller.dart';
import 'package:ecommerce/models/product_model.dart';
import 'package:ecommerce/views/widgets/common_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeController = Get.put(HomeController());
    final themeController = Get.find<ThemeController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ShopHub',
          style: AppStyles.headlineLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: Obx(
              () => Icon(
                themeController.isDarkMode.value
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),
            ),
            onPressed: themeController.toggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              _showDrawer(context);
            },
          ),
        ],
        elevation: 0,
      ),
      body: Obx(
        () => homeController.isLoading.value
            ? const LoadingWidget()
            : RefreshIndicator(
                onRefresh: () async {
                  homeController.fetchData();
                },
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppStyles.spacing),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search Bar
                      _buildSearchBar(context),
                      const SizedBox(height: AppStyles.spacingLarge),
                      // Banner
                      _buildBanner(homeController, isDark),
                      const SizedBox(height: AppStyles.spacingLarge),
                      // Categories
                      _buildCategories(homeController, isDark),
                      const SizedBox(height: AppStyles.spacingLarge),
                      // Featured Products
                      _buildFeaturedSection(homeController, isDark),
                      const SizedBox(height: AppStyles.spacingLarge),
                      // All Products
                      _buildAllProductsSection(homeController, isDark, context),
                    ],
                  ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AppConstants.cartRoute);
        },
        child: Obx(
          () => Stack(
            alignment: Alignment.topRight,
            children: [
              const Icon(Icons.shopping_cart_outlined),
              if (homeController.cartItemCount.value > 0)
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: AppColors.lightError,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Text(
                    '${homeController.cartItemCount.value}',
                    style: AppStyles.labelSmall.copyWith(
                      color: AppColors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
        onSubmitted: (query) {
          // Handle search
        },
      ),
    );
  }

  Widget _buildBanner(HomeController homeController, bool isDark) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppStyles.radiusLarge),
        boxShadow: AppStyles.shadowListMedium,
      ),
      child: Stack(
        children: [
          Positioned(
            right: -50,
            top: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white.withOpacity(0.1),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppStyles.spacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Big Sale',
                  style: AppStyles.displaySmall.copyWith(
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: AppStyles.spacingSmall),
                Text(
                  'Get up to 50% off on selected items',
                  style: AppStyles.bodyMedium.copyWith(color: AppColors.white),
                ),
                const SizedBox(height: AppStyles.spacing),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                  ),
                  onPressed: () {},
                  child: Text(
                    'Shop Now',
                    style: AppStyles.labelMedium.copyWith(
                      color: AppColors.lightPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories(HomeController homeController, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Categories', style: AppStyles.headlineMedium),
        const SizedBox(height: AppStyles.spacingSmall),
        Obx(
          () => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: homeController.categories.map((category) {
                final isSelected =
                    homeController.selectedCategory.value == category;
                return Padding(
                  padding: const EdgeInsets.only(right: AppStyles.spacingSmall),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      homeController.selectCategory(category);
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppStyles.radiusMedium,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedSection(HomeController homeController, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Featured Products', style: AppStyles.headlineMedium),
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
        const SizedBox(height: AppStyles.spacingSmall),
        Obx(
          () => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: homeController.featuredProducts
                  .map(
                    (product) => Padding(
                      padding: const EdgeInsets.only(right: AppStyles.spacing),
                      child: _buildProductCard(
                        product,
                        isDark,
                        context: Get.context!,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAllProductsSection(
    HomeController homeController,
    bool isDark,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('All Products', style: AppStyles.headlineMedium),
            TextButton(
              onPressed: () {
                Get.toNamed(AppConstants.productListRoute);
              },
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
        const SizedBox(height: AppStyles.spacingSmall),
        Obx(
          () => homeController.products.isEmpty
              ? EmptyStateWidget(
                  title: 'No Products',
                  subtitle: 'No products found',
                  icon: Icons.shopping_bag_outlined,
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: AppStyles.spacing,
                    mainAxisSpacing: AppStyles.spacing,
                  ),
                  itemCount: homeController.products.length,
                  itemBuilder: (context, index) {
                    return _buildProductCard(
                      homeController.products[index],
                      isDark,
                      context: context,
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildProductCard(
    Product product,
    bool isDark, {
    required BuildContext context,
  }) {
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

  void _showDrawer(BuildContext context) {
    final authController = Get.find<AuthController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(AppStyles.spacing),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppStyles.radiusLarge),
            topRight: Radius.circular(AppStyles.radiusLarge),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Profile'),
              onTap: () {
                Get.back();
                Get.toNamed(AppConstants.profileRoute);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag_outlined),
              title: const Text('Orders'),
              onTap: () {
                Get.back();
                Get.toNamed(AppConstants.ordersRoute);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              onTap: () {
                Get.back();
                Get.toNamed(AppConstants.settingsRoute);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Get.back();
                authController.logout();
              },
            ),
          ],
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppStyles.radiusLarge),
          topRight: Radius.circular(AppStyles.radiusLarge),
        ),
      ),
    );
  }
}
