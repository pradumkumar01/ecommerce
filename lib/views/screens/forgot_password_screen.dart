import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce/config/app_colors.dart';
import 'package:ecommerce/config/app_styles.dart';
import 'package:ecommerce/controllers/auth_controller.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final authController = Get.find<AuthController>();
  final emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: isDarkMode
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? AppColors.darkText : AppColors.lightText,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!_emailSent) ...[
                Text(
                  'Forgot Password',
                  style: AppStyles.displayMedium.copyWith(
                    color: isDarkMode
                        ? AppColors.darkText
                        : AppColors.lightText,
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'Enter your email address and we\'ll send you a link to reset your password.',
                  style: AppStyles.bodyMedium.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 30),
                // Email TextField
                _buildTextField(
                  controller: emailController,
                  label: 'Enter Email address',
                  hintText: 'your@email.com',
                  isDarkMode: isDarkMode,
                ),
                const SizedBox(height: 30),
                // Continue Button
                _buildPrimaryButton(
                  label: 'Continue',
                  onPressed: () {
                    setState(() {
                      _emailSent = true;
                    });
                    authController.resetPassword(emailController.text);
                  },
                ),
              ] else ...[
                const SizedBox(height: 40),
                Center(
                  child: Icon(
                    Icons.mail_outline,
                    size: 80,
                    color: AppColors.lightPrimary,
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'We Sent you an Email to reset your password.',
                  textAlign: TextAlign.center,
                  style: AppStyles.displaySmall.copyWith(
                    color: isDarkMode
                        ? AppColors.darkText
                        : AppColors.lightText,
                  ),
                ),
                const SizedBox(height: 60),
                // Return to Login Button
                _buildPrimaryButton(
                  label: 'Return to Login',
                  onPressed: () {
                    Get.offNamed('/login');
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required bool isDarkMode,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppStyles.bodyMedium.copyWith(
            color: isDarkMode ? AppColors.darkText : AppColors.lightText,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppStyles.bodySmall.copyWith(
              color: isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
            filled: true,
            fillColor: isDarkMode ? Color(0xFF3A3A3A) : Color(0xFFF5F5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          style: AppStyles.bodyMedium.copyWith(
            color: isDarkMode ? AppColors.darkText : AppColors.lightText,
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          label,
          style: AppStyles.bodyMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
