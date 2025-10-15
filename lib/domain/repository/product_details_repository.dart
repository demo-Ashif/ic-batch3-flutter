import 'package:ic_batch3_flutter_classes/domain/models/product_details.dart';

abstract class ProductDetailsRepository {
  Future<ProductDetails> getProductDetails(int productId);
}