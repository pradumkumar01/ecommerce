import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce/config/app_styles.dart';
import 'package:ecommerce/config/app_colors.dart';
import 'package:ecommerce/controllers/home_controller.dart';
import 'package:ecommerce/controllers/auth_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedBottomNav = 0;
  String _selectedGender = 'Men';

  final authController = Get.find<AuthController>();
  final homeController = Get.find<HomeController>();

  final List<Map<String, String>> categories = [
    {
      'name': 'Hoodies',
      'image':
          'https://wallpapers.com/images/hd/hoodie-for-kids-png-87-zth1al1rho11xdpj.png',
    },
    {
      'name': 'Shorts',
      'image':
          'https://wallpapers.com/images/hd/hoodie-for-kids-png-87-zth1al1rho11xdpj.png',
    },
    {
      'name': 'Shoes',
      'image':
          'https://images.unsplash.com/photo-1460353581641-37baddab0fa2?w=150&h=150&fit=crop',
    },
    {
      'name': 'Bag',
      'image':
          'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=150&h=150&fit=crop',
    },
    {
      'name': 'Accessories',
      'image':
          'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=150&h=150&fit=crop',
    },
  ];

  final List<Map<String, dynamic>> topSellingProducts = [
    {
      'name': "Men's Harrington Jacket",
      'price': '\$148.00',
      'image':
          'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=250&h=250&fit=crop',
    },
    {
      'name': "Max Cirro Men's Slides",
      'price': '\$55.00',
      'oldPrice': '\$100.97',
      'image':
          'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=250&h=250&fit=crop',
    },
    {
      'name': "Men's Casual Shirt",
      'price': '\$66',
      'image':
          'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=250&h=250&fit=crop',
    },
  ];

  final List<Map<String, dynamic>> hoodiePeekProducts = [
    {
      'name': "Men's Fleece Pullover Hoodie",
      'price': '\$100.00',
      'image':
          'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=200&h=250&fit=crop',
    },
    {
      'name': "Fleece Pullover Skate Hoodie",
      'price': '\$150.97',
      'image':
          'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=200&h=250&fit=crop',
    },
    {
      'name': "Fleece Skate Hoodie",
      'price': '\$110.00',
      'image':
          'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=200&h=250&fit=crop',
    },
    {
      'name': "Men's Ice-Dye Pullover Hoodie",
      'price': '\$128.97',
      'image':
          'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=200&h=250&fit=crop',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with profile and dropdown
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Profile picture
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.lightPrimary,
                      child: Text(
                        authController.userName.value.isNotEmpty
                            ? authController.userName.value[0].toUpperCase()
                            : 'U',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Gender dropdown
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isDark ? Color(0xFF3A3A3A) : Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: DropdownButton<String>(
                        value: _selectedGender,
                        underline: const SizedBox(),
                        style: AppStyles.bodySmall.copyWith(
                          color: isDark
                              ? AppColors.darkText
                              : AppColors.lightText,
                          fontWeight: FontWeight.w600,
                        ),
                        dropdownColor: isDark
                            ? Color(0xFF2D2D2D)
                            : Colors.white,
                        items: ['Men', 'Women', 'Kids'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedGender = newValue ?? 'Men';
                          });
                        },
                      ),
                    ),
                    const Spacer(),
                    // Cart icon
                    GestureDetector(
                      onTap: () => Get.toNamed('/cart'),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.lightPrimary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.shopping_bag_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: isDark ? Color(0xFF3A3A3A) : Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search',
                            border: InputBorder.none,
                            hintStyle: AppStyles.bodySmall.copyWith(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                          style: AppStyles.bodySmall.copyWith(
                            color: isDark
                                ? AppColors.darkText
                                : AppColors.lightText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Categories section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Categories',
                          style: AppStyles.headlineSmall.copyWith(
                            color: isDark
                                ? AppColors.darkText
                                : AppColors.lightText,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Get.toNamed('/category-list'),
                          child: Text(
                            'See All',
                            style: AppStyles.bodySmall.copyWith(
                              color: AppColors.lightPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: GestureDetector(
                              onTap: () => Get.toNamed(
                                '/product-category',
                                arguments: categories[index]['name'],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? Color(0xFF3A3A3A)
                                          : Color(0xFFF5F5F5),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: CachedNetworkImage(
                                        imageUrl: categories[index]['image']!,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Container(
                                              color: isDark
                                                  ? Color(0xFF3A3A3A)
                                                  : Color(0xFFF5F5F5),
                                            ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    categories[index]['name']!,
                                    style: AppStyles.bodySmall.copyWith(
                                      color: isDark
                                          ? AppColors.darkText
                                          : AppColors.lightText,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Top Selling section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Top Selling',
                          style: AppStyles.headlineSmall.copyWith(
                            color: isDark
                                ? AppColors.darkText
                                : AppColors.lightText,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'See All',
                          style: AppStyles.bodySmall.copyWith(
                            color: AppColors.lightPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 280,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: topSellingProducts.length,
                        itemBuilder: (context, index) {
                          final product = topSellingProducts[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: _buildProductCard(product, isDark),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // New In section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'New In',
                          style: AppStyles.headlineSmall.copyWith(
                            color: isDark
                                ? AppColors.darkText
                                : AppColors.lightText,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'See All',
                          style: AppStyles.bodySmall.copyWith(
                            color: AppColors.lightPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 280,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: hoodiePeekProducts.length,
                        itemBuilder: (context, index) {
                          final product = hoodiePeekProducts[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: _buildProductCard(product, isDark),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedBottomNav,
        type: BottomNavigationBarType.fixed,
        backgroundColor: isDark
            ? AppColors.darkSurface
            : AppColors.lightSurface,
        selectedItemColor: AppColors.lightPrimary,
        unselectedItemColor: isDark
            ? AppColors.darkTextSecondary
            : AppColors.lightTextSecondary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
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
          setState(() {
            _selectedBottomNav = index;
          });

          // Handle navigation for bottom navigation items
          if (index == 1) {
            Get.toNamed('/notifications');
          } else if (index == 2) {
            Get.toNamed('/orders');
          }
        },
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product, bool isDark) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF2D2D2D) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image with favorite button
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: CachedNetworkImage(
                  imageUrl: product['image'],
                  height: 180,
                  width: 160,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: isDark ? Color(0xFF3A3A3A) : Color(0xFFF5F5F5),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.favorite_outline,
                    color: AppColors.lightPrimary,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          // Product name and price
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.bodySmall.copyWith(
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                if (product['oldPrice'] != null)
                  Row(
                    children: [
                      Text(
                        product['price'],
                        style: AppStyles.bodySmall.copyWith(
                          color: isDark
                              ? AppColors.darkText
                              : AppColors.lightText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        product['oldPrice'],
                        style: AppStyles.bodySmall.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    product['price'],
                    style: AppStyles.bodySmall.copyWith(
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
