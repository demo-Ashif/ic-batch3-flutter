import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ic_batch3_flutter_classes/domain/repository/product_details_repository.dart';
import 'package:ic_batch3_flutter_classes/presentation/product/cubit/product_details_cubit.dart';
import 'package:ic_batch3_flutter_classes/presentation/product/cubit/product_details_state.dart';
import 'package:ic_batch3_flutter_classes/domain/models/product_details.dart';
import 'package:ic_batch3_flutter_classes/presentation/cart/cubit/cart_cubit.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({
    super.key,
    required this.productId,
    required this.productDetailsRepository,
  });

  final int productId;
  final ProductDetailsRepository productDetailsRepository;

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int _selectedImageIndex = 0;
  String? _selectedColor;
  String? _selectedSize;
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductDetailsCubit(
        repository: widget.productDetailsRepository,
      )..loadProductDetails(widget.productId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Product Details'),
          elevation: 0,
        ),
        body: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
          builder: (context, state) {

            if (state is ProductDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProductDetailsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${state.message}',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () {
                        context.read<ProductDetailsCubit>().loadProductDetails(widget.productId);
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is ProductDetailsLoaded) {
              final productDetails = state.productDetails;
              return _ProductDetailsContent(
                productDetails: productDetails,
                selectedImageIndex: _selectedImageIndex,
                selectedColor: _selectedColor,
                selectedSize: _selectedSize,
                quantity: _quantity,
                onImageChanged: (index) {
                  setState(() {
                    _selectedImageIndex = index;
                  });
                },
                onColorChanged: (color) {
                  setState(() {
                    _selectedColor = color;
                  });
                },
                onSizeChanged: (size) {
                  setState(() {
                    _selectedSize = size;
                  });
                },
                onQuantityChanged: (quantity) {
                  setState(() {
                    _quantity = quantity;
                  });
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _ProductDetailsContent extends StatelessWidget {
  const _ProductDetailsContent({
    required this.productDetails,
    required this.selectedImageIndex,
    required this.selectedColor,
    required this.selectedSize,
    required this.quantity,
    required this.onImageChanged,
    required this.onColorChanged,
    required this.onSizeChanged,
    required this.onQuantityChanged,
  });

  final ProductDetails productDetails;
  final int selectedImageIndex;
  final String? selectedColor;
  final String? selectedSize;
  final int quantity;
  final ValueChanged<int> onImageChanged;
  final ValueChanged<String> onColorChanged;
  final ValueChanged<String> onSizeChanged;
  final ValueChanged<int> onQuantityChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Images
                _ProductImageSection(
                  images: productDetails.images,
                  selectedIndex: selectedImageIndex,
                  onImageChanged: onImageChanged,
                ),

                const SizedBox(height: 24),

                // Product Info
                _ProductInfoSection(
                  productDetails: productDetails,
                ),

                const SizedBox(height: 24),

                // Color Selection
                if (productDetails.colors.isNotEmpty)
                  _ColorSelectionSection(
                    colors: productDetails.colors,
                    selectedColor: selectedColor,
                    onColorChanged: onColorChanged,
                  ),

                const SizedBox(height: 24),

                // Size Selection
                if (productDetails.sizes.isNotEmpty)
                  _SizeSelectionSection(
                    sizes: productDetails.sizes,
                    selectedSize: selectedSize,
                    onSizeChanged: onSizeChanged,
                  ),

                const SizedBox(height: 24),

                // Quantity Selection
                _QuantitySelectionSection(
                  quantity: quantity,
                  onQuantityChanged: onQuantityChanged,
                ),

                const SizedBox(height: 24),

                // Description
                _DescriptionSection(
                  description: productDetails.description,
                ),
              ],
            ),
          ),
        ),

        // Add to Cart Button
        _AddToCartSection(
          productDetails: productDetails,
          selectedColor: selectedColor,
          selectedSize: selectedSize,
          quantity: quantity,
        ),
      ],
    );
  }
}

class _ProductImageSection extends StatelessWidget {
  const _ProductImageSection({
    required this.images,
    required this.selectedIndex,
    required this.onImageChanged,
  });

  final List<String> images;
  final int selectedIndex;
  final ValueChanged<int> onImageChanged;

