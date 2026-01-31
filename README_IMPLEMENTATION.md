# ShopHub - E-Commerce Mobile App

A production-ready Flutter e-commerce mobile application built with GetX state management, featuring both light and dark themes.

## Project Overview

ShopHub is a fully functional e-commerce application with comprehensive features including:

- ✅ User Authentication (Login/Register)
- ✅ Home Dashboard with featured products and categories
- ✅ Product Listing with advanced filtering and sorting
- ✅ Product Details with image carousel and reviews
- ✅ Shopping Cart with item management
- ✅ Checkout with multi-step process
- ✅ Light and Dark mode support
- ✅ Responsive design for all screen sizes

## Architecture & Pattern

The application follows a clean, scalable architecture:

```
lib/
├── config/                  # App configuration and theme
│   ├── app_colors.dart     # Color palette for light/dark themes
│   ├── app_styles.dart     # Typography, spacing, and theme data
│   └── app_constants.dart  # App-wide constants and enums
├── models/                  # Data models
│   └── product_model.dart  # Product and CartItem models
├── controllers/             # GetX controllers (Business Logic)
│   ├── auth_controller.dart
│   ├── home_controller.dart
│   ├── product_list_controller.dart
│   ├── product_detail_controller.dart
│   ├── cart_controller.dart
│   ├── checkout_controller.dart
│   └── theme_controller.dart
├── views/
│   ├── screens/             # UI Screens
│   │   ├── splash_screen.dart
│   │   ├── auth_screen.dart
│   │   ├── home_screen.dart
│   │   ├── product_list_screen.dart
│   │   ├── product_detail_screen.dart
│   │   ├── cart_screen.dart
│   │   └── checkout_screen.dart
│   └── widgets/             # Reusable UI components
│       └── common_widgets.dart
├── services/                # External services
│   ├── api_service.dart    # HTTP API client with Dio
│   ├── storage_service.dart # Local data persistence
│   ├── network_service.dart # Connectivity checking
│   └── logger_service.dart  # Logging utility
├── routes/                  # GetX routing
│   └── app_pages.dart      # Route definitions
├── utils/                   # Utility functions
└── main.dart               # Application entry point
```

## Key Features Implemented

### 1. **Splash Screen**
- App branding and loading animation
- Auto-navigation based on authentication status

### 2. **Authentication Screen**
- Login and Registration modes with toggle
- Form validation with error handling
- Mock authentication with token storage
- Social login buttons (UI ready)

### 3. **Home Dashboard**
- Featured products carousel
- Product categories with filtering
- Banner with promotional content
- Bottom navigation cart icon with badge
- Pull-to-refresh functionality

### 4. **Product List Screen**
- Grid view of products with 2 columns
- Advanced filtering (category, price range)
- Multiple sort options (popularity, price, rating, newest)
- Search functionality with debouncing
- Filter toggle with expandable section

### 5. **Product Detail Screen**
- Image carousel with thumbnail selection
- Star rating display with review count
- Detailed product information
- Specifications section
- Customer reviews section
- Related products recommendations
- Quantity selector
- Add to cart and Buy now options

### 6. **Shopping Cart Screen**
- Product list with images and prices
- Quantity adjustment controls
- Item removal capability
- Cart summary with calculations
- Coupon code input
- Tax calculation (10%)
- Shipping cost calculation (free over $100)
- Subtotal, tax, and total calculations

### 7. **Checkout Screen**
- Multi-step checkout process (3 steps)
- Step indicator with progress tracking
- Shipping information form
- Shipping method selection
- Payment method selection (5 options)
- Card details input (for credit/debit)
- Order review with summary
- Terms and conditions checkbox
- Order placement

### 8. **Theme System**
- Complete light and dark theme support
- Theme persistence using GetStorage
- Toggle theme from any screen
- Consistent color palette and typography

## Dependencies

```yaml
dependencies:
  get: ^4.6.6              # State management & navigation
  dio: ^5.3.0              # HTTP client
  http: ^1.1.0             # Alternative HTTP
  get_storage: ^2.1.1      # Local data persistence
  cached_network_image: ^3.3.0  # Image caching
  connectivity_plus: ^5.0.0     # Network connectivity
  logger: ^2.0.0           # Logging
  intl: ^0.19.0            # Internationalization
  image_picker: ^1.0.0     # Image selection
  path_provider: ^2.1.0    # File path utilities
  device_preview: ^1.1.0   # Device preview for testing
```

## State Management (GetX)

