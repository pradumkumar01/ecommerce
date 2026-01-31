class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double rating;
  final String imageUrl;
  final String category;
  final bool inStock;
  final int? reviewCount;
  final List<String>? images;
  final String? sku;
  final int? quantity;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.imageUrl,
    required this.category,
    required this.inStock,
    this.reviewCount = 0,
    this.images,
    this.sku,
    this.quantity = 1,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      imageUrl: json['imageUrl'] as String,
      category: json['category'] as String,
      inStock: json['inStock'] as bool? ?? true,
      reviewCount: json['reviewCount'] as int? ?? 0,
      images: (json['images'] as List<dynamic>?)?.cast<String>(),
      sku: json['sku'] as String?,
      quantity: json['quantity'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'rating': rating,
      'imageUrl': imageUrl,
      'category': category,
      'inStock': inStock,
      'reviewCount': reviewCount,
      'images': images,
      'sku': sku,
      'quantity': quantity,
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? rating,
    String? imageUrl,
    String? category,
    bool? inStock,
    int? reviewCount,
    List<String>? images,
    String? sku,
    int? quantity,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      inStock: inStock ?? this.inStock,
      reviewCount: reviewCount ?? this.reviewCount,
      images: images ?? this.images,
      sku: sku ?? this.sku,
      quantity: quantity ?? this.quantity,
    );
  }
}

class CartItem {
  final Product product;
  final int quantity;
  final String? size;
  final String? color;

  CartItem({
    required this.product,
    required this.quantity,
    this.size,
    this.color,
  });

  double get total => product.price * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int? ?? 1,
      size: json['size'] as String?,
      color: json['color'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'size': size,
      'color': color,
    };
  }

  CartItem copyWith({
    Product? product,
    int? quantity,
    String? size,
    String? color,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      size: size ?? this.size,
      color: color ?? this.color,
    );
  }
}
