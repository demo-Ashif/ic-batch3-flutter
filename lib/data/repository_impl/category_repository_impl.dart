import 'package:ic_batch3_flutter_classes/data/remote_datasource/category_remote_data_source.dart';
import 'package:ic_batch3_flutter_classes/domain/models/category.dart';
import 'package:ic_batch3_flutter_classes/domain/repository/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl({required this.remoteDataSource});

  final CategoryRemoteDataSource remoteDataSource;

  @override
  Future<List<Category>> getCategories() {
    return remoteDataSource.fetchCategories();
  }
}
