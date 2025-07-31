import 'package:flutter/material.dart';
import 'responsive_helper.dart';
import 'responsive_widget.dart';

/// Use cases for responsive widgets
class ResponsiveUseCases extends StatelessWidget {
  const ResponsiveUseCases({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const ResponsiveText(text: 'Responsive Widget Use Cases'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: ResponsiveHelper.getResponsivePadding(context),
        child: Column(
          children: [
            
            _buildEcommerceUseCase(context),
            const SizedBox(height: 24),
            _buildDashboardUseCase(context),
            const SizedBox(height: 24),
            _buildNavigationUseCase(context),
          ],
        ),
      ),
    );
  }

  // Use Case 1: E-commerce Product Card
  Widget _buildEcommerceUseCase(BuildContext context) {
    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ResponsiveText(
            text: '1. E-commerce Product Card',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 16),
          ResponsiveWidget(
            mobile: Column(
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: ResponsiveText(text: 'Product Image'),
                  ),
                ),
                const SizedBox(height: 12),
                const ResponsiveText(
                  text: 'Premium Wireless Headphones',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const ResponsiveText(
                  text: '\$299.99',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ResponsiveButton(
                  text: 'Add to Cart',
                  onPressed: () {},
                  widthPercentage: 1.0,
                ),
              ],
            ),
            tablet: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: ResponsiveText(text: 'Product Image'),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ResponsiveText(
                        text: 'Premium Wireless Headphones',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const ResponsiveText(
                        text: '\$299.99',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ResponsiveButton(
                        text: 'Add to Cart',
                        onPressed: () {},
                        widthPercentage: 0.6,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            desktop: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: ResponsiveText(text: 'Product Image'),
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ResponsiveText(
                        text: 'Premium Wireless Headphones',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const ResponsiveText(
                        text:
                            'High-quality wireless headphones with noise cancellation',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const ResponsiveText(
                        text: '\$299.99',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          ResponsiveButton(
                            text: 'Add to Cart',
                            onPressed: () {},
                            widthPercentage: 0.4,
                          ),
                          const SizedBox(width: 12),
                          ResponsiveButton(
                            text: 'Wishlist',
                            onPressed: () {},
                            backgroundColor: Colors.transparent,
                            textColor: Colors.blue,
                            widthPercentage: 0.3,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Use Case 2: Dashboard Layout
  Widget _buildDashboardUseCase(BuildContext context) {
    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ResponsiveText(
            text: '2. Dashboard Layout',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 16),
          ResponsiveWidget(
            mobile: Column(
              children: [
                _buildDashboardCard(
                  'Total Sales',
                  '\$12,450',
                  Icons.trending_up,
                  Colors.green,
                ),
                const SizedBox(height: 12),
                _buildDashboardCard(
                  'Orders',
                  '156',
                  Icons.shopping_cart,
                  Colors.blue,
                ),
                const SizedBox(height: 12),
                _buildDashboardCard(
                  'Customers',
                  '89',
                  Icons.people,
                  Colors.orange,
                ),
                const SizedBox(height: 12),
                _buildDashboardCard(
                  'Revenue',
                  '\$8,920',
                  Icons.attach_money,
                  Colors.purple,
                ),
              ],
            ),
            tablet: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildDashboardCard(
                        'Total Sales',
                        '\$12,450',
                        Icons.trending_up,
                        Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDashboardCard(
                        'Orders',
                        '156',
                        Icons.shopping_cart,
                        Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildDashboardCard(
                        'Customers',
                        '89',
                        Icons.people,
                        Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDashboardCard(
                        'Revenue',
                        '\$8,920',
                        Icons.attach_money,
                        Colors.purple,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            desktop: Row(
              children: [
                Container(
                  width: 250,
                  child: Column(
                    children: [
                      _buildDashboardCard(
                        'Total Sales',
                        '\$12,450',
                        Icons.trending_up,
                        Colors.green,
                      ),
                      const SizedBox(height: 12),
                      _buildDashboardCard(
                        'Orders',
                        '156',
                        Icons.shopping_cart,
                        Colors.blue,
                      ),
                      const SizedBox(height: 12),
                      _buildDashboardCard(
                        'Customers',
                        '89',
                        Icons.people,
                        Colors.orange,
                      ),
                      const SizedBox(height: 12),
                      _buildDashboardCard(
                        'Revenue',
                        '\$8,920',
                        Icons.attach_money,
                        Colors.purple,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: ResponsiveText(
                        text:
                            'Main Dashboard Content\nCharts, Graphs, Analytics',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          ResponsiveText(
            text: title,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          ResponsiveText(
            text: value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Use Case 3: Navigation Menu
  Widget _buildNavigationUseCase(BuildContext context) {
    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ResponsiveText(
            text: '3. Navigation Menu',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 16),
          ResponsiveWidget(
            mobile: Row(
              children: [
                const ResponsiveText(
                  text: 'MyApp',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const Spacer(),
                IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
              ],
            ),
            tablet: Row(
              children: [
                const ResponsiveText(
                  text: 'MyApp',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const Spacer(),
                _buildNavItem('Home', Icons.home),
                const SizedBox(width: 16),
                _buildNavItem('Products', Icons.shopping_bag),
                const SizedBox(width: 16),
                _buildNavItem('About', Icons.info),
              ],
            ),
            desktop: Row(
              children: [
                const ResponsiveText(
                  text: 'MyApp',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const Spacer(),
                _buildNavItem('Home', Icons.home),
                const SizedBox(width: 24),
                _buildNavItem('Products', Icons.shopping_bag),
                const SizedBox(width: 24),
                _buildNavItem('About', Icons.info),
                const SizedBox(width: 24),
                _buildNavItem('Contact', Icons.contact_support),
                const SizedBox(width: 24),
                _buildNavItem('Blog', Icons.article),
                const SizedBox(width: 24),
                ResponsiveButton(
                  text: 'Sign In',
                  onPressed: () {},
                  widthPercentage: 0.15,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16),
        const SizedBox(width: 4),
        ResponsiveText(
          text: text,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
