import 'package:get/get.dart';
import 'package:ecommerce/models/notification_model.dart';

class NotificationController extends GetxController {
  // Observable variables
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // Computed properties
  bool get hasNotifications => notifications.isNotEmpty;
  int get unreadCount => notifications.where((n) => !n.isRead).length;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // Fetch notifications from API (simulated)
  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Simulated notifications data
      notifications.value = [
        NotificationModel(
          id: '1',
          title: 'Order Placed',
          message:
              'Gilbert, you placed an order check your order history for full details',
          type: 'order_placed',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        NotificationModel(
          id: '2',
          title: 'Order Cancelled',
          message:
              'Gilbert, Thank you for shopping with us we have canceled order #24568.',
          type: 'order_cancelled',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        NotificationModel(
          id: '3',
          title: 'Order Confirmed',
          message:
              'Gilbert, your Order #24568 has been confirmed check your order history for f...',
          type: 'order_confirmed',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ];
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh notifications
  Future<void> refreshNotifications() async {
    await fetchNotifications();
  }

  // Clear all notifications
  void clearAllNotifications() {
    notifications.clear();
  }

  // Mark single notification as read
  void markAsRead(String notificationId) {
    final index = notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      notifications[index] = notifications[index].copyWith(isRead: true);
    }
  }

  // Mark all notifications as read
  void markAllAsRead() {
    notifications.value = notifications
        .map((n) => n.copyWith(isRead: true))
        .toList();
  }

  // Delete notification
  void deleteNotification(String notificationId) {
    notifications.removeWhere((n) => n.id == notificationId);
  }

  // Get time ago string
  String getTimeAgo(DateTime dateTime) {
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
}
