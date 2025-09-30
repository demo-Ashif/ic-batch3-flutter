part of 'product_slider_bloc.dart';

sealed class ProductSliderEvent extends Equatable {
  const ProductSliderEvent();

  @override
  List<Object?> get props => [];
}

class ProductSlidersRequested extends ProductSliderEvent {
  const ProductSlidersRequested();
}
