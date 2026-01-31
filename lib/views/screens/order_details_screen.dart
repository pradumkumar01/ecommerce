import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce/config/app_styles.dart';
import 'package:ecommerce/config/app_colors.dart';
import 'package:ecommerce/controllers/order_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OrderDetailsScreen extends StatelessWidget {
  OrderDetailsScreen({Key? key}) : super(key: key);

  final OrderController controller = Get.find<OrderController>();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final order = Get.arguments as OrderModel?;

    if (order == null) {
      return Scaffold(body: Center(child: Text('Order not found')));
    }

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
            icon: const Icon(Icons.arrow_back_ios_new),
            color: isDark ? AppColors.darkText : AppColors.lightText,
            onPressed: () => Get.back(),
          ),
        ),
        centerTitle: true,
        title: Text(
          'Order  #${order.orderNumber}',
          style: AppStyles.headlineSmall.copyWith(
            color: isDark ? AppColors.darkText : AppColors.lightText,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Status Timeline
            _buildStatusTimeline(order, isDark),
            const SizedBox(height: 24),

            // Order Items Section
            _buildOrderItemsSection(order, isDark),
            const SizedBox(height: 24),

            // Shipping Details Section
            _buildShippingDetailsSection(order, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTimeline(OrderModel order, bool isDark) {
    final statuses = [
      {'status': 'Order Placed', 'icon': Icons.circle, 'completed': true},
      {
        'status': 'Order Confirmed',
        'icon': Icons.circle,
        'completed': _isStatusCompleted(order.status, 'confirmed'),
      },
      {
        'status': 'Shipped',
        'icon': Icons.circle,
        'completed': _isStatusCompleted(order.status, 'shipped'),
      },
      {
        'status': 'Delivered',
        'icon': Icons.circle,
        'completed': _isStatusCompleted(order.status, 'delivered'),
      },
    ];

    return Column(
      children: List.generate(statuses.length, (index) {
        final status = statuses[index];
        final isCompleted = status['completed'] as bool;
        final isLast = index == statuses.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline indicator
            Column(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppColors.lightPrimary
                        : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isCompleted
                          ? AppColors.lightPrimary
                          : (isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary),
                      width: 2,
                    ),
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 40,
                    color: isCompleted
                        ? AppColors.lightPrimary
                        : (isDark
                              ? const Color(0xFF3A3A3A)
                              : const Color(0xFFE0E0E0)),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            // Status text
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      status['status'] as String,
                      style: AppStyles.bodySmall.copyWith(
                        color: isCompleted
                            ? (isDark
                                  ? AppColors.darkText
                                  : AppColors.lightText)
                            : (isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary),
                        fontWeight: isCompleted
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                    if (isCompleted)
                      Text(
                        controller.getStatusDate(order),
                        style: AppStyles.bodySmall.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  bool _isStatusCompleted(String currentStatus, String checkStatus) {
    final statusOrder = ['processing', 'confirmed', 'shipped', 'delivered'];
    final currentIndex = statusOrder.indexOf(currentStatus.toLowerCase());
    final checkIndex = statusOrder.indexOf(checkStatus.toLowerCase());

    if (currentIndex == -1) return false;
    return currentIndex >= checkIndex;
  }

  Widget _buildOrderItemsSection(OrderModel order, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Items',
          style: AppStyles.headlineSmall.copyWith(
            color: isDark ? AppColors.darkText : AppColors.lightText,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${order.itemCount} items',
                    style: AppStyles.bodySmall.copyWith(
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  _showOrderItemsBottomSheet(order, isDark);
                },
                child: Text(
                  'View All',
                  style: AppStyles.bodySmall.copyWith(
                    color: AppColors.lightPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showOrderItemsBottomSheet(OrderModel order, bool isDark) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF3A3A3A)
                      : const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              'Order Items',
              style: AppStyles.headlineSmall.copyWith(
                color: isDark ? AppColors.darkText : AppColors.lightText,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ...order.items
                .map((item) => _buildOrderItemCard(item, isDark))
                .toList(),
            const SizedBox(height: 16),
            Divider(
              color: isDark ? const Color(0xFF3A3A3A) : const Color(0xFFE0E0E0),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: AppStyles.bodySmall.copyWith(
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '\$${order.totalAmount.toStringAsFixed(2)}',
                  style: AppStyles.headlineSmall.copyWith(
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItemCard(OrderItemModel item, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: item.image,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: isDark
                    ? const Color(0xFF3A3A3A)
                    : const Color(0xFFF5F5F5),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.bodySmall.copyWith(
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Qty: ${item.quantity}',
                  style: AppStyles.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '\$${item.price.toStringAsFixed(2)}',
            style: AppStyles.bodySmall.copyWith(
              color: isDark ? AppColors.darkText : AppColors.lightText,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingDetailsSection(OrderModel order, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Shipping details',
          style: AppStyles.headlineSmall.copyWith(
            color: isDark ? AppColors.darkText : AppColors.lightText,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.shippingAddress,
                style: AppStyles.bodySmall.copyWith(
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                order.phoneNumber,
                style: AppStyles.bodySmall.copyWith(
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
