import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ic_batch3_flutter_classes/domain/models/product_slider.dart';
import 'package:ic_batch3_flutter_classes/domain/repository/product_slider_repository.dart';

part 'product_slider_event.dart';
part 'product_slider_state.dart';

class ProductSliderBloc extends Bloc<ProductSliderEvent, ProductSliderState> {
  ProductSliderBloc({required this.repository})
    : super(const ProductSliderState.initial()) {
    on<ProductSlidersRequested>(_onRequested);
  }

  final ProductSliderRepository repository;

  Future<void> _onRequested(
    ProductSlidersRequested event,
    Emitter<ProductSliderState> emit,
  ) async {
    emit(state.copyWith(status: ProductSliderStatus.loading));
    try {
      final sliders = await repository.getProductSliders();
      emit(
        state.copyWith(status: ProductSliderStatus.success, sliders: sliders),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProductSliderStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
