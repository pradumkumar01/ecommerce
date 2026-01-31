import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce/config/app_colors.dart';
import 'package:ecommerce/config/app_styles.dart';
import 'package:ecommerce/controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final authController = Get.find<AuthController>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Tab Bar
            Container(
              color: isDarkMode
                  ? AppColors.darkBackground
                  : AppColors.lightBackground,
              child: TabBar(
                controller: _tabController,
                indicatorColor: AppColors.lightPrimary,
                labelColor: isDarkMode
                    ? AppColors.darkText
                    : AppColors.lightText,
                unselectedLabelColor: isDarkMode
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
                tabs: const [
                  Tab(text: 'Email'),
                  Tab(text: 'Password'),
                ],
              ),
            ),
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildEmailTab(isDarkMode),
                  _buildPasswordTab(isDarkMode),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailTab(bool isDarkMode) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Sign in',
              style: AppStyles.displayMedium.copyWith(
                color: isDarkMode ? AppColors.darkText : AppColors.lightText,
              ),
            ),
            const SizedBox(height: 30),
            // Email TextField
            _buildTextField(
              controller: emailController,
              label: 'Email Address',
              hintText: 'Enter your email',
              isDarkMode: isDarkMode,
            ),
            const SizedBox(height: 30),
            // Continue Button
            _buildPrimaryButton(
              label: 'Continue',
              onPressed: () {
                _tabController.animateTo(1);
              },
            ),
            const SizedBox(height: 16),
            // Sign Up Link
            Center(
              child: GestureDetector(
                onTap: () => Get.toNamed('/register'),
                child: RichText(
                  text: TextSpan(
                    text: 'Don\'t have an Account? ',
                    style: AppStyles.bodyMedium.copyWith(
                      color: isDarkMode
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                    children: [
                      TextSpan(
                        text: 'Create One',
                        style: AppStyles.bodyMedium.copyWith(
                          color: AppColors.lightPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Divider
            _buildDivider(isDarkMode),
            const SizedBox(height: 24),
            // Social Login Buttons
            _buildSocialButton(
              icon: Icons.apple,
              label: 'Continue With Apple',
              isDarkMode: isDarkMode,
              onPressed: () {
                // Apple login logic
              },
            ),
            const SizedBox(height: 12),
            _buildSocialButton(
              icon: Icons.g_translate,
              label: 'Continue With Google',
              isDarkMode: isDarkMode,
              onPressed: () {
                // Google login logic
              },
            ),
            const SizedBox(height: 12),
            _buildSocialButton(
              icon: Icons.facebook,
              label: 'Continue With Facebook',
              isDarkMode: isDarkMode,
              onPressed: () {
                // Facebook login logic
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordTab(bool isDarkMode) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Sign in',
              style: AppStyles.displayMedium.copyWith(
                color: isDarkMode ? AppColors.darkText : AppColors.lightText,
              ),
            ),
            const SizedBox(height: 30),
            // Password TextField
            _buildPasswordTextField(
              controller: passwordController,
              label: 'Password',
              isDarkMode: isDarkMode,
            ),
            const SizedBox(height: 30),
            // Continue Button
            _buildPrimaryButton(
              label: 'Continue',
              onPressed: () {
                // Login logic
                authController.login(
                  emailController.text,
                  passwordController.text,
                );
              },
            ),
            const SizedBox(height: 16),
            // Forgot Password Link
            Center(
              child: GestureDetector(
                onTap: () => Get.toNamed('/forgot-password'),
                child: Text(
                  'Forgot Password? Reset',
                  style: AppStyles.bodyMedium.copyWith(
                    color: AppColors.lightPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
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

  Widget _buildPasswordTextField({
    required TextEditingController controller,
    required String label,
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
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            hintText: 'Enter your password',
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
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
              child: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: isDarkMode
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
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

  Widget _buildDivider(bool isDarkMode) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'Or',
            style: AppStyles.bodySmall.copyWith(
              color: isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required bool isDarkMode,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: isDarkMode ? AppColors.darkText : AppColors.lightText,
        ),
        label: Text(
          label,
          style: AppStyles.bodyMedium.copyWith(
            color: isDarkMode ? AppColors.darkText : AppColors.lightText,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
