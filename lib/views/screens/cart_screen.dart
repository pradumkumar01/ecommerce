import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce/config/app_styles.dart';
import 'package:ecommerce/config/app_colors.dart';
import 'package:ecommerce/config/app_constants.dart';
import 'package:ecommerce/controllers/cart_controller.dart';
import 'package:ecommerce/views/widgets/common_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CartController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Shopping Cart',
        showBackButton: true,
        actions: [
          Obx(
            () => IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: controller.cartItems.isEmpty
                  ? null
                  : () {
                      Get.dialog(
                        AlertDialog(
                          title: const Text('Clear Cart'),
                          content: const Text(
                            'Are you sure you want to clear your cart?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                controller.clearCart();
                                Get.back();
                              },
                              child: const Text('Clear'),
                            ),
                          ],
                        ),
                      );
                    },
            ),
          ),
        ],
      ),
      body: Obx(
        () => controller.cartItems.isEmpty
            ? EmptyStateWidget(
                title: 'Your Cart is Empty',
                subtitle: 'Add items to your cart and come back',
                icon: Icons.shopping_cart_outlined,
                onAction: () => Get.toNamed(AppConstants.homeRoute),
                actionButtonText: 'Continue Shopping',
              )
            : Column(
                children: [
                  // Cart Items
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(AppStyles.spacing),
                      itemCount: controller.cartItems.length,
                      itemBuilder: (context, index) {
                        final cartItem = controller.cartItems[index];
                        return _buildCartItemCard(cartItem, controller, isDark);
                      },
                    ),
                  ),
                  // Summary
                  _buildCartSummary(controller, isDark),
                ],
              ),
      ),
      bottomNavigationBar: Obx(
        () => controller.cartItems.isEmpty
            ? const SizedBox.shrink()
            : Container(
                padding: const EdgeInsets.all(AppStyles.spacing),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurface
                      : AppColors.lightSurface,
                  boxShadow: AppStyles.shadowListMedium,
                ),
                child: CustomButton(
                  text: 'Proceed to Checkout',
                  onPressed: controller.proceedToCheckout,
                ),
              ),
      ),
    );
  }

  Widget _buildCartItemCard(
    dynamic cartItem,
    CartController controller,
    bool isDark,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppStyles.spacing),
      child: Padding(
        padding: const EdgeInsets.all(AppStyles.spacing),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppStyles.radiusMedium),
                  child: CachedNetworkImage(
                    imageUrl: cartItem.product.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const LoadingWidget(),
                    errorWidget: (context, url, error) =>
                        Icon(Icons.image_outlined, size: AppStyles.iconLarge),
                  ),
                ),
                const SizedBox(width: AppStyles.spacing),
                // Product Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cartItem.product.name,
                        style: AppStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppStyles.spacingSmall),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${cartItem.product.price}',
                            style: AppStyles.titleMedium.copyWith(
                              color: isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.lightPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              controller.removeFromCart(cartItem.product.id);
                            },
                            child: Icon(
                              Icons.close,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppStyles.spacing),
            // Quantity Control
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
                borderRadius: BorderRadius.circular(AppStyles.radiusMedium),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () =>
                        controller.decrementQuantity(cartItem.product.id),
                    icon: const Icon(Icons.remove),
                    iconSize: AppStyles.iconSmall,
                    padding: const EdgeInsets.all(4),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        '${cartItem.quantity}',
                        style: AppStyles.labelLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        controller.incrementQuantity(cartItem.product.id),
                    icon: const Icon(Icons.add),
                    iconSize: AppStyles.iconSmall,
                    padding: const EdgeInsets.all(4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppStyles.spacingSmall),
            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Subtotal:', style: AppStyles.bodyMedium),
                Text(
                  '\$${cartItem.total.toStringAsFixed(2)}',
                  style: AppStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartSummary(CartController controller, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppStyles.spacing),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightBackground,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Promo Code
          TextField(
            decoration: InputDecoration(
              hintText: 'Enter promo code',
              hintStyle: AppStyles.bodySmall.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
              suffixIcon: TextButton(
                onPressed: () {},
                child: Text(
                  'Apply',
                  style: AppStyles.labelMedium.copyWith(
                    color: isDark
                        ? AppColors.darkPrimary
                        : AppColors.lightPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppStyles.radiusMedium),
                borderSide: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppStyles.radiusMedium),
                borderSide: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppStyles.spacing),
          // Summary Items
          Obx(
            () => Column(
              children: [
                _buildSummaryRow(
                  'Subtotal',
                  '\$${controller.subtotal.value.toStringAsFixed(2)}',
                  isDark,
                ),
                const SizedBox(height: AppStyles.spacingSmall),
                _buildSummaryRow(
                  'Shipping',
                  controller.shippingCost.value == 0
                      ? 'Free'
                      : '\$${controller.shippingCost.value.toStringAsFixed(2)}',
                  isDark,
                ),
                const SizedBox(height: AppStyles.spacingSmall),
                _buildSummaryRow(
                  'Tax (${(controller.taxRate.value * 100).toStringAsFixed(0)}%)',
                  '\$${controller.taxAmount.value.toStringAsFixed(2)}',
                  isDark,
                ),
                const SizedBox(height: AppStyles.spacing),
                Divider(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
                const SizedBox(height: AppStyles.spacing),
                _buildSummaryRow(
                  'Total',
                  '\$${controller.total.value.toStringAsFixed(2)}',
                  isDark,
                  isTotal: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value,
    bool isDark, {
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? AppStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)
              : AppStyles.bodyMedium,
        ),
        Text(
          value,
          style: isTotal
              ? AppStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.darkPrimary
                      : AppColors.lightPrimary,
                )
              : AppStyles.bodyMedium,
        ),
      ],
    );
  }
}
