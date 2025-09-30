import 'package:ic_batch3_flutter_classes/data/remote_datasource/product_slider_remote_data_source.dart';
import 'package:ic_batch3_flutter_classes/domain/models/product_slider.dart';
import 'package:ic_batch3_flutter_classes/domain/repository/product_slider_repository.dart';

class ProductSliderRepositoryImpl implements ProductSliderRepository {
  ProductSliderRepositoryImpl({required this.remoteDataSource});

  final ProductSliderRemoteDataSource remoteDataSource;

  @override
  Future<List<ProductSlider>> getProductSliders() {
    return remoteDataSource.fetchProductSliders();
  }
}
