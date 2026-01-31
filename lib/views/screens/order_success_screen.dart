import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce/config/app_styles.dart';
import 'package:ecommerce/config/app_colors.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              // Success Illustration
              _buildSuccessIllustration(isDark),
              const SizedBox(height: 40),
              // Success Message
              Text(
                'Order Placed\nSuccessfully',
                textAlign: TextAlign.center,
                style: AppStyles.headlineLarge.copyWith(
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'You will receive an email confirmation',
                textAlign: TextAlign.center,
                style: AppStyles.bodyMedium.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
              const Spacer(),
              // See Order Details Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.offAllNamed('/orders');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'See Order details',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessIllustration(bool isDark) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background circles/decorations
        Positioned(
          top: 0,
          right: 20,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 30,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          top: 40,
          left: 50,
          child: Icon(
            Icons.star,
            color: Colors.amber.withOpacity(0.5),
            size: 20,
          ),
        ),
        Positioned(
          bottom: 60,
          right: 40,
          child: Icon(
            Icons.star,
            color: Colors.purple.withOpacity(0.5),
            size: 16,
          ),
        ),
        // Main illustration container
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3E0),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Shopping bag
              Container(
                width: 120,
                height: 140,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB74D),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 30,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 4),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.white,
                      size: 50,
                    ),
                  ],
                ),
              ),
              // Checkmark badge
              Positioned(
                bottom: 20,
                right: 30,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.lightPrimary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 30),
                ),
              ),
            ],
          ),
        ),
        // Confetti/decorations
        Positioned(top: -10, left: 60, child: _buildConfetti(Colors.purple)),
        Positioned(top: 20, right: 50, child: _buildConfetti(Colors.orange)),
        Positioned(bottom: 40, left: 40, child: _buildConfetti(Colors.blue)),
        Positioned(bottom: 10, right: 60, child: _buildConfetti(Colors.green)),
      ],
    );
  }

  Widget _buildConfetti(Color color) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color.withOpacity(0.6),
        shape: BoxShape.circle,
      ),
    );
  }
}
