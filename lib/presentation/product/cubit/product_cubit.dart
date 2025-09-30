import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ic_batch3_flutter_classes/domain/models/product.dart';
import 'package:ic_batch3_flutter_classes/domain/repository/product_repository.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit({required this.repository})
    : super(const ProductState.initial());

  final ProductRepository repository;

  Future<void> loadProductsByBrand(int brandId) async {
    emit(
      state.copyWith(status: ProductStatus.loading, selectedBrandId: brandId),
    );

    try {
      final products = await repository.getProductsByBrand(brandId);
      emit(
        state.copyWith(
          status: ProductStatus.success,
          products: products,
          selectedBrandId: brandId,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProductStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> loadAllProducts() async {
    emit(state.copyWith(status: ProductStatus.loading, selectedBrandId: null));

    try {
      final products = await repository.getProductsByBrand(
        1,
      ); // Default to brand 1 for "all"
      emit(
        state.copyWith(
          status: ProductStatus.success,
          products: products,
          selectedBrandId: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProductStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