The app uses GetX for:
- **State Management**: Reactive state using `.obs` and `Obx()`
- **Dependency Injection**: `Get.put()`, `Get.find()`, `Get.lazyPut()`
- **Navigation**: Named route navigation with `Get.toNamed()`
- **Snackbars & Dialogs**: Built-in UI feedback

## Getting Started

### Prerequisites
- Flutter SDK 3.10.8+
- Android/iOS development environment

### Installation

```bash
# Clone the project
git clone <repository-url>
cd ecommerce

# Get dependencies
flutter pub get

# Run the app
flutter run

# For release build
flutter build apk --release
flutter build ios --release
```

## Project Structure Details

### Controllers
Each screen has a dedicated GetX controller that handles:
- Data fetching and processing
- State management
- User interactions
- Business logic

### Services
- **ApiService**: Centralized API client with retry logic and error handling
- **StorageService**: Local data persistence for tokens, cart, preferences
- **NetworkService**: Connectivity checking with stream support
- **LoggerService**: Structured logging

### Models
- **Product**: Complete product data model with JSON serialization
- **CartItem**: Shopping cart item with quantity tracking
- **Review**: Customer review data model

## Styling & Theming

### Colors
- Primary: `#6C5CE7` (Purple)
- Accent: `#FF6B6B` (Red)
- Success: `#27AE60` (Green)
- Error: `#E74C3C` (Red)
- Both light and dark variants for all colors

### Typography
- Multiple text styles: Display, Headline, Title, Body, Label
- Consistent font sizes and weights
- Responsive to theme mode

### Spacing & Sizing
- Standardized spacing values (4, 8, 12, 16, 20, 24, 32)
- Border radius: 4, 8, 12, 16, 20, 24, 50 (circular)
- Icon sizes: 16, 20, 24, 32, 48, 64

## Key Implementation Highlights

### 1. **Form Validation**
- Email, phone, password validation with regex
- Custom validators with clear error messages
- Form-level validation before submission

### 2. **Error Handling**
- Comprehensive error handling in API calls
- Retry mechanism with exponential backoff
- User-friendly error messages

### 3. **Data Persistence**
- Cart items persisted locally
- User tokens stored securely
- Theme preference remembered

### 4. **Performance**
- Image caching with CachedNetworkImage
- Lazy loading with GetX lazy dependencies
- Efficient list rendering with GridView

### 5. **UX/UI**
- Smooth animations and transitions
- Loading states with spinners
- Empty states with actionable buttons
- Responsive design for all screen sizes

## Mock Data

The app includes mock data for:
- Products (electronics, fashion, home & garden, sports, books)
- User authentication
- Product reviews
- Cart items
- Order information

Replace mock data with actual API calls by updating the services.

## Routes

```
/                    # Splash Screen
/login               # Authentication Screen
/home                # Home Dashboard
/products            # Product List
/product-detail      # Product Details
/cart                # Shopping Cart
/checkout            # Checkout
/profile             # User Profile (not yet implemented)
/orders              # Order History (not yet implemented)
/settings            # Settings (not yet implemented)
```

## Next Steps - Remaining Screens

### Task 9: User Profile Screen
- User profile information display
- Order history with order status
- Wishlist/Favorites management
- Account settings and preferences
- Logout functionality

### Task 10: Additional Screens (Optional)
- Order success/confirmation screen
- Order tracking screen
- Wishlist/Favorites screen
- Notifications screen
- Search results screen

## Code Quality

- Clean code principles followed
- Consistent naming conventions
- Comprehensive documentation
- Type-safe implementations
- Null safety enabled

## Testing

To test different scenarios:

1. **Light Theme**: Default theme
2. **Dark Theme**: Toggle from any screen
3. **Empty Cart**: Remove all items
4. **Login**: Use any email/password (mock)
5. **Product Filters**: Try different filter combinations
6. **Checkout**: Complete multi-step process

## Performance Considerations

- Efficient state management with GetX
- Image caching to reduce network calls
- Lazy loading of dependencies
- Debounced search queries
- Pagination ready (can be implemented in product list)

## Future Enhancements

- Real API integration
- User account management
- Payment gateway integration
- Order tracking
- Push notifications
- Reviews and ratings submission
- Wishlist functionality
- Social sharing
- Analytics integration
- Multi-language support

## License

This project is provided as a template for e-commerce applications.

## Support

For issues or questions, please refer to the code comments or GetX documentation.

---

**Created**: February 1, 2026
**Framework**: Flutter 3.10.8+
**State Management**: GetX 4.6.6+
