import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce/config/app_styles.dart';
import 'package:ecommerce/config/app_colors.dart';
import 'package:ecommerce/controllers/notification_controller.dart';
import 'package:ecommerce/models/notification_model.dart';

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
          'Notifications',
          style: AppStyles.headlineSmall.copyWith(
            color: isDark ? AppColors.darkText : AppColors.lightText,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Obx(() {
            if (controller.hasNotifications) {
              return IconButton(
                icon: const Icon(Icons.done_all, size: 22),
                color: AppColors.lightPrimary,
                onPressed: () => controller.markAllAsRead(),
                tooltip: 'Mark all as read',
              );
            }
            return const SizedBox.shrink();
          }),
        ],
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Bell Icon
            Container(
              height: 120,
              width: 120,
              decoration: const BoxDecoration(
                color: Color(0xFFFFF3E0),
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed('/category-list');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsList(bool isDark, BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.refreshNotifications,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.notifications.length,
        itemBuilder: (context, index) {
          final notification = controller.notifications[index];
          return Dismissible(
            key: Key(notification.id),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (_) => controller.deleteNotification(notification.id),
            child: _buildNotificationCard(notification, isDark),
          );
        },
      ),
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
        iconData = Icons.cancel_outlined;
        iconBgColor = const Color(0xFFFFEBEE);
        iconColor = const Color(0xFFF44336);
        break;
      case 'order_confirmed':
        iconData = Icons.check_circle_outline;
        iconBgColor = const Color(0xFFE3F2FD);
        iconColor = const Color(0xFF2196F3);
        break;
      case 'order_shipped':
        iconData = Icons.local_shipping_outlined;
        iconBgColor = const Color(0xFFE8F5E9);
        iconColor = const Color(0xFF4CAF50);
        break;
      case 'order_delivered':
        iconData = Icons.inventory_2_outlined;
        iconBgColor = const Color(0xFFE8F5E9);
        iconColor = const Color(0xFF4CAF50);
        break;
      case 'promo':
        iconData = Icons.local_offer_outlined;
        iconBgColor = const Color(0xFFFFF3E0);
        iconColor = const Color(0xFFFF9800);
        break;
      default:
        iconData = Icons.notifications_outlined;
        iconBgColor = isDark
            ? const Color(0xFF3A3A3A)
            : const Color(0xFFF5F5F5);
        iconColor = isDark
            ? AppColors.darkTextSecondary
            : AppColors.lightTextSecondary;
    }

    return GestureDetector(
      onTap: () {
        if (!notification.isRead) {
          controller.markAsRead(notification.id);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notification.isRead
              ? (isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF5F5F5))
              : (isDark ? const Color(0xFF3A3A3A) : const Color(0xFFE8E8E8)),
          borderRadius: BorderRadius.circular(12),
          border: !notification.isRead
              ? Border.all(
                  color: AppColors.lightPrimary.withOpacity(0.3),
                  width: 1,
                )
              : null,
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: AppStyles.bodySmall.copyWith(
                            color: isDark
                                ? AppColors.darkText
                                : AppColors.lightText,
                            fontWeight: notification.isRead
                                ? FontWeight.w500
                                : FontWeight.w600,
                          ),
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.lightPrimary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: AppStyles.bodySmall.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getTimeAgo(notification.createdAt),
                    style: AppStyles.bodySmall.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
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
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ''),
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
