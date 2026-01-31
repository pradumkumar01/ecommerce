# 👨‍💻 ShopHub Developer Handbook

**Complete guide for maintaining, extending, and improving the ShopHub e-commerce application.**

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [Architecture Deep Dive](#architecture-deep-dive)
3. [Adding New Features](#adding-new-features)
4. [Working with Controllers](#working-with-controllers)
5. [Creating Screens](#creating-screens)
6. [API Integration](#api-integration)
7. [Testing Strategy](#testing-strategy)
8. [Common Patterns](#common-patterns)
9. [Troubleshooting](#troubleshooting)
10. [Performance Tips](#performance-tips)

---

## Project Overview

### Technology Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| UI | Flutter 3.10.8+ | Cross-platform mobile UI |
| State | GetX 4.6.6 | Reactive state management |
| HTTP | Dio 5.3.0 | Network requests |
| Storage | GetStorage 2.1.1 | Local persistence |
| Caching | CachedNetworkImage 3.3.0 | Image optimization |
| Logging | Logger 2.0.0 | Debugging support |

### Design Philosophy

```
┌─────────────────────────────────────────┐
│  Simplicity & Maintainability First     │
│  Production Quality Code                │
│  Extensible Architecture                │
│  Best Practices Throughout              │
└─────────────────────────────────────────┘
```

### Core Principles

1. **Separation of Concerns** - UI, Logic, Data separated
2. **Reactive Programming** - UI follows data changes
3. **Dependency Injection** - GetX handles dependencies
4. **Reusability** - Common widgets, services shared
5. **Type Safety** - Null safety enabled everywhere
6. **Clear Naming** - Self-documenting code

---

## Architecture Deep Dive

### MVC Pattern with GetX

```
┌─────────────────────────────────────┐
│  Model (GetX Controller)            │
│  - State management                 │
│  - Business logic                   │
│  - API calls                        │
└────────────┬────────────────────────┘
             │
             │ Reactive binding
             ↓
┌─────────────────────────────────────┐
│  View (Flutter Widget)              │
│  - UI rendering                     │
│  - User input                       │
│  - Navigation                       │
└─────────────────────────────────────┘
```

### Data Flow Example: Adding Product to Cart

```
1. User taps "Add to Cart" button
   ↓
2. ProductDetailScreen calls cartController.addToCart(product, qty)
   ↓
3. CartController updates cartItems.value
   ↓
4. CartController recalculates totals
   ↓
5. CartController saves to local storage
   ↓
6. Obx() in CartScreen automatically rebuilds
   ↓
7. User sees updated cart
```

### Service Layer Architecture

```
┌──────────────────────────────────────┐
│         Controllers                  │
└──────────────────────┬───────────────┘
                       │
        ┌──────────────┼──────────────┐
        ↓              ↓              ↓
┌──────────────┐ ┌──────────┐ ┌────────────┐
│ ApiService   │ │ Storage  │ │ Network    │
│ (Dio HTTP)   │ │ Service  │ │ Service    │
└──────────────┘ └──────────┘ └────────────┘
        │              │              │
        └──────────────┼──────────────┘
                       │
        ┌──────────────┼──────────────┐
        ↓              ↓              ↓
   Remote API  Local Storage  Connectivity
```

---

## Adding New Features

### Checklist for New Feature

- [ ] Create Model (if needed) in `lib/models/`
- [ ] Create Controller in `lib/controllers/`
- [ ] Create Screen in `lib/views/screens/`
- [ ] Add Widgets (if needed) to `lib/views/widgets/`
- [ ] Add Route in `lib/routes/app_pages.dart`
- [ ] Update Navigation in relevant screens
- [ ] Add Documentation
- [ ] Test thoroughly

### Step-by-Step Example: Adding Order History Screen

#### Step 1: Create Model

```dart
// lib/models/order_model.dart
class Order {
  final String orderId;
  final List<CartItem> items;
  final double total;
  final DateTime orderDate;
  final String status; // pending, shipped, delivered
  final String shippingAddress;
  
  Order({
    required this.orderId,
    required this.items,
    required this.total,
    required this.orderDate,
    required this.status,
    required this.shippingAddress,
  });
  
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderId'],
      items: List<CartItem>.from(
        json['items'].map((x) => CartItem.fromJson(x))
      ),
      total: json['total'].toDouble(),
      orderDate: DateTime.parse(json['orderDate']),
      status: json['status'],
      shippingAddress: json['shippingAddress'],
    );
  }
}
```

#### Step 2: Create Controller

```dart
// lib/controllers/order_controller.dart
import 'package:get/get.dart';
import '../models/order_model.dart';
import '../services/api_service.dart';

class OrderController extends GetxController {
  final ApiService _apiService = Get.find();
  
  final RxList<Order> orders = <Order>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }
  
  Future<void> loadOrders() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      // Mock data for now
      orders.value = [
        Order(
          orderId: 'ORD-001',
          items: [],
          total: 299.99,
          orderDate: DateTime.now(),
          status: 'delivered',
          shippingAddress: '123 Main St',
        ),
      ];
      
      // TODO: Replace with actual API call
      // final response = await _apiService.get('/orders');
      // orders.value = (response as List)
      //     .map((x) => Order.fromJson(x))
      //     .toList();
      
    } catch (e) {
      errorMessage.value = 'Failed to load orders';
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> cancelOrder(String orderId) async {
    try {
      // TODO: Call API to cancel order
      orders.removeWhere((order) => order.orderId == orderId);
      Get.snackbar('Success', 'Order cancelled');
    } catch (e) {
      Get.snackbar('Error', 'Failed to cancel order');
    }
  }
  
  @override
  void onClose() {
    super.onClose();
  }
}
```

#### Step 3: Create Screen

```dart
// lib/views/screens/order_history_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/order_controller.dart';
import '../widgets/common_widgets.dart';
import '../../config/app_colors.dart';
import '../../config/app_styles.dart';

class OrderHistoryScreen extends GetView<OrderController> {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Order History',
        showBackButton: true,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? LoadingWidget()
            : controller.orders.isEmpty
                ? EmptyStateWidget(
                    icon: Icons.shopping_bag_outlined,
                    title: 'No Orders Yet',
                    subtitle: 'Start shopping to place your first order',
                    actionLabel: 'Continue Shopping',
                    onAction: () => Get.back(),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(AppStyles.spacingMedium),
                    itemCount: controller.orders.length,
                    itemBuilder: (context, index) {
                      final order = controller.orders[index];
                      return _OrderCard(order: order);
                    },
                  ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: AppStyles.spacingMedium),
      child: Padding(
        padding: EdgeInsets.all(AppStyles.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order.orderId}',
                  style: AppStyles.titleMedium,
                ),
                _StatusBadge(status: order.status),
              ],
            ),
            SizedBox(height: AppStyles.spacingSmall),
            Text(
              'Date: ${order.orderDate.toString().split(' ')[0]}',
              style: AppStyles.bodySmall,
            ),
            SizedBox(height: AppStyles.spacingSmall),
            Text(
              'Total: \$${order.total.toStringAsFixed(2)}',
              style: AppStyles.titleSmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors.warning;
      case 'shipped':
        return AppColors.info;
      case 'delivered':
        return AppColors.success;
      default:
        return AppColors.gray500;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppStyles.spacingSmall,
        vertical: AppStyles.spacingXSmall,
      ),
      decoration: BoxDecoration(
        color: _getStatusColor(),
        borderRadius: BorderRadius.circular(AppStyles.borderRadiusSmall),
      ),
      child: Text(
        status.toUpperCase(),
        style: AppStyles.labelSmall.copyWith(color: Colors.white),
      ),
    );
  }
}
```

#### Step 4: Add Route

```dart
// lib/routes/app_pages.dart
// Add to GetPage list:
GetPage(
  name: orderHistoryRoute,
  page: () => const OrderHistoryScreen(),
  binding: BindingsBuilder(() {
    Get.lazyPut(() => OrderController());
  }),
  transition: Transition.rightToLeft,
),
```

#### Step 5: Add to Constants

```dart
// lib/config/app_constants.dart
static const String orderHistoryRoute = '/orders';
```

#### Step 6: Update Navigation

```dart
// In HomeScreen bottom drawer or profile menu:
ListTile(
  leading: Icon(Icons.shopping_bag_outlined),
  title: Text('My Orders'),
  onTap: () => Get.toNamed(AppConstants.orderHistoryRoute),
),
```

---

## Working with Controllers

### Controller Template

```dart
// lib/controllers/my_controller.dart
import 'package:get/get.dart';

class MyController extends GetxController {
  // Dependencies
  final SomeService _service = Get.find();
  
  // Reactive state
  final RxBool isLoading = false.obs;
  final RxString message = ''.obs;
  final RxList<Item> items = <Item>[].obs;
  
  // Non-reactive state
  late String userId;
  
  // Lifecycle hooks
  @override
  void onInit() {
    super.onInit();
    // Initialize here
    print('$runtimeType initialized');
  }
  
  @override
  void onReady() {
    super.onReady();
    // Called after widget mounted
    // Load data here
    loadData();
  }
  
  // Methods
  Future<void> loadData() async {
    try {
      isLoading.value = true;
      message.value = '';
      
      // Your logic here
      final data = await _service.fetchData();
      items.value = data;
      
    } catch (e) {
      message.value = 'Error loading data: $e';
      Get.snackbar('Error', message.value);
    } finally {
      isLoading.value = false;
    }
  }
  
  void updateItem(Item item) {
    // Update existing item
    int index = items.indexWhere((x) => x.id == item.id);
    if (index != -1) {
      items[index] = item;
      // Trigger update explicitly if needed
      items.refresh();
    }
  }
  
  @override
  void onClose() {
    super.onClose();
    // Cleanup here
    print('$runtimeType disposed');
  }
}
```

### Reactive State Management

```dart
// Observable types
final count = 0.obs;              // RxInt
final name = ''.obs;              // RxString
final isActive = false.obs;        // RxBool
final items = <String>[].obs;      // RxList
final data = <String, int>{}.obs;  // RxMap

// Reactive getter
Rx<User>? get currentUser => _currentUser;

// Using in UI
Obx(
  () => Text('Count: ${count.value}'), // Rebuilds when count changes
)

// Manual update
count.value = 10;
items.add('new item');
data['key'] = 123;

// Force refresh
items.refresh();
```

### Common Controller Patterns

#### Pattern 1: List with CRUD Operations

```dart
class ItemController extends GetxController {
  final RxList<Item> items = <Item>[].obs;
  
  void addItem(Item item) {
    items.add(item);
  }
  
  void updateItem(String id, Item updatedItem) {
    int index = items.indexWhere((x) => x.id == id);
    if (index != -1) {
      items[index] = updatedItem;
      items.refresh();
    }
  }
  
  void deleteItem(String id) {
    items.removeWhere((x) => x.id == id);
  }
  
  void clearList() {
    items.clear();
  }
}
```

#### Pattern 2: Pagination

```dart
class ProductListController extends GetxController {
  final RxList<Product> products = <Product>[].obs;
  final RxInt currentPage = 1.obs;
  final RxBool hasMoreProducts = true.obs;
  final RxBool isLoadingMore = false.obs;
  
  Future<void> loadMore() async {
    if (isLoadingMore.value || !hasMoreProducts.value) return;
    
    try {
      isLoadingMore.value = true;
      currentPage.value++;
      
      final newProducts = await _apiService
          .getProducts(page: currentPage.value);
      
      if (newProducts.isEmpty) {
        hasMoreProducts.value = false;
      } else {
        products.addAll(newProducts);
      }
    } finally {
      isLoadingMore.value = false;
    }
  }
}
```

#### Pattern 3: Form Handling

```dart
class FormController extends GetxController {
  final formKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;
  final RxString errorMessage = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }
  
  bool validateForm() {
    if (formKey.currentState?.validate() ?? false) {
      return true;
    }
    return false;
  }
  
  Future<void> submitForm() async {
    if (!validateForm()) return;
    
    try {
      errorMessage.value = '';
      // Submit logic
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }
  
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
```

---

## Creating Screens

### Screen Template

```dart
// lib/views/screens/my_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/my_controller.dart';
import '../widgets/common_widgets.dart';
import '../../config/app_colors.dart';
import '../../config/app_styles.dart';

class MyScreen extends GetView<MyController> {
  const MyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Screen',
        showBackButton: true,
      ),
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return LoadingWidget();
          }
          
          if (controller.items.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.inbox_outlined,
              title: 'No Items',
              subtitle: 'Add items to get started',
              actionLabel: 'Add Item',
              onAction: _addItem,
            );
          }
          
          return _buildContent();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: Icon(Icons.add),
      ),
    );
  }
  
  Widget _buildContent() {
    return ListView.builder(
      itemCount: controller.items.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(controller.items[index].name),
        );
      },
    );
  }
  
  void _addItem() {
    // Implementation
  }
}
```

### Navigation Patterns

#### Pattern 1: Named Navigation

```dart
// Navigate with name
Get.toNamed('/product-detail', arguments: productId);

// Pop with result
Get.back(result: selectedItem);

// Replace screen
Get.offNamed('/home');

// Clear all and go to route
Get.offAllNamed('/login');
```

#### Pattern 2: Screen with Arguments

```dart
// Define in controller
class ProductDetailController extends GetxController {
  late String productId;
  
  @override
  void onInit() {
    super.onInit();
    productId = Get.arguments ?? '';
    loadProduct();
  }
}

// Navigate
Get.toNamed('/product-detail', arguments: 'prod-123');
```

---

## API Integration

### Updating API Endpoints

#### Step 1: Update Constants

```dart
// lib/config/app_constants.dart
class AppConstants {
  static const String baseUrl = 'https://api.yourdomain.com';
  static const String apiTimeout = 30; // seconds
  
  // Endpoints
  static const String productsEndpoint = '/api/products';
  static const String ordersEndpoint = '/api/orders';
  static const String usersEndpoint = '/api/users';
}
```

#### Step 2: Create API Methods

```dart
// lib/services/api_service.dart
class ApiService extends GetxService {
  late Dio dio;
  
  @override
  void onInit() {
    super.onInit();
    _initializeDio();
  }
  
  Future<List<Product>> getProducts({
    String? category,
    String? search,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await dio.get(
        '${AppConstants.baseUrl}${AppConstants.productsEndpoint}',
        queryParameters: {
          'category': category,
          'search': search,
          'page': page,
          'pageSize': pageSize,
        },
      );
      
      final products = (response.data as List)
          .map((x) => Product.fromJson(x))
          .toList();
      
      return products;
    } catch (e) {
      rethrow;
    }
  }
  
  Future<Product> getProductDetail(String productId) async {
    final response = await dio.get(
      '${AppConstants.baseUrl}${AppConstants.productsEndpoint}/$productId',
    );
    return Product.fromJson(response.data);
  }
  
  Future<Map<String, dynamic>> placeOrder(Order order) async {
    final response = await dio.post(
      '${AppConstants.baseUrl}${AppConstants.ordersEndpoint}',
      data: order.toJson(),
    );
    return response.data;
  }
}
```

#### Step 3: Update Controllers

```dart
// Before (Mock data)
@override
void onInit() {
  super.onInit();
  products.value = [
    Product(...),
    Product(...),
  ];
}

// After (Real API)
@override
void onInit() {
  super.onInit();
  loadProducts();
}

Future<void> loadProducts() async {
  try {
    isLoading.value = true;
    products.value = await _apiService.getProducts();
  } catch (e) {
    errorMessage.value = 'Failed to load products';
  } finally {
    isLoading.value = false;
  }
}
```

### Error Handling

```dart
try {
  final data = await apiService.getData();
  // Handle success
} on DioException catch (e) {
  if (e.response?.statusCode == 401) {
    // Unauthorized - go to login
    Get.offAllNamed('/login');
  } else if (e.response?.statusCode == 404) {
    // Not found
    errorMessage.value = 'Resource not found';
  } else if (e.type == DioExceptionType.connectionTimeout) {
    // Network error
    errorMessage.value = 'Connection timeout';
  } else {
    // Other errors
    errorMessage.value = e.message ?? 'An error occurred';
  }
} catch (e) {
  errorMessage.value = 'Unexpected error: $e';
}
```

---

## Testing Strategy

### Unit Testing Template

```dart
// test/controllers/my_controller_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:ecommerce/controllers/my_controller.dart';
import 'package:ecommerce/services/api_service.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  group('MyController', () {
    late MyController controller;
    late MockApiService mockApiService;

    setUp(() {
      mockApiService = MockApiService();
      Get.put<ApiService>(mockApiService);
      controller = MyController();
    });

    tearDown(() {
      Get.deleteAll();
    });

    test('Initial state is loading false', () {
      expect(controller.isLoading.value, false);
    });

    test('Load data updates items list', () async {
      // Arrange
      final mockItems = [Item(id: '1', name: 'Test')];
      when(mockApiService.getItems())
          .thenAnswer((_) async => mockItems);

      // Act
      await controller.loadData();

      // Assert
      expect(controller.items.value, mockItems);
      expect(controller.isLoading.value, false);
    });

    test('Error handling on API failure', () async {
      // Arrange
      when(mockApiService.getItems())
          .thenThrow(Exception('API Error'));

      // Act
      await controller.loadData();

      // Assert
      expect(controller.errorMessage.value, contains('Error'));
    });
  });
}
```

### Widget Testing Template

```dart
// test/views/screens/my_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ecommerce/views/screens/my_screen.dart';
import 'package:ecommerce/controllers/my_controller.dart';

void main() {
  group('MyScreen', () {
    late MyController controller;

    setUp(() {
      controller = MyController();
      Get.put(controller);
    });

    tearDown(() {
      Get.deleteAll();
    });

    testWidgets('Shows loading widget when loading',
        (WidgetTester tester) async {
      // Arrange
      controller.isLoading.value = true;

      // Act
      await tester.pumpWidget(
        GetMaterialApp(
          home: MyScreen(),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Shows items list when data loaded',
        (WidgetTester tester) async {
      // Arrange
      controller.items.value = [Item(id: '1', name: 'Test')];
      controller.isLoading.value = false;

      // Act
      await tester.pumpWidget(
        GetMaterialApp(
          home: MyScreen(),
        ),
      );

      // Assert
      expect(find.byType(ListView), findsOneWidget);
    });
  });
}
```

---

## Common Patterns

### Pattern 1: Search with Debounce

```dart
class SearchController extends GetxController {
  final RxString searchQuery = ''.obs;
  Timer? _debounce;
  
  @override
  void onInit() {
    super.onInit();
    
    // Debounce search
    debounce(
      searchQuery,
      (_) => performSearch(),
      time: Duration(milliseconds: 500),
    );
  }
  
  void onSearchChanged(String value) {
    searchQuery.value = value;
  }
  
  Future<void> performSearch() async {
    // Perform search
  }
  
  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }
}
```

### Pattern 2: Pull to Refresh

```dart
Widget _buildRefreshableList() {
  return RefreshIndicator(
    onRefresh: () => controller.loadData(),
    child: ListView.builder(
      itemCount: controller.items.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(controller.items[index].name),
        );
      },
    ),
  );
}
```

### Pattern 3: Conditional Rendering

```dart
Obx(
  () {
    if (controller.isLoading.value) {
      return LoadingWidget();
    } else if (controller.errorMessage.isNotEmpty) {
      return ErrorWidget(
        message: controller.errorMessage.value,
        onRetry: controller.loadData,
      );
    } else if (controller.items.isEmpty) {
      return EmptyStateWidget();
    } else {
      return ItemsListWidget(items: controller.items);
    }
  },
)
```

### Pattern 4: Dialog/Alert

```dart
void showCustomDialog({
  required String title,
  required String message,
  VoidCallback? onConfirm,
}) {
  Get.dialog(
    AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Get.back();
            onConfirm?.call();
          },
          child: Text('Confirm'),
        ),
      ],
    ),
  );
}
```

### Pattern 5: Snackbar

```dart
// Success
Get.snackbar(
  'Success',
  'Item added to cart',
  snackPosition: SnackPosition.BOTTOM,
  backgroundColor: AppColors.success,
);

// Error
Get.snackbar(
  'Error',
  'Failed to add item',
  snackPosition: SnackPosition.BOTTOM,
  backgroundColor: AppColors.error,
);

// Custom
Get.snackbar(
  'Info',
  'Processing...',
  duration: Duration(seconds: 3),
  icon: Icon(Icons.info),
);
```

---

## Troubleshooting

### Common Issues and Solutions

#### Issue: Controller not found

**Error**: `GetX: Controller not found`

**Solution**:
```dart
// Ensure controller is registered
Get.put(MyController());
// OR
GetPage(
  name: '/screen',
  page: () => MyScreen(),
  binding: BindingsBuilder(() {
    Get.lazyPut(() => MyController());
  }),
)
```

#### Issue: Null Safety Errors

**Error**: `The value of x can't be null`

**Solution**:
```dart
// Use late if will be initialized in onInit
late String value;

// OR use default value
String value = '';

// OR use required in constructor
late final String Function() getValue;
```

#### Issue: Rebuilding too many times

**Error**: Widget rebuilding unexpectedly

**Solution**:
```dart
// Use GetBuilder for specific updates
GetBuilder<MyController>(
  builder: (controller) => Text(controller.data),
)

// OR only update specific observable
count.refresh(); // Instead of updating whole state
```

#### Issue: TextEditingController disposal error

**Error**: `TextEditingController was used after being disposed`

**Solution**:
```dart
@override
void onClose() {
  emailController.dispose();
  passwordController.dispose();
  super.onClose();
}
```

#### Issue: Images not loading

**Error**: Blank image spaces

**Solution**:
```dart
CachedNetworkImage(
  imageUrl: imageUrl,
  placeholder: (context, url) => 
    Center(child: CircularProgressIndicator()),
  errorWidget: (context, url, error) => 
    Icon(Icons.image_not_supported),
  fit: BoxFit.cover,
)
```

---

## Performance Tips

### 1. Optimize Rebuilds

```dart
// Good: Only this widget rebuilds
Obx(() => Text(controller.name.value))

// Bad: Whole page rebuilds
GetBuilder<Controller>(
  builder: (controller) => Column(children: [...])
)
```

### 2. Use const Constructors

```dart
// Good
const CircularProgressIndicator()

// Bad (rebuilds unnecessarily)
CircularProgressIndicator()
```

### 3. Lazy Initialize Services

```dart
// Good
Get.lazyPut(() => ApiService());

// Bad (initializes immediately)
Get.put(ApiService());
```

### 4. Cache Images

```dart
CachedNetworkImage(
  imageUrl: url,
  memCacheHeight: 300, // Cache as 300px height
)
```

### 5. Use ListView.builder for Long Lists

```dart
// Good
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)

// Bad (loads all items)
ListView(
  children: items.map((item) => ItemWidget(item)).toList(),
)
```

### 6. Debounce Search

```dart
debounce(
  searchQuery,
  (_) => performSearch(),
  time: Duration(milliseconds: 500),
);
```

---

## Best Practices Summary

✅ **Do:**
- Use GetX for all state management
- Create separate controllers for each screen
- Keep UI logic out of models
- Use type-safe code
- Handle errors gracefully
- Test your code
- Document complex logic
- Use const constructors
- Dispose resources properly

❌ **Don't:**
- Update state directly without .obs
- Mix multiple state management approaches
- Keep business logic in UI
- Ignore error handling
- Use print() for debugging (use Logger)
- Create controllers globally
- Ignore memory leaks
- Hardcode strings and values

---

## Resources

- [GetX Documentation](https://pub.dev/packages/get)
- [Dio HTTP Client](https://pub.dev/packages/dio)
- [Flutter Official Guide](https://flutter.dev)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Material Design 3](https://m3.material.io)

---

**Happy coding! 🚀**

For questions or issues, refer to the main documentation or check existing implementations in the codebase.
