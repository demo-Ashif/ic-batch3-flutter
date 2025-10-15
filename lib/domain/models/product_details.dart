import 'package:equatable/equatable.dart';
import 'package:ic_batch3_flutter_classes/domain/models/product.dart';

class ProductDetails extends Equatable {
  const ProductDetails({
    required this.id,
    required this.img1,
    required this.img2,
    required this.img3,
    required this.img4,
    required this.description,
    required this.color,
    required this.size,
    required this.productId,
    required this.product,
  });

  final int id;
  final String img1;
  final String img2;
  final String img3;
  final String img4;
  final String description;
  final String color;
  final String size;
  final int productId;
  final Product product;

  List<String> get images => [img1, img2, img3, img4];
  List<String> get colors => color.split(',').map((c) => c.trim()).toList();
  List<String> get sizes => size.split(',').map((s) => s.trim()).toList();

  factory ProductDetails.fromJson(Map<String, dynamic> json) {

    return ProductDetails(
      id: (json['id'] as num).toInt(),
      img1: json['img1'] as String? ?? '',
      img2: json['img2'] as String? ?? '',
      img3: json['img3'] as String? ?? '',
      img4: json['img4'] as String? ?? '',
      description: json['des'] as String? ?? '',
      color: json['color'] as String? ?? '',
      size: json['size'] as String? ?? '',
      productId: (json['product_id'] as num).toInt(),
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
    );

  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'img1': img1,
    'img2': img2,
    'img3': img3,
    'img4': img4,
    'des': description,
    'color': color,
    'size': size,
    'product_id': productId,
    'product': product.toJson(),
  };

  @override
  List<Object?> get props => [
    id,
    img1,
    img2,
    img3,
    img4,
    description,
    color,
    size,
    productId,
    product,
  ];
}