import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ic_batch3_flutter_classes/domain/models/brand.dart';
import 'package:ic_batch3_flutter_classes/domain/repository/brand_repository.dart';

part 'brand_event.dart';
part 'brand_state.dart';

class BrandBloc extends Bloc<BrandEvent, BrandState> {
  BrandBloc({required this.repository}) : super(const BrandState.initial()) {
    on<BrandRequested>(_onRequested);
  }

  final BrandRepository repository;

  Future<void> _onRequested(
    BrandRequested event,
    Emitter<BrandState> emit,
  ) async {
    emit(state.copyWith(status: BrandStatus.loading));
    try {
      final brands = await repository.getBrands();
      emit(state.copyWith(status: BrandStatus.success, brands: brands));
    } catch (e) {
      emit(
        state.copyWith(status: BrandStatus.failure, errorMessage: e.toString()),
      );
    }
  }
}
