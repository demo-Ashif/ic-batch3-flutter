import 'package:ic_batch3_flutter_classes/data/remote_datasource/brand_remote_data_source.dart';
import 'package:ic_batch3_flutter_classes/domain/models/brand.dart';
import 'package:ic_batch3_flutter_classes/domain/repository/brand_repository.dart';

class BrandRepositoryImpl implements BrandRepository {
  BrandRepositoryImpl({required this.remoteDataSource});

  final BrandRemoteDataSource remoteDataSource;

  @override
  Future<List<Brand>> getBrands() {
    return remoteDataSource.fetchBrands();
  }
}
