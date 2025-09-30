import 'package:ic_batch3_flutter_classes/domain/models/brand.dart';

abstract class BrandRepository {
  Future<List<Brand>> getBrands();
}
