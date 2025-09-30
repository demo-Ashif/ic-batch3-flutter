import 'package:ic_batch3_flutter_classes/features/products/data/product_remote_data_source.dart';
import 'package:ic_batch3_flutter_classes/features/products/domain/product.dart';
import 'package:ic_batch3_flutter_classes/features/products/domain/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl({required this.remoteDataSource});

  final ProductRemoteDataSource remoteDataSource;

  @override
  Future<List<Product>> getProducts() {
    return remoteDataSource.fetchProducts();
  }
}

