class UserProfile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? avatarUrl;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatarUrl,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatarUrl': avatarUrl,
    };
  }

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}

class AddressModel {
  final String id;
  final String streetAddress;
  final String city;
  final String state;
  final String zipCode;
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.streetAddress,
    required this.city,
    required this.state,
    required this.zipCode,
    this.isDefault = false,
  });

  String get fullAddress => '$streetAddress, $city, $state $zipCode';

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] as String,
      streetAddress: json['streetAddress'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      zipCode: json['zipCode'] as String,
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'streetAddress': streetAddress,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'isDefault': isDefault,
    };
  }

  AddressModel copyWith({
    String? id,
    String? streetAddress,
    String? city,
    String? state,
    String? zipCode,
    bool? isDefault,
  }) {
    return AddressModel(
      id: id ?? this.id,
      streetAddress: streetAddress ?? this.streetAddress,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

class PaymentCardModel {
  final String id;
  final String cardNumber;
  final String cardholderName;
  final String expiryDate;
  final String cvv;
  final String cardType;
  final bool isDefault;

  PaymentCardModel({
    required this.id,
    required this.cardNumber,
    required this.cardholderName,
    required this.expiryDate,
    required this.cvv,
    this.cardType = 'visa',
    this.isDefault = false,
  });

  String get maskedNumber =>
      '**** ${cardNumber.substring(cardNumber.length - 4)}';

  factory PaymentCardModel.fromJson(Map<String, dynamic> json) {
    return PaymentCardModel(
      id: json['id'] as String,
      cardNumber: json['cardNumber'] as String,
      cardholderName: json['cardholderName'] as String,
      expiryDate: json['expiryDate'] as String,
      cvv: json['cvv'] as String,
      cardType: json['cardType'] as String? ?? 'visa',
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cardNumber': cardNumber,
      'cardholderName': cardholderName,
      'expiryDate': expiryDate,
      'cvv': cvv,
      'cardType': cardType,
      'isDefault': isDefault,
    };
  }
}

class PayPalAccount {
  final String id;
  final String email;
  final bool isDefault;

  PayPalAccount({
    required this.id,
    required this.email,
    this.isDefault = false,
  });

  factory PayPalAccount.fromJson(Map<String, dynamic> json) {
    return PayPalAccount(
      id: json['id'] as String,
      email: json['email'] as String,
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'isDefault': isDefault};
  }
}

class WishlistCategory {
  final String id;
  final String name;
  final int productCount;
  final String? iconName;

  WishlistCategory({
    required this.id,
    required this.name,
    required this.productCount,
    this.iconName,
  });

  factory WishlistCategory.fromJson(Map<String, dynamic> json) {
    return WishlistCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      productCount: json['productCount'] as int,
      iconName: json['iconName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'productCount': productCount,
      'iconName': iconName,
    };
  }
}

class WishlistItem {
  final String id;
  final String productId;
  final String name;
  final String image;
  final double price;
  final String? categoryId;
  final DateTime addedAt;

  WishlistItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
    this.categoryId,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: json['id'] as String,
      productId: json['productId'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
      price: (json['price'] as num).toDouble(),
      categoryId: json['categoryId'] as String?,
      addedAt: json['addedAt'] != null
          ? DateTime.parse(json['addedAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'name': name,
      'image': image,
      'price': price,
      'categoryId': categoryId,
      'addedAt': addedAt.toIso8601String(),
    };
  }
}
