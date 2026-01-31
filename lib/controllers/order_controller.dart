import 'package:get/get.dart';
import 'package:ecommerce/models/order_model.dart';

class OrderController extends GetxController {
  // Observable variables
  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<OrderStatus> selectedFilter = OrderStatus.processing.obs;
  final Rx<OrderModel?> selectedOrder = Rx<OrderModel?>(null);

  // Filter options
  final List<OrderStatus> filterOptions = [
    OrderStatus.processing,
    OrderStatus.shipped,
    OrderStatus.delivered,
    OrderStatus.returned,
    OrderStatus.cancelled,
  ];

  // Computed properties
  bool get hasOrders => orders.isNotEmpty;

  List<OrderModel> get filteredOrders {
    return orders
        .where((order) => order.status == selectedFilter.value)
        .toList();
  }

  int get totalOrders => orders.length;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // Fetch orders from API (simulated)
  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Simulated orders data
      orders.value = [
        OrderModel(
          id: '1',
          orderNumber: '456765',
          status: OrderStatus.processing,
          orderDate: DateTime.now().subtract(const Duration(days: 3)),
          items: [
            OrderItemModel(
              id: '1',
              name: "Men's Fleece Pullover Hoodie",
              image:
                  'https://images.unsplash.com/photo-1556821552-5ff63b1c3da7?w=100&h=100&fit=crop',
              price: 100.00,
              quantity: 2,
              size: 'L',
              color: 'Green',
            ),
            OrderItemModel(
              id: '2',
              name: "Max Cirro Men's Slides",
              image:
                  'https://images.unsplash.com/photo-1460353581641-37baddab0fa2?w=100&h=100&fit=crop',
              price: 55.00,
              quantity: 1,
              size: '42',
            ),
            OrderItemModel(
              id: '3',
              name: "Classic Baseball Cap",
              image:
                  'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=100&h=100&fit=crop',
              price: 35.00,
              quantity: 1,
            ),
          ],
          subtotal: 290.00,
          shippingFee: 10.00,
          discount: 0.00,
          totalAmount: 300.00,
          shippingAddress: '2715 Ash Dr. San Jose, South Dakota 83475',
          phoneNumber: '121-224-7890',
          trackingNumber: 'TRK123456789',
        ),
        OrderModel(
          id: '2',
          orderNumber: '454569',
          status: OrderStatus.shipped,
          orderDate: DateTime.now().subtract(const Duration(days: 5)),
          items: [
            OrderItemModel(
              id: '4',
              name: "Fleece Skate Hoodie",
              image:
                  'https://images.unsplash.com/photo-1542272604-787c62d465d1?w=100&h=100&fit=crop',
              price: 110.00,
              quantity: 2,
              size: 'M',
              color: 'Yellow',
            ),
          ],
          subtotal: 220.00,
          shippingFee: 10.00,
          totalAmount: 230.00,
          shippingAddress: '2715 Ash Dr. San Jose, South Dakota 83475',
          phoneNumber: '121-224-7890',
          trackingNumber: 'TRK987654321',
          estimatedDelivery: DateTime.now().add(const Duration(days: 3)),
        ),
        OrderModel(
          id: '3',
          orderNumber: '454809',
          status: OrderStatus.delivered,
          orderDate: DateTime.now().subtract(const Duration(days: 10)),
          items: [
            OrderItemModel(
              id: '5',
              name: "Sports Duffel Bag",
              image:
                  'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=100&h=100&fit=crop',
              price: 85.00,
              quantity: 1,
            ),
          ],
          subtotal: 85.00,
          shippingFee: 0.00,
          totalAmount: 85.00,
          shippingAddress: '2715 Ash Dr. San Jose, South Dakota 83475',
          phoneNumber: '121-224-7890',
        ),
      ];
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh orders
  Future<void> refreshOrders() async {
    await fetchOrders();
  }

  // Set filter
  void setFilter(OrderStatus status) {
    selectedFilter.value = status;
  }

  // Select order for details
  void selectOrder(OrderModel order) {
    selectedOrder.value = order;
  }

  // Clear selected order
  void clearSelectedOrder() {
    selectedOrder.value = null;
  }

  // Get order by ID
  OrderModel? getOrderById(String orderId) {
    try {
      return orders.firstWhere((o) => o.id == orderId);
    } catch (e) {
      return null;
    }
  }

  // Check if status is completed in timeline
  bool isStatusCompleted(OrderModel order, OrderStatus checkStatus) {
    final statusOrder = [
      OrderStatus.placed,
      OrderStatus.confirmed,
      OrderStatus.shipped,
      OrderStatus.delivered,
    ];

    // Map current order status to timeline status
    OrderStatus currentTimelineStatus;
    switch (order.status) {
      case OrderStatus.processing:
        currentTimelineStatus = OrderStatus.confirmed;
        break;
      case OrderStatus.shipped:
        currentTimelineStatus = OrderStatus.shipped;
        break;
      case OrderStatus.delivered:
        currentTimelineStatus = OrderStatus.delivered;
        break;
      default:
        currentTimelineStatus = OrderStatus.placed;
    }

    final currentIndex = statusOrder.indexOf(currentTimelineStatus);
    final checkIndex = statusOrder.indexOf(checkStatus);

    if (currentIndex == -1 || checkIndex == -1) return false;
    return currentIndex >= checkIndex;
  }

  // Cancel order
  Future<bool> cancelOrder(String orderId) async {
    try {
      final index = orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        orders[index] = orders[index].copyWith(status: OrderStatus.cancelled);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Request return
  Future<bool> requestReturn(String orderId) async {
    try {
      final index = orders.indexWhere((o) => o.id == orderId);
      if (index != -1 && orders[index].status == OrderStatus.delivered) {
        orders[index] = orders[index].copyWith(status: OrderStatus.returned);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
