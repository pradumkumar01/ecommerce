import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce/config/app_styles.dart';
import 'package:ecommerce/config/app_colors.dart';
import 'package:ecommerce/controllers/checkout_controller.dart';
import 'package:ecommerce/controllers/cart_controller.dart';
import 'package:ecommerce/views/widgets/common_widgets.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CheckoutController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(title: 'Checkout', showBackButton: true),
      body: Obx(
        () => Column(
          children: [
            // Step Indicator
            _buildStepIndicator(controller, isDark),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppStyles.spacing),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (controller.currentStep.value == 0)
                      _buildShippingStep(controller, isDark)
                    else if (controller.currentStep.value == 1)
                      _buildPaymentStep(controller, isDark)
                    else
                      _buildReviewStep(controller, isDark),
                  ],
                ),
              ),
            ),
            // Navigation Buttons
            _buildNavigationButtons(controller, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(CheckoutController controller, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(AppStyles.spacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              controller.steps.length,
              (index) => Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index <= controller.currentStep.value
                            ? (isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.lightPrimary)
                            : (isDark
                                  ? AppColors.darkBorder
                                  : AppColors.lightBorder),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: AppStyles.labelMedium.copyWith(
                            color: index <= controller.currentStep.value
                                ? AppColors.white
                                : (isDark
                                      ? AppColors.darkText
                                      : AppColors.lightText),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    if (index < controller.steps.length - 1)
                      Expanded(
                        child: Container(
                          height: 2,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          color: index < controller.currentStep.value
                              ? (isDark
                                    ? AppColors.darkPrimary
                                    : AppColors.lightPrimary)
                              : (isDark
                                    ? AppColors.darkBorder
                                    : AppColors.lightBorder),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppStyles.spacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: controller.steps
                .map((step) => Text(step, style: AppStyles.labelMedium))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingStep(CheckoutController controller, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Shipping Address', style: AppStyles.headlineMedium),
        const SizedBox(height: AppStyles.spacing),
        CustomTextField(
          label: 'Full Name',
          controller: controller.fullNameController,
          prefixIcon: Icons.person_outline,
        ),
        const SizedBox(height: AppStyles.spacing),
        CustomTextField(
          label: 'Email Address',
          controller: controller.emailController,
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: AppStyles.spacing),
        CustomTextField(
          label: 'Phone Number',
          controller: controller.phoneController,
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: AppStyles.spacing),
        CustomTextField(
          label: 'Street Address',
          controller: controller.addressController,
          prefixIcon: Icons.location_on_outlined,
        ),
        const SizedBox(height: AppStyles.spacing),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                label: 'City',
                controller: controller.cityController,
              ),
            ),
            const SizedBox(width: AppStyles.spacing),
            Expanded(
              child: CustomTextField(
                label: 'State',
                controller: controller.stateController,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppStyles.spacing),
        CustomTextField(
          label: 'ZIP Code',
          controller: controller.zipCodeController,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: AppStyles.spacingXLarge),
        // Shipping Options
        Text('Shipping Method', style: AppStyles.titleMedium),
        const SizedBox(height: AppStyles.spacingSmall),
        _buildShippingOptionCard(
          'Standard Shipping',
          '5-7 business days',
          'Free',
          isDark,
        ),
        const SizedBox(height: AppStyles.spacingSmall),
        _buildShippingOptionCard(
          'Express Shipping',
          '2-3 business days',
          '\$9.99',
          isDark,
        ),
        const SizedBox(height: AppStyles.spacingSmall),
        _buildShippingOptionCard(
          'Overnight Shipping',
          'Next day',
          '\$29.99',
          isDark,
        ),
      ],
    );
  }

  Widget _buildShippingOptionCard(
    String title,
    String time,
    String price,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppStyles.spacing),
      decoration: BoxDecoration(
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        borderRadius: BorderRadius.circular(AppStyles.radiusMedium),
      ),
      child: Row(
        children: [
          Radio(
            value: title,
            groupValue: 'Standard Shipping',
            onChanged: (val) {},
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  time,
                  style: AppStyles.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: AppStyles.titleMedium.copyWith(
              color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentStep(CheckoutController controller, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payment Method', style: AppStyles.headlineMedium),
        const SizedBox(height: AppStyles.spacing),
        Obx(
          () => Column(
            children: [
              _buildPaymentMethodCard(
                'credit_card',
                'Credit Card',
                Icons.credit_card,
                controller,
                isDark,
              ),
              const SizedBox(height: AppStyles.spacingSmall),
              _buildPaymentMethodCard(
                'debit_card',
                'Debit Card',
                Icons.credit_card,
                controller,
                isDark,
              ),
              const SizedBox(height: AppStyles.spacingSmall),
              _buildPaymentMethodCard(
                'google_pay',
                'Google Pay',
                Icons.account_balance_wallet,
                controller,
                isDark,
              ),
              const SizedBox(height: AppStyles.spacingSmall),
              _buildPaymentMethodCard(
                'apple_pay',
                'Apple Pay',
                Icons.account_balance_wallet,
                controller,
                isDark,
              ),
              const SizedBox(height: AppStyles.spacingSmall),
              _buildPaymentMethodCard(
                'paypal',
                'PayPal',
                Icons.account_balance_wallet,
                controller,
                isDark,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppStyles.spacingXLarge),
        if (controller.selectedPaymentMethod.value == 'credit_card' ||
            controller.selectedPaymentMethod.value == 'debit_card')
          Column(
            children: [
              CustomTextField(
                label: 'Card Number',
                hint: '1234 5678 9012 3456',
                prefixIcon: Icons.credit_card,
              ),
              const SizedBox(height: AppStyles.spacing),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(label: 'Expiry Date', hint: 'MM/YY'),
                  ),
                  const SizedBox(width: AppStyles.spacing),
                  Expanded(
                    child: CustomTextField(label: 'CVV', hint: '123'),
                  ),
                ],
              ),
              const SizedBox(height: AppStyles.spacing),
              CustomTextField(label: 'Cardholder Name', hint: 'John Doe'),
            ],
          ),
      ],
    );
  }

  Widget _buildPaymentMethodCard(
    String value,
    String label,
    IconData icon,
    CheckoutController controller,
    bool isDark,
  ) {
    final isSelected = controller.selectedPaymentMethod.value == value;
    return GestureDetector(
      onTap: () => controller.selectPaymentMethod(value),
      child: Container(
        padding: const EdgeInsets.all(AppStyles.spacing),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppStyles.radiusMedium),
          color: isSelected
              ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                    .withOpacity(0.1)
              : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected
                  ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                  : (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary),
            ),
            const SizedBox(width: AppStyles.spacing),
            Icon(icon),
            const SizedBox(width: AppStyles.spacingSmall),
            Text(
              label,
              style: AppStyles.titleMedium.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewStep(CheckoutController controller, bool isDark) {
    final cartController = Get.find<CartController>();

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Review', style: AppStyles.headlineMedium),
          const SizedBox(height: AppStyles.spacing),
          // Shipping Info
          _buildReviewSection('Shipping Address', isDark, [
            '${controller.fullNameController.text}',
            '${controller.addressController.text}',
            '${controller.cityController.text}, ${controller.stateController.text} ${controller.zipCodeController.text}',
            controller.phoneController.text,
          ]),
          const SizedBox(height: AppStyles.spacing),
          // Payment Info
          _buildReviewSection('Payment Method', isDark, [
            controller.selectedPaymentMethod.value
                .replaceAll('_', ' ')
                .toUpperCase(),
          ]),
          const SizedBox(height: AppStyles.spacingXLarge),
          // Order Summary
          Text('Order Summary', style: AppStyles.headlineMedium),
          const SizedBox(height: AppStyles.spacing),
          Container(
            padding: const EdgeInsets.all(AppStyles.spacing),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightBackground,
              borderRadius: BorderRadius.circular(AppStyles.radiusMedium),
            ),
            child: Column(
              children: [
                _buildReviewRow(
                  'Subtotal',
                  '\$${cartController.subtotal.value.toStringAsFixed(2)}',
                  isDark,
                ),
                const SizedBox(height: AppStyles.spacingSmall),
                _buildReviewRow(
                  'Shipping',
                  cartController.shippingCost.value == 0
                      ? 'Free'
                      : '\$${cartController.shippingCost.value.toStringAsFixed(2)}',
                  isDark,
                ),
                const SizedBox(height: AppStyles.spacingSmall),
                _buildReviewRow(
                  'Tax',
                  '\$${cartController.taxAmount.value.toStringAsFixed(2)}',
                  isDark,
                ),
                const SizedBox(height: AppStyles.spacing),
                Divider(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
                const SizedBox(height: AppStyles.spacing),
                _buildReviewRow(
                  'Total',
                  '\$${cartController.total.value.toStringAsFixed(2)}',
                  isDark,
                  isTotal: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppStyles.spacingXLarge),
          // Terms
          Obx(
            () => Row(
              children: [
                Checkbox(
                  value: controller.agreeToTerms.value,
                  onChanged: (value) {
                    controller.agreeToTerms.value = value ?? false;
                  },
                ),
                Expanded(
                  child: Text(
                    'I agree to the Terms and Conditions',
                    style: AppStyles.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewSection(String title, bool isDark, List<String> items) {
    return Container(
      padding: const EdgeInsets.all(AppStyles.spacing),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(AppStyles.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppStyles.spacingSmall),
          ...items
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(item, style: AppStyles.bodySmall),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  Widget _buildReviewRow(
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

  Widget _buildNavigationButtons(CheckoutController controller, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(AppStyles.spacing),
      child: Obx(
        () => Row(
          children: [
            if (controller.currentStep.value > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: controller.previousStep,
                  child: const Text('Back'),
                ),
              ),
            if (controller.currentStep.value > 0)
              const SizedBox(width: AppStyles.spacing),
            Expanded(
              child: CustomButton(
                text:
                    controller.currentStep.value == controller.steps.length - 1
                    ? 'Place Order'
                    : 'Next',
                onPressed:
                    controller.currentStep.value == controller.steps.length - 1
                    ? controller.placeOrder
                    : controller.nextStep,
                isLoading: controller.isLoading.value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
