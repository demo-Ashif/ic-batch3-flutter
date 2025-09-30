import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ic_batch3_flutter_classes/features/products/domain/repository/brand_repository.dart';
import 'package:ic_batch3_flutter_classes/features/products/domain/repository/product_repository.dart';
import 'package:ic_batch3_flutter_classes/features/products/domain/repository/product_slider_repository.dart';
import 'package:ic_batch3_flutter_classes/features/products/presentation/bloc/brand_bloc.dart';
import 'package:ic_batch3_flutter_classes/features/products/presentation/bloc/product_bloc.dart';
import 'package:ic_batch3_flutter_classes/features/products/presentation/bloc/product_slider_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.brandRepository,
    required this.productSliderRepository,
    required this.productRepository,
  });

  final BrandRepository brandRepository;
  final ProductSliderRepository productSliderRepository;
  final ProductRepository productRepository;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) =>
                  BrandBloc(repository: widget.brandRepository)
                    ..add(const BrandRequested()),
        ),
        BlocProvider(
          create:
              (_) =>
                  ProductSliderBloc(repository: widget.productSliderRepository)
                    ..add(const ProductSlidersRequested()),
        ),
        BlocProvider(
          create:
              (_) =>
                  ProductBloc(repository: widget.productRepository)
                    ..add(const ProductByBrandRequested(1)),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ecommerce App'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<ProductBloc>().add(const ProductByBrandRequested(1));
            context.read<BrandBloc>().add(const BrandRequested());
            context.read<ProductSliderBloc>().add(
              const ProductSlidersRequested(),
            );
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Slider Section
                BlocBuilder<ProductSliderBloc, ProductSliderState>(
                  builder: (context, sliderState) {
                    if (sliderState.status == ProductSliderStatus.loading) {
                      return const SizedBox(
                        height: 200,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (sliderState.status == ProductSliderStatus.failure) {
                      return const SizedBox.shrink();
                    }
                    if (sliderState.sliders.isEmpty)
                      return const SizedBox.shrink();
                    return Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: PageView.builder(
                            itemCount: sliderState.sliders.length,
                            itemBuilder: (context, index) {
                              final slider = sliderState.sliders[index];
                              return Container(
                                margin: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image:
                                      slider.imageUrl.isNotEmpty
                                          ? DecorationImage(
                                            image: NetworkImage(
                                              slider.imageUrl,
                                            ),
                                            fit: BoxFit.cover,
                                          )
                                          : null,
                                  color: Colors.grey[300],
                                ),
                                child:
                                    slider.imageUrl.isEmpty
                                        ? const Center(
                                          child: Icon(
                                            Icons.image,
                                            size: 50,
                                            color: Colors.grey,
                                          ),
                                        )
                                        : null,
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  },
                ),

                // Brand List Section
                BlocBuilder<BrandBloc, BrandState>(
                  builder: (context, brandState) {
                    if (brandState.status == BrandStatus.loading) {
                      return const SizedBox(
                        height: 100,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (brandState.status == BrandStatus.failure) {
                      return const SizedBox.shrink();
                    }
                    if (brandState.brands.isEmpty)
                      return const SizedBox.shrink();
                    final selectedBrandId =
                        context.watch<ProductBloc>().state.selectedBrandId;
                    return Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Brands',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount:
                                brandState.brands.length +
                                1, // +1 for "All" option
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                // "All" option
                                return GestureDetector(
                                  onTap: () {
                                    context.read<ProductBloc>().add(
                                      const ProductShowAllRequested(),
                                    );
                                  },
                                  child: Container(
                                    width: 80,
                                    margin: const EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      color:
                                          selectedBrandId == null
                                              ? Colors.blue
                                              : Colors.grey[300],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'All',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }

                              final brand = brandState.brands[index - 1];
                              return GestureDetector(
                                onTap: () {
                                  context.read<ProductBloc>().add(
                                    ProductByBrandRequested(brand.id),
                                  );
                                },
                                child: Container(
                                  width: 80,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    color:
                                        selectedBrandId == brand.id
                                            ? Colors.blue
                                            : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (brand.imageUrl != null &&
                                          brand.imageUrl!.isNotEmpty)
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            child: Image.network(
                                              brand.imageUrl!,
                                              fit: BoxFit.cover,
                                              errorBuilder: (
                                                context,
                                                error,
                                                stackTrace,
                                              ) {
                                                return const Icon(
                                                  Icons.branding_watermark,
                                                );
                                              },
                                            ),
                                          ),
                                        )
                                      else
                                        const Expanded(
                                          child: Icon(Icons.branding_watermark),
                                        ),
                                      Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Text(
                                          brand.name,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  },
                ),

                // Products Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Products',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      BlocBuilder<ProductBloc, ProductState>(
                        builder: (context, productState) {
                          if (productState.selectedBrandId != null) {
                            return TextButton(
                              onPressed: () {
                                context.read<ProductBloc>().add(
                                  const ProductShowAllRequested(),
                                );
                              },
                              child: const Text('Show All'),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                BlocBuilder<ProductBloc, ProductState>(
                  builder: (context, productState) {
                    if (productState.status == ProductStatus.loading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (productState.status == ProductStatus.failure) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            children: [
                              Text('Error: ${productState.errorMessage ?? ''}'),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed:
                                    () => context.read<ProductBloc>().add(
                                      const ProductByBrandRequested(1),
                                    ),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    if (productState.products.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: Text('No products found'),
                        ),
                      );
                    }
                    final products = productState.products;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return Card(
                          elevation: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(8),
                                    ),
                                    image:
                                        product.imageUrl.isNotEmpty
                                            ? DecorationImage(
                                              image: NetworkImage(
                                                product.imageUrl,
                                              ),
                                              fit: BoxFit.cover,
                                            )
                                            : null,
                                    color: Colors.grey[300],
                                  ),
                                  child:
                                      product.imageUrl.isEmpty
                                          ? const Center(
                                            child: Icon(
                                              Icons.image,
                                              size: 40,
                                              color: Colors.grey,
                                            ),
                                          )
                                          : null,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '\$${product.price.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        product.categoryDetail?.name ?? '',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