  @override
  Widget build(BuildContext context) {
    final validImages = images.where((img) => img.isNotEmpty).toList();

    if (validImages.isEmpty) {
      return Container(
        height: 300,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Icon(
            Icons.image,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return Column(
      children: [
        // Main Image
        Container(
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              validImages[selectedIndex],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.image_not_supported,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Image Thumbnails
        if (validImages.length > 1)
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: validImages.length,
              itemBuilder: (context, index) {
                final isSelected = index == selectedIndex;
                return GestureDetector(
                  onTap: () => onImageChanged(index),
                  child: Container(
                    width: 80,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        validImages[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                            child: Icon(
                              Icons.image_not_supported,
                              size: 24,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}


class _ProductInfoSection extends StatelessWidget {
  const _ProductInfoSection({required this.productDetails});

  final ProductDetails productDetails;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category
        if (productDetails.product.categoryDetail?.name != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              productDetails.product.categoryDetail!.name,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

        const SizedBox(height: 12),

        // Title
        Text(
          productDetails.product.title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        // Price
        Text(
          '\$${productDetails.product.price.toStringAsFixed(2)}',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}



class _ColorSelectionSection extends StatelessWidget {
  const _ColorSelectionSection({
    required this.colors,
    required this.selectedColor,
    required this.onColorChanged,
  });

  final List<String> colors;
  final String? selectedColor;
  final ValueChanged<String> onColorChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: colors.map((color) {
            final isSelected = selectedColor == color;
            return FilterChip(
              label: Text(color),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onColorChanged(color);
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _SizeSelectionSection extends StatelessWidget {
  const _SizeSelectionSection({
    required this.sizes,
    required this.selectedSize,
    required this.onSizeChanged,
  });

  final List<String> sizes;
  final String? selectedSize;
  final ValueChanged<String> onSizeChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Size',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: sizes.map((size) {
            final isSelected = selectedSize == size;
            return FilterChip(
              label: Text(size),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onSizeChanged(size);
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _QuantitySelectionSection extends StatelessWidget {
  const _QuantitySelectionSection({
    required this.quantity,
    required this.onQuantityChanged,
  });

  final int quantity;
  final ValueChanged<int> onQuantityChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quantity',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            IconButton(
              onPressed: quantity > 1 ? () => onQuantityChanged(quantity - 1) : null,
              icon: const Icon(Icons.remove),
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              quantity.toString(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 16),
            IconButton(
              onPressed: quantity < 99 ? () => onQuantityChanged(quantity + 1) : null,
              icon: const Icon(Icons.add),
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DescriptionSection extends StatelessWidget {
  const _DescriptionSection({required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    if (description.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          description,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _AddToCartSection extends StatelessWidget {

  const _AddToCartSection({
    required this.productDetails,
    required this.selectedColor,
    required this.selectedSize,
    required this.quantity,
  });

  final ProductDetails productDetails;
  final String? selectedColor;
  final String? selectedSize;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    final canAddToCart = _canAddToCart();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: canAddToCart ? () => _addToCart(context) : null,
            icon: const Icon(Icons.add_shopping_cart),
            label: Text('Add to Cart (\$${(productDetails.product.price * quantity).toStringAsFixed(2)})'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ),
    );
  }

  bool _canAddToCart() {
    final hasColors = productDetails.colors.isNotEmpty;
    final hasSizes = productDetails.sizes.isNotEmpty;

    if (hasColors && selectedColor == null) return false;
    if (hasSizes && selectedSize == null) return false;

    return quantity > 0;
  }

  void _addToCart(BuildContext context) {
    final color = selectedColor ?? (productDetails.colors.isNotEmpty ? productDetails.colors.first : 'Default');
    final size = selectedSize ?? (productDetails.sizes.isNotEmpty ? productDetails.sizes.first : 'Default');

    context.read<CartCubit>().addToCart(
      productId: productDetails.productId,
      color: color,
      size: size,
      qty: quantity,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added $quantity item${quantity > 1 ? 's' : ''} to cart'),
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: () {
            // Navigate to cart page
            // You can implement this navigation based on your app's routing
          },
        ),
      ),
    );
  }
}