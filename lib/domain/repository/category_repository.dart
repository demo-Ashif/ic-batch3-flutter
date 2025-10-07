import 'package:ic_batch3_flutter_classes/domain/models/category.dart';

abstract class CategoryRepository {
  Future<List<Category>> getCategories();
}
