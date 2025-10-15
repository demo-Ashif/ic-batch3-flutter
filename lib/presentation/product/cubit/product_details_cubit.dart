import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ic_batch3_flutter_classes/domain/repository/product_details_repository.dart';
import 'package:ic_batch3_flutter_classes/presentation/product/cubit/product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit({required this.repository}) : super(ProductDetailsInitial());

  final ProductDetailsRepository repository;

  Future<void> loadProductDetails(int productId) async {

    emit(ProductDetailsLoading());

    try {
      final productDetails = await repository.getProductDetails(productId);
      emit(ProductDetailsLoaded(productDetails: productDetails));
    } catch (e) {
      emit(ProductDetailsError(message: e.toString()));
    }
  }
}