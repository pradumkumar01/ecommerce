import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce/models/profile_model.dart';

class ProfileController extends GetxController {
  // User Profile
  final Rx<UserProfile?> userProfile = Rx<UserProfile?>(null);
  final RxBool isLoading = false.obs;

  // Addresses
  final RxList<AddressModel> addresses = <AddressModel>[].obs;

  // Payment Methods
  final RxList<PaymentCardModel> paymentCards = <PaymentCardModel>[].obs;
  final RxList<PayPalAccount> paypalAccounts = <PayPalAccount>[].obs;

  // Wishlist
  final RxList<WishlistCategory> wishlistCategories = <WishlistCategory>[].obs;
  final RxList<WishlistItem> wishlistItems = <WishlistItem>[].obs;
  final Rx<String?> selectedCategoryId = Rx<String?>(null);

  // Form Controllers
  final streetAddressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipCodeController = TextEditingController();

  final cardNumberController = TextEditingController();
  final cardholderNameController = TextEditingController();
  final expiryController = TextEditingController();
  final cvvController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadUserProfile();
    _loadAddresses();
    _loadPaymentMethods();
    _loadWishlist();
  }

  @override
  void onClose() {
    streetAddressController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipCodeController.dispose();
    cardNumberController.dispose();
    cardholderNameController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    super.onClose();
  }

  void _loadUserProfile() {
    userProfile.value = UserProfile(
      id: '1',
      name: 'Gilbert Jones',
      email: 'Gilbertjones001@gmail.com',
      phone: '121-224-7890',
      avatarUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop',
    );
  }

  void _loadAddresses() {
    addresses.value = [
      AddressModel(
        id: '1',
        streetAddress: '2715 Ash Dr. San Jose',
        city: 'San Jose',
        state: 'South Dakota',
        zipCode: '83475',
        isDefault: true,
      ),
      AddressModel(
        id: '2',
        streetAddress: '2715 Ash Dr. San Jose',
        city: 'San Jose',
        state: 'South Dakota',
        zipCode: '83475',
        isDefault: false,
      ),
    ];
  }

  void _loadPaymentMethods() {
    paymentCards.value = [
      PaymentCardModel(
        id: '1',
        cardNumber: '4532123456784187',
        cardholderName: 'Gilbert Jones',
        expiryDate: '12/25',
        cvv: '123',
        cardType: 'mastercard',
        isDefault: true,
      ),
      PaymentCardModel(
        id: '2',
        cardNumber: '4532123456789387',
        cardholderName: 'Gilbert Jones',
        expiryDate: '06/26',
        cvv: '456',
        cardType: 'mastercard',
        isDefault: false,
      ),
    ];

    paypalAccounts.value = [
      PayPalAccount(id: '1', email: 'Cloth@gmail.com', isDefault: false),
    ];
  }

  void _loadWishlist() {
    wishlistCategories.value = [
      WishlistCategory(id: '1', name: 'My Favorite', productCount: 12),
      WishlistCategory(id: '2', name: 'T-Shirts', productCount: 4),
    ];

    wishlistItems.value = [
      WishlistItem(
        id: '1',
        productId: 'p1',
        name: 'Nike Fuel Pack',
        image:
            'https://images.unsplash.com/photo-1556906781-9a412961c28c?w=200&h=250&fit=crop',
        price: 32.00,
        categoryId: '1',
      ),
      WishlistItem(
        id: '2',
        productId: 'p2',
        name: 'Nike Show X Rush',
        image:
            'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=200&h=250&fit=crop',
        price: 104.00,
        categoryId: '1',
      ),
      WishlistItem(
        id: '3',
        productId: 'p3',
        name: "Men's T-Shirt",
        image:
            'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=200&h=250&fit=crop',
        price: 45.00,
        categoryId: '1',
      ),
      WishlistItem(
        id: '4',
        productId: 'p4',
        name: "Men's Skate T-Shirt",
        image:
            'https://images.unsplash.com/photo-1562157873-818bc0726f68?w=200&h=250&fit=crop',
        price: 45.00,
        categoryId: '1',
      ),
    ];
  }

  // Profile Methods
  void updateProfile({String? name, String? email, String? phone}) {
    if (userProfile.value != null) {
      userProfile.value = userProfile.value!.copyWith(
        name: name,
        email: email,
        phone: phone,
      );
      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Address Methods
  void addAddress() {
    if (streetAddressController.text.isEmpty ||
        cityController.text.isEmpty ||
        stateController.text.isEmpty ||
        zipCodeController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all fields',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final newAddress = AddressModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      streetAddress: streetAddressController.text,
      city: cityController.text,
      state: stateController.text,
      zipCode: zipCodeController.text,
      isDefault: addresses.isEmpty,
    );

    addresses.add(newAddress);
    clearAddressForm();
    Get.back();
    Get.snackbar(
      'Success',
      'Address added successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void deleteAddress(String id) {
    addresses.removeWhere((a) => a.id == id);
    Get.snackbar(
      'Success',
      'Address removed',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void setDefaultAddress(String id) {
    addresses.value = addresses.map((a) {
      return a.copyWith(isDefault: a.id == id);
    }).toList();
  }

  void clearAddressForm() {
    streetAddressController.clear();
    cityController.clear();
    stateController.clear();
    zipCodeController.clear();
  }

  // Payment Methods
  void addPaymentCard({String cardType = 'visa'}) {
    if (cardNumberController.text.isEmpty ||
        cardholderNameController.text.isEmpty ||
        expiryController.text.isEmpty ||
        cvvController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all fields',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final newCard = PaymentCardModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      cardNumber: cardNumberController.text.replaceAll(' ', ''),
      cardholderName: cardholderNameController.text,
      expiryDate: expiryController.text,
      cvv: cvvController.text,
      cardType: cardType,
      isDefault: paymentCards.isEmpty,
    );

    paymentCards.add(newCard);
    clearCardForm();
    Get.back();
    Get.snackbar(
      'Success',
      'Card added successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void deletePaymentCard(String id) {
    paymentCards.removeWhere((c) => c.id == id);
    Get.snackbar(
      'Success',
      'Card removed',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void setDefaultCard(String id) {
    paymentCards.value = paymentCards.map((c) {
      return PaymentCardModel(
        id: c.id,
        cardNumber: c.cardNumber,
        cardholderName: c.cardholderName,
        expiryDate: c.expiryDate,
        cvv: c.cvv,
        cardType: c.cardType,
        isDefault: c.id == id,
      );
    }).toList();
  }

  void clearCardForm() {
    cardNumberController.clear();
    cardholderNameController.clear();
    expiryController.clear();
    cvvController.clear();
  }

  // Wishlist Methods
  List<WishlistItem> get filteredWishlistItems {
    if (selectedCategoryId.value == null) {
      return wishlistItems;
    }
    return wishlistItems
        .where((item) => item.categoryId == selectedCategoryId.value)
        .toList();
  }

  void selectCategory(String? categoryId) {
    selectedCategoryId.value = categoryId;
  }

  void removeFromWishlist(String id) {
    wishlistItems.removeWhere((item) => item.id == id);
    // Update category counts
    _updateCategoryCounts();
    Get.snackbar(
      'Removed',
      'Item removed from wishlist',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _updateCategoryCounts() {
    wishlistCategories.value = wishlistCategories.map((cat) {
      final count = wishlistItems
          .where((item) => item.categoryId == cat.id)
          .length;
      return WishlistCategory(
        id: cat.id,
        name: cat.name,
        productCount: count,
        iconName: cat.iconName,
      );
    }).toList();
  }

  int get totalWishlistItems => wishlistItems.length;

  // Sign Out
  void signOut() {
    Get.dialog(
      AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.offAllNamed('/login');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text(
              'Sign Out',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
