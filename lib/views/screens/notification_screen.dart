import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce/config/app_styles.dart';
import 'package:ecommerce/config/app_colors.dart';
import 'package:ecommerce/controllers/notification_controller.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({Key? key}) : super(key: key);

  final NotificationController controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
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
        centerTitle: true,
        title: Text(
          'Notifications',
          style: AppStyles.headlineSmall.copyWith(
            color: isDark ? AppColors.darkText : AppColors.lightText,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!controller.hasNotifications) {
          return _buildEmptyState(isDark, context);
        }

        return _buildNotificationsList(isDark, context);
      }),
      bottomNavigationBar: _buildBottomNavBar(isDark),
    );
  }

  Widget _buildEmptyState(bool isDark, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Bell Icon
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_outlined,
              size: 60,
              color: Color(0xFFFFB74D),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Notification yet',
            style: AppStyles.headlineSmall.copyWith(
              color: isDark ? AppColors.darkText : AppColors.lightText,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Get.toNamed('/category-list');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lightPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Explore Categories',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(bool isDark, BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.notifications.length,
      itemBuilder: (context, index) {
        final notification = controller.notifications[index];
        return _buildNotificationCard(notification, isDark);
      },
    );
  }

  Widget _buildNotificationCard(NotificationModel notification, bool isDark) {
    IconData iconData;
    Color iconBgColor;
    Color iconColor;

    switch (notification.type) {
      case 'order_placed':
        iconData = Icons.local_shipping_outlined;
        iconBgColor = const Color(0xFFE8F5E9);
        iconColor = const Color(0xFF4CAF50);
        break;
      case 'order_cancelled':
        iconData = Icons.notifications_outlined;
        iconBgColor = const Color(0xFFF5F5F5);
        iconColor = const Color(0xFF9E9E9E);
        break;
      case 'order_confirmed':
        iconData = Icons.notifications_outlined;
        iconBgColor = const Color(0xFFF5F5F5);
        iconColor = const Color(0xFF9E9E9E);
        break;
      default:
        iconData = Icons.notifications_outlined;
        iconBgColor = const Color(0xFFF5F5F5);
        iconColor = const Color(0xFF9E9E9E);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.message,
                  style: AppStyles.bodySmall.copyWith(
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(bool isDark) {
    return BottomNavigationBar(
      currentIndex: 1,
      type: BottomNavigationBarType.fixed,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      selectedItemColor: AppColors.lightPrimary,
      unselectedItemColor: isDark
          ? AppColors.darkTextSecondary
          : AppColors.lightTextSecondary,
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
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
      ],
      onTap: (index) {
        if (index == 0) {
          Get.offAllNamed('/home');
        } else if (index == 2) {
          Get.toNamed('/orders');
        }
      },
    );
  }
}
