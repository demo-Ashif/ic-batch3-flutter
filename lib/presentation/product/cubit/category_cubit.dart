import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ic_batch3_flutter_classes/domain/models/category.dart';
import 'package:ic_batch3_flutter_classes/domain/repository/category_repository.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit({required this.repository}) : super(const CategoryState.initial());

  final CategoryRepository repository;

  Future<void> loadCategories() async {
    emit(state.copyWith(status: CategoryStatus.loading));

    try {
      final categories = await repository.getCategories();
      emit(state.copyWith(status: CategoryStatus.success, categories: categories));
    } catch (e) {
      emit(
        state.copyWith(status: CategoryStatus.failure, errorMessage: e.toString()),
      );
    }
  }
}
