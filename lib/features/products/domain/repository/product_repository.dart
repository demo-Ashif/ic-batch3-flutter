import 'package:ic_batch3_flutter_classes/features/products/domain/models/product.dart';

abstract class ProductRepository {
  // Future<List<Product>> getProducts();
  Future<List<Product>> getProductsByBrand(int brandId);
}
