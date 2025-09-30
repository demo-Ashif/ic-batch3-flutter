import 'package:flutter/material.dart';
import 'package:ic_batch3_flutter_classes/presentation/home/pages/home_page.dart';
import 'package:ic_batch3_flutter_classes/domain/repository/brand_repository.dart';
import 'package:ic_batch3_flutter_classes/domain/repository/product_repository.dart';
import 'package:ic_batch3_flutter_classes/domain/repository/product_slider_repository.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({
    super.key,
    required this.brandRepository,
    required this.productSliderRepository,
    required this.productRepository,
  });

  final BrandRepository brandRepository;
  final ProductSliderRepository productSliderRepository;
  final ProductRepository productRepository;

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      HomePage(
        brandRepository: widget.brandRepository,
        productSliderRepository: widget.productSliderRepository,
        productRepository: widget.productRepository,
      ),
      const _PlaceholderPage(title: 'Categories'),
      const _PlaceholderPage(title: 'Cart'),
      const _PlaceholderPage(title: 'Profile'),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_getIconForTitle(title), size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              '$title Page',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming Soon',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForTitle(String title) {
    switch (title) {
      case 'Categories':
        return Icons.category;
      case 'Cart':
        return Icons.shopping_cart;
      case 'Profile':
        return Icons.person;
      default:
        return Icons.help_outline;
    }
  }
}
