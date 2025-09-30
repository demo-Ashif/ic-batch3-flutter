import 'package:ic_batch3_flutter_classes/data/remote_datasource/product_remote_data_source.dart';
import 'package:ic_batch3_flutter_classes/domain/models/product.dart';
import 'package:ic_batch3_flutter_classes/domain/repository/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl({required this.remoteDataSource});

  final ProductRemoteDataSource remoteDataSource;

  // @override
  // Future<List<Product>> getProducts() {
  //   return remoteDataSource.fetchProducts();
  // }

  @override
  Future<List<Product>> getProductsByBrand(int brandId) {
    return remoteDataSource.fetchProductsByBrand(brandId);
  }
}
