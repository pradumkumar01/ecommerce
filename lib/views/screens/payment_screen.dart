import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce/config/app_styles.dart';
import 'package:ecommerce/config/app_colors.dart';
import 'package:ecommerce/controllers/profile_controller.dart';

class PaymentScreen extends StatelessWidget {
  PaymentScreen({Key? key}) : super(key: key);

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
          'Payment',
          style: AppStyles.headlineLarge.copyWith(
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cards Section
            Text(
              'Cards',
              style: AppStyles.headlineMedium.copyWith(
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => _buildCardsList(isDark)),
            const SizedBox(height: 24),
            // Add Card Button
            GestureDetector(
              onTap: () => Get.toNamed('/add-card'),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF2D2D2D)
                      : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.lightPrimary.withOpacity(0.5),
                    style: BorderStyle.solid,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_circle_outline,
                      color: AppColors.lightPrimary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Add Card',
                      style: AppStyles.bodyMedium.copyWith(
                        color: AppColors.lightPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            // PayPal Section
            Text(
              'PayPal',
              style: AppStyles.headlineMedium.copyWith(
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => _buildPayPalList(isDark)),
          ],
        ),
      ),
    );
  }

  Widget _buildCardsList(bool isDark) {
    if (controller.paymentCards.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            'No cards added',
            style: AppStyles.bodyMedium.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ),
      );
    }

    return Column(
      children: controller.paymentCards.map((card) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: _getCardGradient(card.cardType),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    _getCardLogo(card.cardType),
                    width: 50,
                    height: 30,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.credit_card,
                        color: Colors.white,
                        size: 30,
                      );
                    },
                  ),
                  if (card.isDefault)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Default',
                        style: AppStyles.bodySmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                _formatCardNumber(card.cardNumber),
                style: AppStyles.headlineMedium.copyWith(
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CARD HOLDER',
                        style: AppStyles.bodySmall.copyWith(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        card.cardholderName.toUpperCase(),
                        style: AppStyles.bodyMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EXPIRES',
                        style: AppStyles.bodySmall.copyWith(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        card.expiryDate,
                        style: AppStyles.bodyMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  if (!card.isDefault) ...[
                    GestureDetector(
                      onTap: () => controller.setDefaultCard(card.id),
                      child: Text(
                        'Set as Default',
                        style: AppStyles.bodySmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                  ],
                  GestureDetector(
                    onTap: () => _showDeleteCardConfirmation(card.id),
                    child: Text(
                      'Remove',
                      style: AppStyles.bodySmall.copyWith(
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPayPalList(bool isDark) {
    if (controller.paypalAccounts.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF003087),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'PP',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'Connect your PayPal account',
                style: AppStyles.bodyMedium.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
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
      );
    }

    return Column(
      children: controller.paypalAccounts.map((account) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
            border: account.isDefault
                ? Border.all(color: AppColors.lightPrimary, width: 2)
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF003087),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'PP',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.email,
                      style: AppStyles.bodyMedium.copyWith(
                        color: isDark
                            ? AppColors.darkText
                            : AppColors.lightText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (account.isDefault)
                      Text(
                        'Default',
                        style: AppStyles.bodySmall.copyWith(
                          color: AppColors.lightPrimary,
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                Icons.check_circle,
                color: account.isDefault ? AppColors.lightPrimary : Colors.grey,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  LinearGradient _getCardGradient(String cardType) {
    switch (cardType.toLowerCase()) {
      case 'visa':
        return const LinearGradient(
          colors: [Color(0xFF1A1F71), Color(0xFF2D3595)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'mastercard':
        return const LinearGradient(
          colors: [Color(0xFFEB001B), Color(0xFFF79E1B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'amex':
        return const LinearGradient(
          colors: [Color(0xFF006FCF), Color(0xFF00A1E0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFF4A4A4A), Color(0xFF6A6A6A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  String _getCardLogo(String cardType) {
    switch (cardType.toLowerCase()) {
      case 'visa':
        return 'assets/images/visa_logo.png';
      case 'mastercard':
        return 'assets/images/mastercard_logo.png';
      case 'amex':
        return 'assets/images/amex_logo.png';
      default:
        return 'assets/images/card_logo.png';
    }
  }

  String _formatCardNumber(String number) {
    // Show only last 4 digits
    final masked = '**** **** **** ${number.substring(number.length - 4)}';
    return masked;
  }

  void _showDeleteCardConfirmation(String cardId) {
    Get.dialog(
      AlertDialog(
        title: const Text('Remove Card'),
        content: const Text('Are you sure you want to remove this card?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              controller.deletePaymentCard(cardId);
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}
