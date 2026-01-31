import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce/config/app_styles.dart';
import 'package:ecommerce/config/app_colors.dart';
import 'package:ecommerce/controllers/profile_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Profile Avatar
              _buildProfileAvatar(isDark),
              const SizedBox(height: 30),
              // Profile Info
              _buildProfileInfo(isDark),
              const SizedBox(height: 30),
              // Menu Items
              _buildMenuItem(
                icon: Icons.location_on_outlined,
                title: 'Address',
                onTap: () => Get.toNamed('/address'),
                isDark: isDark,
              ),
              _buildMenuItem(
                icon: Icons.favorite_outline,
                title: 'Wishlist',
                onTap: () => Get.toNamed('/wishlist'),
                isDark: isDark,
              ),
              _buildMenuItem(
                icon: Icons.payment_outlined,
                title: 'Payment',
                onTap: () => Get.toNamed('/payment'),
                isDark: isDark,
              ),
              _buildMenuItem(
                icon: Icons.help_outline,
                title: 'Help',
                onTap: () {},
                isDark: isDark,
              ),
              _buildMenuItem(
                icon: Icons.support_agent_outlined,
                title: 'Support',
                onTap: () {},
                isDark: isDark,
              ),
              const SizedBox(height: 30),
              // Sign Out
              GestureDetector(
                onTap: controller.signOut,
                child: Text(
                  'Sign Out',
                  style: AppStyles.bodyMedium.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(isDark),
    );
  }

  Widget _buildProfileAvatar(bool isDark) {
    return Obx(() {
      final profile = controller.userProfile.value;
      return Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isDark ? const Color(0xFF3A3A3A) : const Color(0xFFE0E0E0),
            width: 3,
          ),
        ),
        child: ClipOval(
          child: profile?.avatarUrl != null
              ? CachedNetworkImage(
                  imageUrl: profile!.avatarUrl!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: isDark
                        ? const Color(0xFF3A3A3A)
                        : const Color(0xFFF5F5F5),
                    child: const Icon(Icons.person, size: 50),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: isDark
                        ? const Color(0xFF3A3A3A)
                        : const Color(0xFFF5F5F5),
                    child: const Icon(Icons.person, size: 50),
                  ),
                )
              : Container(
                  color: isDark
                      ? const Color(0xFF3A3A3A)
                      : const Color(0xFFF5F5F5),
                  child: const Icon(Icons.person, size: 50),
                ),
        ),
      );
    });
  }

  Widget _buildProfileInfo(bool isDark) {
    return Obx(() {
      final profile = controller.userProfile.value;
      if (profile == null) return const SizedBox.shrink();

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            // Name
            _buildInfoRow(
              label: profile.name,
              onEdit: () => _showEditDialog('Name', profile.name, (value) {
                controller.updateProfile(name: value);
              }),
              isDark: isDark,
            ),
            const Divider(height: 24),
            // Email
            _buildInfoRow(
              label: profile.email,
              onEdit: () => _showEditDialog('Email', profile.email, (value) {
                controller.updateProfile(email: value);
              }),
              isDark: isDark,
            ),
            const Divider(height: 24),
            // Phone
            _buildInfoRow(
              label: profile.phone,
              onEdit: () => _showEditDialog('Phone', profile.phone, (value) {
                controller.updateProfile(phone: value);
              }),
              isDark: isDark,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildInfoRow({
    required String label,
    required VoidCallback onEdit,
    required bool isDark,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppStyles.bodyMedium.copyWith(
              color: isDark ? AppColors.darkText : AppColors.lightText,
            ),
          ),
        ),
        GestureDetector(
          onTap: onEdit,
          child: Text(
            'Edit',
            style: AppStyles.bodySmall.copyWith(
              color: AppColors.lightPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDark ? AppColors.darkText : AppColors.lightText,
              size: 22,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
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

  void _showEditDialog(
    String field,
    String currentValue,
    Function(String) onSave,
  ) {
    final textController = TextEditingController(text: currentValue);

    Get.dialog(
      AlertDialog(
        title: Text('Edit $field'),
        content: TextField(
          controller: textController,
          decoration: InputDecoration(
            hintText: 'Enter $field',
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              onSave(textController.text);
              Get.back();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(bool isDark) {
    return BottomNavigationBar(
      currentIndex: 3,
      type: BottomNavigationBarType.fixed,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      selectedItemColor: AppColors.lightPrimary,
      unselectedItemColor: isDark
          ? AppColors.darkTextSecondary
          : AppColors.lightTextSecondary,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_outlined),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long_outlined),
          label: '',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
      ],
      onTap: (index) {
        if (index == 0) {
          Get.offAllNamed('/home');
        } else if (index == 1) {
          Get.toNamed('/notifications');
        } else if (index == 2) {
          Get.toNamed('/orders');
        }
      },
    );
  }
}
