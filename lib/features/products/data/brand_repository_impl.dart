import 'package:ic_batch3_flutter_classes/features/products/data/brand_remote_data_source.dart';
import 'package:ic_batch3_flutter_classes/features/products/domain/models/brand.dart';
import 'package:ic_batch3_flutter_classes/features/products/domain/repository/brand_repository.dart';

class BrandRepositoryImpl implements BrandRepository {
  BrandRepositoryImpl({required this.remoteDataSource});

  final BrandRemoteDataSource remoteDataSource;

  @override
  Future<List<Brand>> getBrands() {
    return remoteDataSource.fetchBrands();
  }
}
