
import 'package:ic_batch3_flutter_classes/domain/models/product_details.dart';
import 'package:ic_batch3_flutter_classes/domain/repository/product_details_repository.dart';

import '../remote_datasource/product_details_remote_datasource.dart';

class ProductDetailsRepositoryImpl implements ProductDetailsRepository {
  ProductDetailsRepositoryImpl({required this.remoteDataSource});

  final ProductDetailsRemoteDataSource remoteDataSource;

  @override
  Future<ProductDetails> getProductDetails(int productId) {
    return remoteDataSource.fetchProductDetails(productId);
  }
}