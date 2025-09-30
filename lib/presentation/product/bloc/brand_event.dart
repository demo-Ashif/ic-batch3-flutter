part of 'brand_bloc.dart';

sealed class BrandEvent extends Equatable {
  const BrandEvent();

  @override
  List<Object?> get props => [];
}

class BrandRequested extends BrandEvent {
  const BrandRequested();
}
