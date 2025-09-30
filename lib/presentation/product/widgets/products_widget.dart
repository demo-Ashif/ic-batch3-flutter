import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ic_batch3_flutter_classes/domain/models/product.dart';
import 'package:ic_batch3_flutter_classes/presentation/product/cubit/product_cubit.dart';

class ProductsWidget extends StatefulWidget {
  const ProductsWidget({super.key});

  @override
  State<ProductsWidget> createState() => _ProductsWidgetState();
}

class _ProductsWidgetState extends State<ProductsWidget> {
  bool _isGridView = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ProductsHeader(
          isGridView: _isGridView,
          onViewToggle: (isGrid) {
            setState(() {
              _isGridView = isGrid;
            });
          },
        ),
        const SizedBox(height: 12),
        _ProductsContent(isGridView: _isGridView),
      ],
    );
  }
}

class _ProductsHeader extends StatelessWidget {
  const _ProductsHeader({required this.isGridView, required this.onViewToggle});

  final bool isGridView;
  final ValueChanged<bool> onViewToggle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Products',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              BlocBuilder<ProductCubit, ProductState>(
                builder: (context, productState) {
                  if (productState.selectedBrandId != null) {
                    return TextButton(
                      onPressed: () {
                        context.read<ProductCubit>().loadAllProducts();
                      },
                      child: const Text('Show All'),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(width: 8),
              _ViewToggleButtons(
                isGridView: isGridView,
                onViewToggle: onViewToggle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ViewToggleButtons extends StatelessWidget {
  const _ViewToggleButtons({
    required this.isGridView,
    required this.onViewToggle,
  });

  final bool isGridView;
  final ValueChanged<bool> onViewToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ToggleButton(
            icon: Icons.grid_view,
            isSelected: isGridView,
            onTap: () => onViewToggle(true),
          ),
          _ToggleButton(
            icon: Icons.list,
            isSelected: !isGridView,
            onTap: () => onViewToggle(false),
          ),
        ],
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  const _ToggleButton({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 20,
          color:
              isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _ProductsContent extends StatelessWidget {
  const _ProductsContent({required this.isGridView});

  final bool isGridView;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, productState) {
        if (productState.status == ProductStatus.loading) {
          return const _ProductsLoadingWidget();
        }

        if (productState.status == ProductStatus.failure) {
          return _ProductsErrorWidget(
            errorMessage: productState.errorMessage,
            onRetry: () => context.read<ProductCubit>().loadProductsByBrand(1),
          );
        }

        if (productState.products.isEmpty) {
          return const _ProductsEmptyWidget();
        }

        return _ProductsList(
          products: productState.products,
          isGridView: isGridView,
        );
      },
    );
  }
}

class _ProductsLoadingWidget extends StatelessWidget {
  const _ProductsLoadingWidget();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _ProductsErrorWidget extends StatelessWidget {
  const _ProductsErrorWidget({
    required this.errorMessage,
    required this.onRetry,
  });

  final String? errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error: ${errorMessage ?? 'Something went wrong'}',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

class _ProductsEmptyWidget extends StatelessWidget {
  const _ProductsEmptyWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No products found',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try selecting a different brand',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductsList extends StatelessWidget {
  const _ProductsList({required this.products, required this.isGridView});

  final List<Product> products;
  final bool isGridView;

  @override
  Widget build(BuildContext context) {
    if (isGridView) {
      return _ProductsGridView(products: products);
    } else {
      return _ProductsListView(products: products);
    }
  }
}

class _ProductsGridView extends StatelessWidget {
  const _ProductsGridView({required this.products});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _ProductGridCard(product: product);
      },
    );
  }
}

class _ProductsListView extends StatelessWidget {
  const _ProductsListView({required this.products});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _ProductListCard(product: product),
        );
      },
    );
  }
}

class _ProductGridCard extends StatelessWidget {
  const _ProductGridCard({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 4,
      shadowColor: colorScheme.shadow.withValues(alpha: 0.1),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // TODO: Navigate to product details
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image with Badge
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      color: colorScheme.surfaceVariant,
                    ),
                    child:
                        product.imageUrl.isNotEmpty
                            ? ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                              child: Image.network(
                                product.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: colorScheme.surfaceVariant,
                                    child: Icon(
                                      Icons.image_not_supported,
                                      size: 40,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  );
                                },
                              ),
                            )
                            : Container(
                              color: colorScheme.surfaceVariant,
                              child: Icon(
                                Icons.image,
                                size: 40,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                  ),

                  // Wishlist Button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surface.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.shadow.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () {
                          // TODO: Add to wishlist
                        },
                        icon: Icon(
                          Icons.favorite_border,
                          size: 20,
                          color: colorScheme.onSurface,
                        ),
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(
                          minWidth: 36,
                          minHeight: 36,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Product Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Badge
                    if (product.categoryDetail?.name != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          product.categoryDetail!.name,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                    if (product.categoryDetail?.name != null)
                      const SizedBox(height: 6),

                    // Product Title
                    Text(
                      product.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const Spacer(),

                    // Price and Rating Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 14,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '4.5',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductListCard extends StatelessWidget {
  const _ProductListCard({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      shadowColor: colorScheme.shadow.withValues(alpha: 0.05),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // TODO: Navigate to product details
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Product Image with Badge
              Stack(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: colorScheme.surfaceVariant,
                    ),
                    child:
                        product.imageUrl.isNotEmpty
                            ? ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                product.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: colorScheme.surfaceVariant,
                                    child: Icon(
                                      Icons.image_not_supported,
                                      size: 30,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  );
                                },
                              ),
                            )
                            : Container(
                              color: colorScheme.surfaceVariant,
                              child: Icon(
                                Icons.image,
                                size: 30,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                  ),

                  // Wishlist Button
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surface.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.shadow.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () {
                          // TODO: Add to wishlist
                        },
                        icon: Icon(
                          Icons.favorite_border,
                          size: 16,
                          color: colorScheme.onSurface,
                        ),
                        padding: const EdgeInsets.all(6),
                        constraints: const BoxConstraints(
                          minWidth: 28,
                          minHeight: 28,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 16),

              // Product Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Badge
                    if (product.categoryDetail?.name != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          product.categoryDetail!.name,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                    if (product.categoryDetail?.name != null)
                      const SizedBox(height: 8),

                    // Product Title
                    Text(
                      product.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    // Price and Rating Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 16,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '4.5',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Action Button
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () {
                    // TODO: Navigate to product details
                  },
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: colorScheme.onPrimaryContainer,
                  ),
                  padding: const EdgeInsets.all(12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
