import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Business Logic Layer - Data Models
class Product extends Equatable {
  final int id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String category;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.category,
  });

  @override
  List<Object?> get props => [id, name, description, price, stock, category];
}

// Business Logic Layer - State
class ProductState extends Equatable {
  final List<Product> products;
  final List<Product> filteredProducts;
  final String selectedCategory;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final double totalValue;

  const ProductState({
    this.products = const [],
    this.filteredProducts = const [],
    this.selectedCategory = 'All',
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.totalValue = 0.0,
  });

  ProductState copyWith({
    List<Product>? products,
    List<Product>? filteredProducts,
    String? selectedCategory,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    double? totalValue,
  }) {
    return ProductState(
      products: products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
      totalValue: totalValue ?? this.totalValue,
    );
  }

  @override
  List<Object?> get props => [
    products,
    filteredProducts,
    selectedCategory,
    isLoading,
    isSuccess,
    errorMessage,
    totalValue,
  ];
}

// Business Logic Layer - Cubit
class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(const ProductState()) {
    _loadProducts();
  }

  void _loadProducts() {
    emit(state.copyWith(isLoading: true));

    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      final products = [
        const Product(
          id: 1,
          name: 'Laptop',
          description: 'High-performance laptop for developers',
          price: 1299.99,
          stock: 15,
          category: 'Electronics',
        ),
        const Product(
          id: 2,
          name: 'Smartphone',
          description: 'Latest smartphone with advanced features',
          price: 899.99,
          stock: 25,
          category: 'Electronics',
        ),
        const Product(
          id: 3,
          name: 'Coffee Maker',
          description: 'Automatic coffee maker for home use',
          price: 89.99,
          stock: 30,
          category: 'Home & Kitchen',
        ),
        const Product(
          id: 4,
          name: 'Running Shoes',
          description: 'Comfortable running shoes for athletes',
          price: 129.99,
          stock: 40,
          category: 'Sports',
        ),
        const Product(
          id: 5,
          name: 'Bookshelf',
          description: 'Modern wooden bookshelf',
          price: 199.99,
          stock: 12,
          category: 'Furniture',
        ),
      ];

      final totalValue = products.fold<double>(
        0.0,
        (sum, product) => sum + (product.price * product.stock),
      );

      emit(
        state.copyWith(
          products: products,
          filteredProducts: products,
          isLoading: false,
          isSuccess: true,
          totalValue: totalValue,
        ),
      );
    });
  }

  void filterByCategory(String category) {
    final filteredProducts =
        category == 'All'
            ? state.products
            : state.products
                .where((product) => product.category == category)
                .toList();

    emit(
      state.copyWith(
        selectedCategory: category,
        filteredProducts: filteredProducts,
      ),
    );
  }

  void searchProducts(String query) {
    if (query.isEmpty) {
      filterByCategory(state.selectedCategory);
      return;
    }

    final searchResults =
        state.products.where((product) {
          return product.name.toLowerCase().contains(query.toLowerCase()) ||
              product.description.toLowerCase().contains(query.toLowerCase()) ||
              product.category.toLowerCase().contains(query.toLowerCase());
        }).toList();

    emit(state.copyWith(filteredProducts: searchResults));
  }

  void clearSearch() {
    filterByCategory(state.selectedCategory);
  }
}

// UI Layer - Widgets
class SeparationConcernsScreen extends StatelessWidget {
  const SeparationConcernsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductCubit(),
      child: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('09. Separation of Concerns'),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Separation of UI and Business Logic',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'This example demonstrates how to separate UI logic from business logic using BLoC pattern.',
                    style: TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 24),

                  // Search and Filter Section
                  _buildSearchAndFilterSection(context, state),

                  const SizedBox(height: 16),

                  // Statistics Section
                  _buildStatisticsSection(state),

                  const SizedBox(height: 24),

                  // Products List
                  const Text(
                    'Products:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  Expanded(
                    child:
                        state.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : state.filteredProducts.isEmpty
                            ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'No products found',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            : ListView.builder(
                              itemCount: state.filteredProducts.length,
                              itemBuilder: (context, index) {
                                final product = state.filteredProducts[index];
                                return _buildProductCard(product);
                              },
                            ),
                  ),

                  const SizedBox(height: 24),

                  // Architecture Explanation
                  // _buildArchitectureExplanation(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchAndFilterSection(
    BuildContext context,
    ProductState state,
  ) {
    return Column(
      children: [
        // Search Bar
        TextField(
          decoration: InputDecoration(
            labelText: 'Search products...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              onPressed: () {
                context.read<ProductCubit>().clearSearch();
              },
              icon: const Icon(Icons.clear),
            ),
            border: const OutlineInputBorder(),
          ),
          onChanged: (query) {
            context.read<ProductCubit>().searchProducts(query);
          },
        ),

        const SizedBox(height: 16),

        // Category Filter
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children:
                [
                  'All',
                  'Electronics',
                  'Home & Kitchen',
                  'Sports',
                  'Furniture',
                ].map((category) {
                  final isSelected = state.selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          context.read<ProductCubit>().filterByCategory(
                            category,
                          );
                        }
                      },
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticsSection(ProductState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            'Total Products',
            '${state.products.length}',
            Icons.inventory,
            Colors.blue,
          ),
          _buildStatItem(
            'Filtered Products',
            '${state.filteredProducts.length}',
            Icons.filter_list,
            Colors.green,
          ),
          _buildStatItem(
            'Total Value',
            '\$${state.totalValue.toStringAsFixed(2)}',
            Icons.attach_money,
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.description,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      'Stock: ${product.stock}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.purple),
              ),
              child: Text(
                product.category,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArchitectureExplanation() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Architecture Benefits:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          SizedBox(height: 12),
          Text('✅ UI only handles presentation and user interaction'),
          Text('✅ Business logic is isolated in Cubit classes'),
          Text('✅ Data models are separate from UI widgets'),
          Text('✅ Easy to test business logic independently'),
          Text('✅ UI can be changed without affecting business logic'),
          Text('✅ Business logic can be reused across different UIs'),
          Text('✅ Clear separation of responsibilities'),
          Text('✅ Maintainable and scalable code structure'),
        ],
      ),
    );
  }
}
