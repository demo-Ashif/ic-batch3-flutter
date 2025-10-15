import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ic_batch3_flutter_classes/domain/repository/brand_repository.dart';
import 'package:ic_batch3_flutter_classes/domain/repository/product_details_repository.dart';
import 'package:ic_batch3_flutter_classes/domain/repository/product_repository.dart';
import 'package:ic_batch3_flutter_classes/domain/repository/product_slider_repository.dart';
import 'package:ic_batch3_flutter_classes/presentation/product/cubit/brand_cubit.dart';
import 'package:ic_batch3_flutter_classes/presentation/product/cubit/product_cubit.dart';
import 'package:ic_batch3_flutter_classes/presentation/product/cubit/product_slider_cubit.dart';
import 'package:ic_batch3_flutter_classes/presentation/home/widgets/product_slider_widget.dart';
import 'package:ic_batch3_flutter_classes/presentation/home/widgets/brands_widget.dart';
import 'package:ic_batch3_flutter_classes/presentation/product/widgets/products_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.brandRepository,
    required this.productSliderRepository,
    required this.productRepository,
    required this.productDetailsRepository,
  });

  final BrandRepository brandRepository;
  final ProductSliderRepository productSliderRepository;
  final ProductRepository productRepository;
  final ProductDetailsRepository productDetailsRepository;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => BrandCubit(repository: brandRepository)..loadBrands(),
        ),
        BlocProvider(
          create:
              (_) =>
                  ProductSliderCubit(repository: productSliderRepository)
                    ..loadSliders(),
        ),
        BlocProvider(
          create:
              (_) =>
                  ProductCubit(repository: productRepository)
                    ..loadProductsByBrand(1),
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
            context.read<ProductCubit>().loadProductsByBrand(1);
            context.read<BrandCubit>().loadBrands();
            context.read<ProductSliderCubit>().loadSliders();
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                ProductSliderWidget(),
                BrandsWidget(),
                ProductsWidget(
                  productDetailsRepository: productDetailsRepository,
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
