import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce/config/app_styles.dart';
import 'package:ecommerce/config/app_colors.dart';
import 'package:ecommerce/controllers/order_controller.dart';

class OrdersScreen extends StatelessWidget {
  OrdersScreen({Key? key}) : super(key: key);

  final OrderController controller = Get.put(OrderController());

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
          'Orders',
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

        if (!controller.hasOrders) {
          return _buildEmptyState(isDark, context);
        }

        return _buildOrdersContent(isDark, context);
      }),
      bottomNavigationBar: _buildBottomNavBar(isDark),
    );
  }

  Widget _buildEmptyState(bool isDark, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Cart Icon with checkmark
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shopping_cart_outlined,
                  size: 50,
                  color: Color(0xFFFFB74D),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.lightPrimary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 20, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'No Orders yet',
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

  Widget _buildOrdersContent(bool isDark, BuildContext context) {
    return Column(
      children: [
        // Filter chips
        _buildFilterChips(isDark),
        const SizedBox(height: 16),
        // Orders list
        Expanded(
          child: Obx(() {
            final filteredOrders = controller.filteredOrders;
            if (filteredOrders.isEmpty) {
              return Center(
                child: Text(
                  'No ${controller.selectedFilter.value} orders',
                  style: AppStyles.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredOrders.length,
              itemBuilder: (context, index) {
                final order = filteredOrders[index];
                return _buildOrderCard(order, isDark);
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildFilterChips(bool isDark) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Obx(
        () => Row(
          children: controller.filters.map((filter) {
            final isSelected = controller.selectedFilter.value == filter;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(filter),
                selected: isSelected,
                onSelected: (_) => controller.setFilter(filter),
                backgroundColor: isDark
                    ? const Color(0xFF2D2D2D)
                    : const Color(0xFFF5F5F5),
                selectedColor: AppColors.lightPrimary,
                labelStyle: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : (isDark ? AppColors.darkText : AppColors.lightText),
                  fontWeight: FontWeight.w500,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                side: BorderSide.none,
                showCheckmark: false,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order, bool isDark) {
    return GestureDetector(
      onTap: () {
        controller.selectOrder(order);
        Get.toNamed('/order-details', arguments: order);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Order icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF3A3A3A) : Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.receipt_long_outlined,
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
            ),
            const SizedBox(width: 16),
            // Order details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order  #${order.orderNumber}',
                    style: AppStyles.bodySmall.copyWith(
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${order.itemCount} items',
                    style: AppStyles.bodySmall.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // Date and arrow
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
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
            const SizedBox(width: 8),
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

  Widget _buildBottomNavBar(bool isDark) {
    return BottomNavigationBar(
      currentIndex: 2,
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
        } else if (index == 1) {
          Get.toNamed('/notifications');
        }
      },
    );
  }
}
