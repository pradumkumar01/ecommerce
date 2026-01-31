import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce/config/app_styles.dart';
import 'package:ecommerce/config/app_colors.dart';
import 'package:ecommerce/controllers/checkout_controller.dart';
import 'package:ecommerce/controllers/cart_controller.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CheckoutController());
    final cartController = Get.find<CartController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark
            ? AppColors.darkSurface
            : AppColors.lightSurface,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF0F0F0),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
            color: isDark ? AppColors.darkText : AppColors.lightText,
            onPressed: () => Get.back(),
          ),
        ),
        centerTitle: true,
        title: Text(
          'Checkout',
          style: AppStyles.headlineSmall.copyWith(
            color: isDark ? AppColors.darkText : AppColors.lightText,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shipping Address Section
            _buildSectionTitle('Shipping Address', isDark),
            const SizedBox(height: 12),
            Obx(() => _buildAddressCard(controller, isDark)),
            const SizedBox(height: 24),

            // Payment Method Section
            _buildSectionTitle('Payment Method', isDark),
            const SizedBox(height: 12),
            Obx(() => _buildPaymentCard(controller, isDark)),
            const SizedBox(height: 24),

            // Order Summary
            _buildOrderSummary(cartController, isDark),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(controller, cartController, isDark),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: AppStyles.bodySmall.copyWith(
        color: isDark
            ? AppColors.darkTextSecondary
            : AppColors.lightTextSecondary,
        fontSize: 12,
      ),
    );
  }

  Widget _buildAddressCard(CheckoutController controller, bool isDark) {
    final hasAddress = controller.selectedAddress.value != null;

    return GestureDetector(
      onTap: () => _showAddressBottomSheet(controller, isDark),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                hasAddress
                    ? controller.selectedAddress.value!
                    : 'Add Shipping Address',
                style: AppStyles.bodyMedium.copyWith(
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentCard(CheckoutController controller, bool isDark) {
    final hasPayment =
        controller.selectedPaymentMethod.value != null &&
        controller.selectedPaymentMethod.value!.isNotEmpty;

    return GestureDetector(
      onTap: () => _showPaymentBottomSheet(controller, isDark),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            if (hasPayment) ...[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.credit_card,
                  color: Colors.red.shade400,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                hasPayment
                    ? '**** ${controller.selectedPaymentMethod.value}'
                    : 'Add Payment Method',
                style: AppStyles.bodyMedium.copyWith(
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(CartController cartController, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            'Subtotal',
            '\$${cartController.subtotal.value.toStringAsFixed(0)}',
            isDark,
          ),
          const SizedBox(height: 12),
          _buildSummaryRow(
            'Shipping Cost',
            '\$${cartController.shippingCost.value.toStringAsFixed(2)}',
            isDark,
          ),
          const SizedBox(height: 12),
          _buildSummaryRow(
            'Tax',
            '\$${cartController.taxAmount.value.toStringAsFixed(2)}',
            isDark,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(),
          ),
          _buildSummaryRow(
            'Total',
            '\$${cartController.total.value.toStringAsFixed(0)}',
            isDark,
            isTotal: true,
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
          style: AppStyles.bodySmall.copyWith(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: AppStyles.bodyMedium.copyWith(
            color: isDark ? AppColors.darkText : AppColors.lightText,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(
    CheckoutController controller,
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
            // Total
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\$${cartController.total.value.toStringAsFixed(0)}',
                    style: AppStyles.headlineSmall.copyWith(
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Place Order Button
            Expanded(
              flex: 2,
              child: Obx(
                () => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.placeOrder(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          'Place Order',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddressBottomSheet(CheckoutController controller, bool isDark) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF3A3A3A)
                      : const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Shipping Address',
              style: AppStyles.headlineSmall.copyWith(
                color: isDark ? AppColors.darkText : AppColors.lightText,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            // Sample Addresses
            ...controller.savedAddresses
                .map(
                  (address) => GestureDetector(
                    onTap: () {
                      controller.setAddress(address);
                      Get.back();
                    },
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: controller.selectedAddress.value == address
                            ? AppColors.lightPrimary.withOpacity(0.1)
                            : (isDark
                                  ? const Color(0xFF2D2D2D)
                                  : const Color(0xFFF5F5F5)),
                        borderRadius: BorderRadius.circular(12),
                        border: controller.selectedAddress.value == address
                            ? Border.all(
                                color: AppColors.lightPrimary,
                                width: 2,
                              )
                            : null,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: controller.selectedAddress.value == address
                                ? AppColors.lightPrimary
                                : (isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              address,
                              style: AppStyles.bodySmall.copyWith(
                                color: isDark
                                    ? AppColors.darkText
                                    : AppColors.lightText,
                              ),
                            ),
                          ),
                          if (controller.selectedAddress.value == address)
                            Icon(
                              Icons.check_circle,
                              color: AppColors.lightPrimary,
                            ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
            const SizedBox(height: 12),
            // Add New Address Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Get.back();
                  _showNewAddressDialog(controller, isDark);
                },
                icon: const Icon(Icons.add),
                label: const Text('Add New Address'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.lightPrimary,
                  side: BorderSide(color: AppColors.lightPrimary),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showNewAddressDialog(CheckoutController controller, bool isDark) {
    final addressController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Add New Address'),
        content: TextField(
          controller: addressController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Enter your full address',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (addressController.text.isNotEmpty) {
                controller.addNewAddress(addressController.text);
                Get.back();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showPaymentBottomSheet(CheckoutController controller, bool isDark) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF3A3A3A)
                      : const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Payment Method',
              style: AppStyles.headlineSmall.copyWith(
                color: isDark ? AppColors.darkText : AppColors.lightText,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            // Sample Payment Methods
            ...controller.savedPaymentMethods
                .map(
                  (method) => GestureDetector(
                    onTap: () {
                      controller.setPaymentMethod(method);
                      Get.back();
                    },
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: controller.selectedPaymentMethod.value == method
                            ? AppColors.lightPrimary.withOpacity(0.1)
                            : (isDark
                                  ? const Color(0xFF2D2D2D)
                                  : const Color(0xFFF5F5F5)),
                        borderRadius: BorderRadius.circular(12),
                        border: controller.selectedPaymentMethod.value == method
                            ? Border.all(
                                color: AppColors.lightPrimary,
                                width: 2,
                              )
                            : null,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.credit_card,
                              color: Colors.red.shade400,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '**** $method',
                              style: AppStyles.bodyMedium.copyWith(
                                color: isDark
                                    ? AppColors.darkText
                                    : AppColors.lightText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          if (controller.selectedPaymentMethod.value == method)
                            Icon(
                              Icons.check_circle,
                              color: AppColors.lightPrimary,
                            ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
            const SizedBox(height: 12),
            // Add New Payment Method Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Get.back();
                  _showNewPaymentDialog(controller, isDark);
                },
                icon: const Icon(Icons.add),
                label: const Text('Add New Card'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.lightPrimary,
                  side: BorderSide(color: AppColors.lightPrimary),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showNewPaymentDialog(CheckoutController controller, bool isDark) {
    final cardController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Add New Card'),
        content: TextField(
          controller: cardController,
          keyboardType: TextInputType.number,
          maxLength: 4,
          decoration: const InputDecoration(
            hintText: 'Last 4 digits of card',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (cardController.text.length == 4) {
                controller.addNewPaymentMethod(cardController.text);
                Get.back();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
