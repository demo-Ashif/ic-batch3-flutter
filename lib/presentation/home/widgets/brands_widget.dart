import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ic_batch3_flutter_classes/domain/models/brand.dart';
import 'package:ic_batch3_flutter_classes/presentation/product/cubit/brand_cubit.dart';
import 'package:ic_batch3_flutter_classes/presentation/product/cubit/product_cubit.dart';

class BrandsWidget extends StatelessWidget {
  const BrandsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrandCubit, BrandState>(
      builder: (context, brandState) {
        if (brandState.status == BrandStatus.loading) {
          return const _BrandsLoadingWidget();
        }

        if (brandState.status == BrandStatus.failure ||
            brandState.brands.isEmpty) {
          return const SizedBox.shrink();
        }

        return _BrandsContent(brands: brandState.brands);
      },
    );
  }
}

class _BrandsLoadingWidget extends StatelessWidget {
  const _BrandsLoadingWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}

class _BrandsContent extends StatelessWidget {
  const _BrandsContent({required this.brands});

  final List<Brand> brands;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Brands',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: brands.length + 1, // +1 for "All" option
            itemBuilder: (context, index) {
              if (index == 0) {
                return _AllBrandChip();
              }
              final brand = brands[index - 1];
              return _BrandChip(brand: brand);
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _AllBrandChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final selectedBrandId = context.watch<ProductCubit>().state.selectedBrandId;
    final isSelected = selectedBrandId == null;

    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: FilterChip(
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            context.read<ProductCubit>().loadAllProducts();
          }
        },
        label: const Text('All'),
        avatar: const Icon(Icons.apps, size: 18),
        showCheckmark: false,
      ),
    );
  }
}

class _BrandChip extends StatelessWidget {
  const _BrandChip({required this.brand});

  final Brand brand;

  @override
  Widget build(BuildContext context) {
    final selectedBrandId = context.watch<ProductCubit>().state.selectedBrandId;
    final isSelected = selectedBrandId == brand.id;

    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: FilterChip(
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            context.read<ProductCubit>().loadProductsByBrand(brand.id);
          }
        },
        label: Text(brand.name, style: const TextStyle(fontSize: 12)),
        avatar:
            brand.imageUrl != null && brand.imageUrl!.isNotEmpty
                ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    brand.imageUrl!,
                    width: 24,
                    height: 24,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.branding_watermark, size: 18);
                    },
                  ),
                )
                : const Icon(Icons.branding_watermark, size: 18),
        showCheckmark: false,
      ),
    );
  }
}
