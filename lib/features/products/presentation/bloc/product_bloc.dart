import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ic_batch3_flutter_classes/features/products/domain/product.dart';
import 'package:ic_batch3_flutter_classes/features/products/domain/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc({required this.repository})
    : super(const ProductState.initial()) {
    on<ProductRequested>(_onProductsRequested);
  }

  final ProductRepository repository;

  Future<void> _onProductsRequested(
    ProductRequested event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(status: ProductStatus.loading));
    try {
      final products = await repository.getProducts();
      emit(state.copyWith(status: ProductStatus.success, products: products));
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
