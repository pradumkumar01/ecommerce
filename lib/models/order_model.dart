class OrderItemModel {
  final String id;
  final String name;
  final String image;
  final double price;
  final int quantity;
  final String? size;
  final String? color;

  OrderItemModel({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
    this.size,
    this.color,
  });

  double get totalPrice => price * quantity;

  OrderItemModel copyWith({
    String? id,
    String? name,
    String? image,
    double? price,
    int? quantity,
    String? size,
    String? color,
  }) {
    return OrderItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      size: size ?? this.size,
      color: color ?? this.color,
    );
  }

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 1,
      size: json['size'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'price': price,
      'quantity': quantity,
      'size': size,
      'color': color,
    };
  }
}

enum OrderStatus {
  placed,
  confirmed,
  processing,
  shipped,
  delivered,
  returned,
  cancelled,
}

extension OrderStatusExtension on OrderStatus {
  String get displayName {
    switch (this) {
      case OrderStatus.placed:
        return 'Order Placed';
      case OrderStatus.confirmed:
        return 'Order Confirmed';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.returned:
        return 'Returned';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get filterName {
    switch (this) {
      case OrderStatus.placed:
        return 'Placed';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.returned:
        return 'Returned';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}

class OrderModel {
  final String id;
  final String orderNumber;
  final OrderStatus status;
  final DateTime orderDate;
  final List<OrderItemModel> items;
  final double subtotal;
  final double shippingFee;
  final double discount;
  final double totalAmount;
  final String shippingAddress;
  final String phoneNumber;
  final String? trackingNumber;
  final DateTime? estimatedDelivery;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.orderDate,
    required this.items,
    required this.subtotal,
    this.shippingFee = 0.0,
    this.discount = 0.0,
    required this.totalAmount,
    required this.shippingAddress,
    required this.phoneNumber,
    this.trackingNumber,
    this.estimatedDelivery,
  });

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  String get formattedDate {
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
    return '${orderDate.day} ${months[orderDate.month - 1]}';
  }

  String get formattedTotal => '\$${totalAmount.toStringAsFixed(2)}';

  OrderModel copyWith({
    String? id,
    String? orderNumber,
    OrderStatus? status,
    DateTime? orderDate,
    List<OrderItemModel>? items,
    double? subtotal,
    double? shippingFee,
    double? discount,
    double? totalAmount,
    String? shippingAddress,
    String? phoneNumber,
    String? trackingNumber,
    DateTime? estimatedDelivery,
  }) {
    return OrderModel(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      status: status ?? this.status,
      orderDate: orderDate ?? this.orderDate,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      shippingFee: shippingFee ?? this.shippingFee,
      discount: discount ?? this.discount,
      totalAmount: totalAmount ?? this.totalAmount,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      estimatedDelivery: estimatedDelivery ?? this.estimatedDelivery,
    );
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      orderNumber: json['orderNumber'] ?? '',
      status: OrderStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => OrderStatus.processing,
      ),
      orderDate: json['orderDate'] != null
          ? DateTime.parse(json['orderDate'])
          : DateTime.now(),
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => OrderItemModel.fromJson(e))
              .toList() ??
          [],
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      shippingFee: (json['shippingFee'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      shippingAddress: json['shippingAddress'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      trackingNumber: json['trackingNumber'],
      estimatedDelivery: json['estimatedDelivery'] != null
          ? DateTime.parse(json['estimatedDelivery'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderNumber': orderNumber,
      'status': status.name,
      'orderDate': orderDate.toIso8601String(),
      'items': items.map((e) => e.toJson()).toList(),
      'subtotal': subtotal,
      'shippingFee': shippingFee,
      'discount': discount,
      'totalAmount': totalAmount,
      'shippingAddress': shippingAddress,
      'phoneNumber': phoneNumber,
      'trackingNumber': trackingNumber,
      'estimatedDelivery': estimatedDelivery?.toIso8601String(),
    };
  }
}
