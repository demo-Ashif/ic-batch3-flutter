part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

// class ProductRequested extends ProductEvent {
//   const ProductRequested();
// }

class ProductByBrandRequested extends ProductEvent {
  const ProductByBrandRequested(this.brandId);

  final int brandId;

  @override
  List<Object?> get props => [brandId];
}

class ProductShowAllRequested extends ProductEvent {
  const ProductShowAllRequested();
}
