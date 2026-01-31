import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce/config/app_styles.dart';
import 'package:ecommerce/config/app_colors.dart';
import 'package:ecommerce/controllers/auth_controller.dart';
import 'package:ecommerce/views/widgets/common_widgets.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppStyles.spacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppStyles.spacingXLarge),
              // Logo
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.primaryGradient,
                  ),
                  child: Center(
                    child: Text(
                      'SH',
                      style: AppStyles.displaySmall.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppStyles.spacingXLarge),
              // Title
              Obx(
                () => Text(
                  authController.isLoginMode.value
                      ? 'Welcome Back'
                      : 'Create Account',
                  style: AppStyles.displaySmall.copyWith(
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppStyles.spacingSmall),
              // Subtitle
              Obx(
                () => Text(
                  authController.isLoginMode.value
                      ? 'Sign in to your account to continue'
                      : 'Create a new account to get started',
                  style: AppStyles.bodyMedium.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppStyles.spacingXXLarge),
              // Error Message
              Obx(
                () => authController.errorMessage.value.isNotEmpty
                    ? Container(
                        padding: const EdgeInsets.all(AppStyles.spacingSmall),
                        margin: const EdgeInsets.only(
                          bottom: AppStyles.spacing,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkError
                              : AppColors.lightError,
                          borderRadius: BorderRadius.circular(
                            AppStyles.radiusMedium,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: AppColors.white,
                              size: AppStyles.iconSmall,
                            ),
                            const SizedBox(width: AppStyles.spacingSmall),
                            Expanded(
                              child: Text(
                                authController.errorMessage.value,
                                style: AppStyles.bodySmall.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              // Name Field (Register only)
              Obx(
                () => authController.isLoginMode.value
                    ? const SizedBox.shrink()
                    : Column(
                        children: [
                          CustomTextField(
                            label: 'Full Name',
                            hint: 'John Doe',
                            controller: authController.nameController,
                            prefixIcon: Icons.person_outline,
                            keyboardType: TextInputType.name,
                          ),
                          const SizedBox(height: AppStyles.spacing),
                        ],
                      ),
              ),
              // Email Field
              CustomTextField(
                label: 'Email Address',
                hint: 'example@email.com',
                controller: authController.emailController,
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: AppStyles.spacing),
              // Password Field
              CustomTextField(
                label: 'Password',
                hint: 'Enter your password',
                controller: authController.passwordController,
                prefixIcon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: AppStyles.spacing),
              // Confirm Password (Register only)
              Obx(
                () => authController.isLoginMode.value
                    ? const SizedBox.shrink()
                    : Column(
                        children: [
                          CustomTextField(
                            label: 'Confirm Password',
                            hint: 'Confirm your password',
                            controller:
                                authController.confirmPasswordController,
                            prefixIcon: Icons.lock_outline,
                            isPassword: true,
                          ),
                          const SizedBox(height: AppStyles.spacing),
                        ],
                      ),
              ),
              // Remember me / Forgot password
              Obx(
                () => authController.isLoginMode.value
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(value: false, onChanged: (value) {}),
                              Text(
                                'Remember me',
                                style: AppStyles.bodySmall.copyWith(
                                  color: isDark
                                      ? AppColors.darkText
                                      : AppColors.lightText,
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Forgot Password?',
                              style: AppStyles.bodySmall.copyWith(
                                color: isDark
                                    ? AppColors.darkPrimary
                                    : AppColors.lightPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: AppStyles.spacingXLarge),
              // Submit Button
              Obx(
                () => CustomButton(
                  text: authController.isLoginMode.value
                      ? 'Sign In'
                      : 'Create Account',
                  onPressed: () {},
                  isLoading: authController.isLoading.value,
                  height: AppStyles.buttonHeight,
                ),
              ),
              const SizedBox(height: AppStyles.spacing),
              // Divider
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.lightBorder,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppStyles.spacingSmall,
                    ),
                    child: Text(
                      'OR',
                      style: AppStyles.bodySmall.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.lightBorder,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppStyles.spacing),
              // Social Login Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialButton(
                    icon: Icons.g_mobiledata,
                    onPressed: () {},
                  ),
                  const SizedBox(width: AppStyles.spacingLarge),
                  _buildSocialButton(icon: Icons.facebook, onPressed: () {}),
                  const SizedBox(width: AppStyles.spacingLarge),
                  _buildSocialButton(icon: Icons.apple, onPressed: () {}),
                ],
              ),
              const SizedBox(height: AppStyles.spacingXLarge),
              // Toggle Mode
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                    () => Text(
                      authController.isLoginMode.value
                          ? "Don't have an account? "
                          : 'Already have an account? ',
                      style: AppStyles.bodySmall.copyWith(
                        color: isDark
                            ? AppColors.darkText
                            : AppColors.lightText,
                      ),
                    ),
                  ),
                  Obx(
                    () => TextButton(
                      onPressed: authController.toggleMode,
                      child: Text(
                        authController.isLoginMode.value
                            ? 'Sign Up'
                            : 'Sign In',
                        style: AppStyles.bodySmall.copyWith(
                          color: isDark
                              ? AppColors.darkPrimary
                              : AppColors.lightPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(AppStyles.radiusLarge),
      child: Container(
        padding: const EdgeInsets.all(AppStyles.spacingSmall),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE0E0E0)),
          borderRadius: BorderRadius.circular(AppStyles.radiusLarge),
        ),
        child: Icon(icon, size: AppStyles.iconMedium),
      ),
    );
  }
}
