# Flutter Testing Guide for Beginners

## Table of Contents
1. [What is Testing?](#what-is-testing)
2. [Types of Testing in Flutter](#types-of-testing-in-flutter)
3. [Unit Testing](#unit-testing)
4. [Widget Testing](#widget-testing)
5. [Testing Setup](#testing-setup)
6. [Best Practices](#best-practices)
7. [Running Tests](#running-tests)

## What is Testing?

**Testing** is the process of checking if your code works correctly. Think of it like checking your homework before submitting it to make sure all answers are correct.

### Why Testing is Important?
- ✅ **Find bugs early** - Catch problems before users do
- ✅ **Ensure code works** - Make sure your functions do what they're supposed to do
- ✅ **Safe refactoring** - Change code without breaking existing functionality
- ✅ **Documentation** - Tests show how your code should work
- ✅ **Confidence** - Know your app works correctly

## Types of Testing in Flutter

### 1. **Unit Testing** 
Tests individual functions, methods, or classes in isolation
- **Example**: Testing if a `Product.fromJson()` method correctly converts JSON to a Product object

### 2. **Widget Testing**
Tests individual widgets to ensure they display correctly and respond to user interactions
- **Example**: Testing if a button shows the correct text and responds to taps

### 3. **Integration Testing**
Tests the entire app or large parts of it working together
- **Example**: Testing the complete user flow from login to checkout

## Unit Testing

Unit tests are the foundation of testing. They test small, isolated pieces of code.

### Basic Unit Test Structure

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  // This is where your tests go
  group('Test Group Name', () {
    test('Test Description', () {
      // Arrange - Set up test data
      // Act - Call the function you want to test
      // Assert - Check if the result is what you expected
    });
  });
}
```

### Example 1: Testing Product Model

Let's test the `Product.fromJson()` method from your project:

```dart
// File: test/unit/product_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:ic_batch3_flutter_classes/domain/models/product.dart';

void main() {
  group('Product Model Tests', () {
    test('should create Product from valid JSON', () {
      // Arrange - Set up test data (what we expect to receive)
      final jsonData = {
        'id': 1,
        'title': 'Test Product',
        'price': 99.99,
        'short_des': 'A test product',
        'remark': 'Test remark',
        'image': 'https://example.com/image.jpg',
        'brand': null,
        'category': null,
      };

      // Act - Call the function we want to test
      final product = Product.fromJson(jsonData);

      // Assert - Check if the result matches our expectations
      expect(product.id, equals(1));
      expect(product.title, equals('Test Product'));
      expect(product.price, equals(99.99));
      expect(product.shortDescription, equals('A test product'));
      expect(product.remark, equals('Test remark'));
      expect(product.imageUrl, equals('https://example.com/image.jpg'));
      expect(product.brand, isNull);
      expect(product.categoryDetail, isNull);
    });

    test('should handle missing optional fields', () {
      // Arrange - JSON with missing optional fields
      final jsonData = {
        'id': 2,
        'title': 'Minimal Product',
        'price': 50,
        'image': 'https://example.com/minimal.jpg',
      };

      // Act
      final product = Product.fromJson(jsonData);

      // Assert - Check that optional fields are null
      expect(product.id, equals(2));
      expect(product.title, equals('Minimal Product'));
      expect(product.price, equals(50));
      expect(product.imageUrl, equals('https://example.com/minimal.jpg'));
      expect(product.shortDescription, isNull);
      expect(product.remark, isNull);
    });

    test('should handle string price and convert to number', () {
      // Arrange - Price as string (sometimes APIs return strings)
      final jsonData = {
        'id': 3,
        'title': 'String Price Product',
        'price': '75.50', // String instead of number
        'image': 'https://example.com/string.jpg',
      };

      // Act
      final product = Product.fromJson(jsonData);

      // Assert - Should convert string to number
      expect(product.price, equals(75.50));
      expect(product.price, isA<num>());
    });

    test('should handle empty title gracefully', () {
      // Arrange - Empty title
      final jsonData = {
        'id': 4,
        'title': '', // Empty title
        'price': 100,
        'image': 'https://example.com/empty.jpg',
      };

      // Act
      final product = Product.fromJson(jsonData);

      // Assert - Should handle empty string
      expect(product.title, equals(''));
    });
  });
}
```

### Example 2: Testing Repository Implementation

Let's test the `ProductRepositoryImpl` class:

```dart
// File: test/unit/product_repository_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:ic_batch3_flutter_classes/data/repository_impl/product_repository_impl.dart';
import 'package:ic_batch3_flutter_classes/data/remote_datasource/product_remote_data_source.dart';
import 'package:ic_batch3_flutter_classes/domain/models/product.dart';

// Mock class for testing (we'll create this)
class MockProductRemoteDataSource implements ProductRemoteDataSource {
  @override
  Future<List<Product>> fetchProductsByBrand(int brandId) async {
    // Return fake data for testing
    return [
      Product(
        id: 1,
        title: 'Test Product 1',
        price: 99.99,
        imageUrl: 'https://example.com/product1.jpg',
      ),
      Product(
        id: 2,
        title: 'Test Product 2',
        price: 149.99,
        imageUrl: 'https://example.com/product2.jpg',
      ),
    ];
  }

  @override
  Future<List<Product>> fetchProducts() async {
    return [];
  }
}

void main() {
  group('ProductRepositoryImpl Tests', () {
    late ProductRepositoryImpl repository;
    late MockProductRemoteDataSource mockDataSource;

    setUp(() {
      // This runs before each test
      mockDataSource = MockProductRemoteDataSource();
      repository = ProductRepositoryImpl(remoteDataSource: mockDataSource);
    });

    test('should return products when getProductsByBrand is called', () async {
      // Arrange
      const brandId = 1;

      // Act
      final result = await repository.getProductsByBrand(brandId);

      // Assert
      expect(result, isA<List<Product>>());
      expect(result.length, equals(2));
      expect(result[0].title, equals('Test Product 1'));
      expect(result[1].title, equals('Test Product 2'));
    });

    test('should return empty list when no products found', () async {
      // Arrange - Create a mock that returns empty list
      final emptyDataSource = MockProductRemoteDataSource();
      emptyDataSource.fetchProductsByBrand = (int brandId) async => [];
      final emptyRepository = ProductRepositoryImpl(remoteDataSource: emptyDataSource);

      // Act
      final result = await emptyRepository.getProductsByBrand(999);

      // Assert
      expect(result, isEmpty);
    });
  });
}
```

### Example 3: Testing Utility Functions

Let's create a simple utility function and test it:

```dart
// File: lib/utils/price_formatter.dart
class PriceFormatter {
  /// Formats a price with currency symbol
  static String formatPrice(num price) {
    return '\$${price.toStringAsFixed(2)}';
  }

  /// Calculates discount percentage
  static double calculateDiscount(num originalPrice, num discountedPrice) {
    if (originalPrice <= 0) return 0;
    return ((originalPrice - discountedPrice) / originalPrice) * 100;
  }
}

// File: test/unit/price_formatter_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:ic_batch3_flutter_classes/utils/price_formatter.dart';

void main() {
  group('PriceFormatter Tests', () {
    test('should format price correctly', () {
      // Arrange
      const price = 99.99;

      // Act
      final formatted = PriceFormatter.formatPrice(price);

      // Assert
      expect(formatted, equals('\$99.99'));
    });

    test('should format integer price correctly', () {
      // Arrange
      const price = 100;

      // Act
      final formatted = PriceFormatter.formatPrice(price);

      // Assert
      expect(formatted, equals('\$100.00'));
    });

    test('should calculate discount percentage correctly', () {
      // Arrange
      const originalPrice = 100.0;
      const discountedPrice = 80.0;

      // Act
      final discount = PriceFormatter.calculateDiscount(originalPrice, discountedPrice);

      // Assert
      expect(discount, equals(20.0));
    });

    test('should return 0 discount for invalid original price', () {
      // Arrange
      const originalPrice = 0.0;
      const discountedPrice = 80.0;

      // Act
      final discount = PriceFormatter.calculateDiscount(originalPrice, discountedPrice);

      // Assert
      expect(discount, equals(0.0));
    });
  });
}
```

## Widget Testing

Widget tests check if widgets display correctly and respond to user interactions.

### Basic Widget Test Structure

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Widget Test Description', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(MyWidget());
    
    // Find widgets and interact with them
    // Verify the results
  });
}
```

### Example 1: Testing a Simple Button Widget

Let's create and test a simple product card widget:

```dart
// File: lib/widgets/product_card.dart
import 'package:flutter/material.dart';
import 'package:ic_batch3_flutter_classes/domain/models/product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  final Product product;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(product.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Product Title
              Text(
                product.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              // Product Price
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// File: test/widget/product_card_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ic_batch3_flutter_classes/domain/models/product.dart';
import 'package:ic_batch3_flutter_classes/widgets/product_card.dart';

void main() {
  group('ProductCard Widget Tests', () {
    // Create a test product
    Product createTestProduct() {
      return Product(
        id: 1,
        title: 'Test Product',
        price: 99.99,
        imageUrl: 'https://example.com/test.jpg',
      );
    }

    testWidgets('should display product information correctly', (WidgetTester tester) async {
      // Arrange
      final product = createTestProduct();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductCard(product: product),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Product'), findsOneWidget);
      expect(find.text('\$99.99'), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('should call onTap when tapped', (WidgetTester tester) async {
      // Arrange
      final product = createTestProduct();
      bool wasTapped = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductCard(
              product: product,
              onTap: () {
                wasTapped = true;
              },
            ),
          ),
        ),
      );

      // Tap the card
      await tester.tap(find.byType(ProductCard));
      await tester.pump();

      // Assert
      expect(wasTapped, isTrue);
    });

    testWidgets('should handle long product title with ellipsis', (WidgetTester tester) async {
      // Arrange
      final product = Product(
        id: 1,
        title: 'This is a very long product title that should be truncated with ellipsis',
        price: 99.99,
        imageUrl: 'https://example.com/test.jpg',
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 200, // Constrain width to force truncation
              child: ProductCard(product: product),
            ),
          ),
        ),
      );

      // Assert
      expect(find.textContaining('This is a very long product title'), findsOneWidget);
      // The text should be truncated, so the full text shouldn't be found
      expect(find.textContaining('This is a very long product title that should be truncated with ellipsis'), findsNothing);
    });
  });
}
```

### Example 2: Testing HomePage Widget

Let's test the HomePage widget from your project:

```dart
// File: test/widget/home_page_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ic_batch3_flutter_classes/presentation/home/pages/home_page.dart';
import 'package:ic_batch3_flutter_classes/domain/repository/brand_repository.dart';
import 'package:ic_batch3_flutter_classes/domain/repository/product_repository.dart';
import 'package:ic_batch3_flutter_classes/domain/repository/product_slider_repository.dart';
import 'package:ic_batch3_flutter_classes/domain/repository/product_details_repository.dart';

// Mock repositories for testing
class MockBrandRepository implements BrandRepository {
  @override
  Future<List<dynamic>> getBrands() async => [];
}

class MockProductRepository implements ProductRepository {
  @override
  Future<List<dynamic>> getProductsByBrand(int brandId) async => [];
}

class MockProductSliderRepository implements ProductSliderRepository {
  @override
  Future<List<dynamic>> getSliders() async => [];
}

class MockProductDetailsRepository implements ProductDetailsRepository {
  @override
  Future<dynamic> getProductDetails(int productId) async => null;
}

void main() {
  group('HomePage Widget Tests', () {
    testWidgets('should display app bar with correct title', (WidgetTester tester) async {
      // Arrange
      final mockBrandRepo = MockBrandRepository();
      final mockProductRepo = MockProductRepository();
      final mockSliderRepo = MockProductSliderRepository();
      final mockDetailsRepo = MockProductDetailsRepository();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: HomePage(
            brandRepository: mockBrandRepo,
            productSliderRepository: mockSliderRepo,
            productRepository: mockProductRepo,
            productDetailsRepository: mockDetailsRepo,
          ),
        ),
      );

      // Assert
      expect(find.text('EzShop'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
    });

    testWidgets('should display main content widgets', (WidgetTester tester) async {
      // Arrange
      final mockBrandRepo = MockBrandRepository();
      final mockProductRepo = MockProductRepository();
      final mockSliderRepo = MockProductSliderRepository();
      final mockDetailsRepo = MockProductDetailsRepository();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: HomePage(
            brandRepository: mockBrandRepo,
            productSliderRepository: mockSliderRepo,
            productRepository: mockProductRepo,
            productDetailsRepository: mockDetailsRepo,
          ),
        ),
      );

      // Assert
      expect(find.byType(RefreshIndicator), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('should handle search button tap', (WidgetTester tester) async {
      // Arrange
      final mockBrandRepo = MockBrandRepository();
      final mockProductRepo = MockProductRepository();
      final mockSliderRepo = MockProductSliderRepository();
      final mockDetailsRepo = MockProductDetailsRepository();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: HomePage(
            brandRepository: mockBrandRepo,
            productSliderRepository: mockSliderRepo,
            productRepository: mockProductRepo,
            productDetailsRepository: mockDetailsRepo,
          ),
        ),
      );

      // Tap search button
      await tester.tap(find.byIcon(Icons.search));
      await tester.pump();

      // Assert - For now, we just verify the tap doesn't crash
      // In a real app, you'd test the search functionality
      expect(find.byIcon(Icons.search), findsOneWidget);
    });
  });
}
```

### Example 3: Testing Form Widget

Let's create and test a simple login form:

```dart
// File: lib/widgets/login_form.dart
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'Enter your email',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Handle login
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Login successful!')),
                );
              }
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

// File: test/widget/login_form_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ic_batch3_flutter_classes/widgets/login_form.dart';

void main() {
  group('LoginForm Widget Tests', () {
    testWidgets('should display form fields correctly', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoginForm(),
          ),
        ),
      );

      // Assert
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    testWidgets('should show validation error for empty email', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoginForm(),
          ),
        ),
      );

      // Tap login button without entering email
      await tester.tap(find.text('Login'));
      await tester.pump();

      // Assert
      expect(find.text('Please enter your email'), findsOneWidget);
    });

    testWidgets('should show validation error for invalid email', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoginForm(),
          ),
        ),
      );

      // Enter invalid email
      await tester.enterText(find.byType(TextFormField).first, 'invalid-email');
      await tester.tap(find.text('Login'));
      await tester.pump();

      // Assert
      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('should show validation error for short password', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoginForm(),
          ),
        ),
      );

      // Enter valid email and short password
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, '123');
      await tester.tap(find.text('Login'));
      await tester.pump();

      // Assert
      expect(find.text('Password must be at least 6 characters'), findsOneWidget);
    });

    testWidgets('should show success message for valid input', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoginForm(),
          ),
        ),
      );

      // Enter valid email and password
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.tap(find.text('Login'));
      await tester.pump();

      // Assert
      expect(find.text('Login successful!'), findsOneWidget);
    });
  });
}
```

## Testing Setup

### 1. Add Testing Dependencies

Add these to your `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.2  # For creating mock objects
  build_runner: ^2.4.7  # For generating mock files
```

### 2. Create Test Directory Structure

```
test/
├── unit/           # Unit tests
│   ├── models/
│   ├── repositories/
│   └── utils/
├── widget/         # Widget tests
│   ├── pages/
│   └── widgets/
└── integration/    # Integration tests
```

### 3. Generate Mock Files

Create `test/mocks/mock_repositories.dart`:

```dart
// File: test/mocks/mock_repositories.dart
import 'package:mockito/annotations.dart';
import 'package:ic_batch3_flutter_classes/domain/repository/product_repository.dart';
import 'package:ic_batch3_flutter_classes/domain/repository/brand_repository.dart';

@GenerateMocks([
  ProductRepository,
  BrandRepository,
])
void main() {}
```

Run this command to generate mock files:
```bash
flutter packages pub run build_runner build
```

## Best Practices

### 1. **Test Naming**
```dart
// Good: Descriptive test names
test('should return products when getProductsByBrand is called', () {
  // test code
});

// Bad: Vague test names
test('test product', () {
  // test code
});
```

### 2. **Arrange-Act-Assert Pattern**
```dart
test('should calculate total price correctly', () {
  // Arrange - Set up test data
  final products = [
    Product(id: 1, title: 'Product 1', price: 10.0, imageUrl: ''),
    Product(id: 2, title: 'Product 2', price: 20.0, imageUrl: ''),
  ];

  // Act - Call the function
  final total = calculateTotal(products);

  // Assert - Check the result
  expect(total, equals(30.0));
});
```

### 3. **One Test, One Concept**
```dart
// Good: Each test focuses on one thing
test('should return empty list when brandId is invalid', () {
  // test code
});

test('should return products when brandId is valid', () {
  // test code
});

// Bad: Testing multiple things in one test
test('should handle various brand scenarios', () {
  // testing multiple scenarios
});
```

### 4. **Use setUp and tearDown**
```dart
group('ProductRepository Tests', () {
  late ProductRepository repository;
  late MockDataSource mockDataSource;

  setUp(() {
    // This runs before each test
    mockDataSource = MockDataSource();
    repository = ProductRepository(dataSource: mockDataSource);
  });

  tearDown(() {
    // This runs after each test
    // Clean up resources if needed
  });
});
```

## Running Tests

### Run All Tests
```bash
flutter test
```

### Run Specific Test File
```bash
flutter test test/unit/product_test.dart
```

### Run Tests with Coverage
```bash
flutter test --coverage
```

### Run Tests in Watch Mode
```bash
flutter test --watch
```

## Summary

This guide covers the basics of testing in Flutter:

1. **Unit Testing**: Test individual functions and classes
2. **Widget Testing**: Test UI components and user interactions
3. **Best Practices**: Write clear, focused tests
4. **Setup**: Configure testing dependencies and structure

### Key Takeaways:
- ✅ Start with unit tests for your business logic
- ✅ Test widgets to ensure UI works correctly
- ✅ Use descriptive test names
- ✅ Follow Arrange-Act-Assert pattern
- ✅ Test one concept per test
- ✅ Use mocks for dependencies

Remember: **Testing is not about finding bugs, it's about preventing them!** 🚀
