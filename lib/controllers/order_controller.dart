import 'package:get/get.dart';

class OrderItemModel {
  final String id;
  final String name;
  final String image;
  final double price;
  final int quantity;

  OrderItemModel({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
  });
}

class OrderModel {
  final String id;
  final String orderNumber;
  final String
  status; // 'processing', 'shipped', 'delivered', 'returned', 'cancelled'
  final DateTime orderDate;
  final List<OrderItemModel> items;
  final double totalAmount;
  final String shippingAddress;
  final String phoneNumber;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.orderDate,
    required this.items,
    required this.totalAmount,
    required this.shippingAddress,
    required this.phoneNumber,
  });

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
}

class OrderController extends GetxController {
  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString selectedFilter = 'Processing'.obs;
  final Rx<OrderModel?> selectedOrder = Rx<OrderModel?>(null);

  final List<String> filters = [
    'Processing',
    'Shipped',
    'Delivered',
    'Returned',
    'Cancelled',
  ];

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  void fetchOrders() {
    isLoading.value = true;

    // Simulated orders data
    orders.value = [
      OrderModel(
        id: '1',
        orderNumber: '456765',
        status: 'processing',
        orderDate: DateTime.now().subtract(const Duration(days: 3)),
        items: [
          OrderItemModel(
            id: '1',
            name: "Men's Fleece Pullover Hoodie",
            image:
                'https://images.unsplash.com/photo-1556821552-5ff63b1c3da7?w=100&h=100&fit=crop',
            price: 100.00,
            quantity: 2,
          ),
          OrderItemModel(
            id: '2',
            name: "Max Cirro Men's Slides",
            image:
                'https://images.unsplash.com/photo-1460353581641-37baddab0fa2?w=100&h=100&fit=crop',
            price: 55.00,
            quantity: 1,
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
        totalAmount: 290.00,
        shippingAddress: '2715 Ash Dr. San Jose, South Dakota 83475',
        phoneNumber: '121-224-7890',
      ),
      OrderModel(
        id: '2',
        orderNumber: '454569',
        status: 'shipped',
        orderDate: DateTime.now().subtract(const Duration(days: 5)),
        items: [
          OrderItemModel(
            id: '4',
            name: "Fleece Skate Hoodie",
            image:
                'https://images.unsplash.com/photo-1542272604-787c62d465d1?w=100&h=100&fit=crop',
            price: 110.00,
            quantity: 2,
          ),
        ],
        totalAmount: 220.00,
        shippingAddress: '2715 Ash Dr. San Jose, South Dakota 83475',
        phoneNumber: '121-224-7890',
      ),
      OrderModel(
        id: '3',
        orderNumber: '454809',
        status: 'delivered',
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
        totalAmount: 85.00,
        shippingAddress: '2715 Ash Dr. San Jose, South Dakota 83475',
        phoneNumber: '121-224-7890',
      ),
    ];

    isLoading.value = false;
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  void selectOrder(OrderModel order) {
    selectedOrder.value = order;
  }

  List<OrderModel> get filteredOrders {
    return orders.where((order) {
      return order.status.toLowerCase() == selectedFilter.value.toLowerCase();
    }).toList();
  }

  bool get hasOrders => orders.isNotEmpty;

  String getStatusDate(OrderModel order) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${order.orderDate.day} ${months[order.orderDate.month - 1]}';
  }
}
