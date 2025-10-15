import 'package:equatable/equatable.dart';
import 'package:ic_batch3_flutter_classes/domain/models/product_details.dart';

abstract class ProductDetailsState extends Equatable {
  const ProductDetailsState();
  @override
  List<Object?> get props => [];
}

class ProductDetailsInitial extends ProductDetailsState {}

class ProductDetailsLoading extends ProductDetailsState {}

class ProductDetailsLoaded extends ProductDetailsState {
  const ProductDetailsLoaded({required this.productDetails});

  final ProductDetails productDetails;

  @override
  List<Object?> get props => [productDetails];
}

class ProductDetailsError extends ProductDetailsState {
  const ProductDetailsError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}