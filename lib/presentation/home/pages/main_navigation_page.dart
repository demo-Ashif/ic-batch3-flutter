import 'package:flutter/material.dart';
import 'package:ic_batch3_flutter_classes/domain/repository/product_details_repository.dart';
import 'package:ic_batch3_flutter_classes/presentation/home/pages/home_page.dart';
import 'package:ic_batch3_flutter_classes/presentation/product/pages/categories_page.dart';
import 'package:ic_batch3_flutter_classes/domain/repository/brand_repository.dart';
import 'package:ic_batch3_flutter_classes/domain/repository/category_repository.dart';
import 'package:ic_batch3_flutter_classes/domain/repository/product_repository.dart';
import 'package:ic_batch3_flutter_classes/domain/repository/product_slider_repository.dart';
import 'package:ic_batch3_flutter_classes/presentation/user/pages/profile_page.dart';
import 'package:ic_batch3_flutter_classes/presentation/cart/pages/cart_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({
    super.key,
    required this.brandRepository,
    required this.categoryRepository,
    required this.productSliderRepository,
    required this.productRepository,
    required this.productDetailsRepository,
  });

  final BrandRepository brandRepository;
  final CategoryRepository categoryRepository;
  final ProductSliderRepository productSliderRepository;
  final ProductRepository productRepository;
  final ProductDetailsRepository productDetailsRepository;

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(
        brandRepository: widget.brandRepository,
        productSliderRepository: widget.productSliderRepository,
        productRepository: widget.productRepository,
        productDetailsRepository: widget.productDetailsRepository,
      ),
      CategoriesPage(categoryRepository: widget.categoryRepository),
      const CartPage(),
      const ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.category_outlined),
            selectedIcon: Icon(Icons.category),
            label: 'Categories',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Removed unused placeholder page
