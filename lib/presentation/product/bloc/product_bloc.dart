import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ic_batch3_flutter_classes/domain/models/product.dart';
import 'package:ic_batch3_flutter_classes/domain/repository/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc({required this.repository})
    : super(const ProductState.initial()) {
    // on<ProductRequested>(_onProductsRequested);
    on<ProductByBrandRequested>(_onProductsByBrandRequested);
    // on<ProductShowAllRequested>(_onShowAllRequested);
  }

  final ProductRepository repository;

  // Future<void> _onProductsRequested(
  //   ProductRequested event,
  //   Emitter<ProductState> emit,
  // ) async {
  //   emit(state.copyWith(status: ProductStatus.loading, selectedBrandId: null));
  //   try {
  //     final products = await repository.getProducts();
  //     emit(
  //       state.copyWith(
  //         status: ProductStatus.success,
  //         products: products,
  //         selectedBrandId: null,
  //       ),
  //     );
  //   } catch (e) {
  //     emit(
  //       state.copyWith(
  //         status: ProductStatus.failure,
  //         errorMessage: e.toString(),
  //       ),
  //     );
  //   }
  // }

  Future<void> _onProductsByBrandRequested(
    ProductByBrandRequested event,
    Emitter<ProductState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ProductStatus.loading,
        selectedBrandId: event.brandId,
      ),
    );
    try {
      final products = await repository.getProductsByBrand(event.brandId);
      emit(
        state.copyWith(
          status: ProductStatus.success,
          products: products,
          selectedBrandId: event.brandId,
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

  // Future<void> _onShowAllRequested(
  //   ProductShowAllRequested event,
  //   Emitter<ProductState> emit,
  // ) async {
  //   add(const ProductRequested());
  // }
}
