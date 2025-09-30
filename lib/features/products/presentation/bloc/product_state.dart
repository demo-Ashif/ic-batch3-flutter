part of 'product_bloc.dart';

enum ProductStatus { initial, loading, success, failure }

class ProductState extends Equatable {
  const ProductState({
    required this.status,
    required this.products,
    this.errorMessage,
  });

  const ProductState.initial()
    : status = ProductStatus.initial,
      products = const [],
      errorMessage = null;

  final ProductStatus status;
  final List<Product> products;
  final String? errorMessage;

  ProductState copyWith({
    ProductStatus? status,
    List<Product>? products,
    String? errorMessage,
  }) {
    return ProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, products, errorMessage];
}

