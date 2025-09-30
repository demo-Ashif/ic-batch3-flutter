import 'package:ic_batch3_flutter_classes/features/products/domain/models/product_slider.dart';

abstract class ProductSliderRepository {
  Future<List<ProductSlider>> getProductSliders();
}
