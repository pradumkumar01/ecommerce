import 'package:get/get.dart';

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String type; // 'order_placed', 'order_cancelled', 'order_confirmed'
  final DateTime createdAt;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    this.isRead = false,
  });
}

class NotificationController extends GetxController {
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  void fetchNotifications() {
    isLoading.value = true;

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

    isLoading.value = false;
  }

  void clearNotifications() {
    notifications.clear();
  }

  void markAsRead(String notificationId) {
    final index = notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      final notification = notifications[index];
      notifications[index] = NotificationModel(
        id: notification.id,
        title: notification.title,
        message: notification.message,
        type: notification.type,
        createdAt: notification.createdAt,
        isRead: true,
      );
    }
  }

  bool get hasNotifications => notifications.isNotEmpty;
}
