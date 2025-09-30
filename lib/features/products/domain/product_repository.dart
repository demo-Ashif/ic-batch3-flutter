import 'package:ic_batch3_flutter_classes/features/products/domain/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
}

