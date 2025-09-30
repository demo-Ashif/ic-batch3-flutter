import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ic_batch3_flutter_classes/domain/repository/brand_repository.dart';
import 'package:ic_batch3_flutter_classes/domain/repository/product_repository.dart';
import 'package:ic_batch3_flutter_classes/domain/repository/product_slider_repository.dart';
import 'package:ic_batch3_flutter_classes/presentation/product/bloc/brand_bloc.dart';
import 'package:ic_batch3_flutter_classes/presentation/product/bloc/product_bloc.dart';
import 'package:ic_batch3_flutter_classes/presentation/product/bloc/product_slider_bloc.dart';
import 'package:ic_batch3_flutter_classes/presentation/home/widgets/product_slider_widget.dart';
import 'package:ic_batch3_flutter_classes/presentation/home/widgets/brands_widget.dart';
import 'package:ic_batch3_flutter_classes/presentation/home/widgets/products_widget.dart';

class HomePage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) =>
                  BrandBloc(repository: brandRepository)
                    ..add(const BrandRequested()),
        ),
        BlocProvider(
          create:
              (_) =>
                  ProductSliderBloc(repository: productSliderRepository)
                    ..add(const ProductSlidersRequested()),
        ),
        BlocProvider(
          create:
              (_) =>
                  ProductBloc(repository: productRepository)
                    ..add(const ProductByBrandRequested(1)),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('EzShop'),
          actions: [
            IconButton(
              onPressed: () {
                // TODO: Add search functionality
              },
              icon: const Icon(Icons.search),
            ),
            IconButton(
              onPressed: () {
                // TODO: Add notifications
              },
              icon: const Icon(Icons.notifications_outlined),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<ProductBloc>().add(const ProductByBrandRequested(1));
            context.read<BrandBloc>().add(const BrandRequested());
            context.read<ProductSliderBloc>().add(
              const ProductSlidersRequested(),
            );
          },
          child: const SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                ProductSliderWidget(),
                BrandsWidget(),
                ProductsWidget(),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
