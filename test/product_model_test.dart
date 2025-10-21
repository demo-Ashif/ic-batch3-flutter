import 'package:flutter_test/flutter_test.dart';
import 'package:ic_batch3_flutter_classes/domain/models/product.dart';

void main(){
  test('Should create product model from valid json', (){

    //Arrange
    final jsonData = {
      'id': 1,
      'title': 'Test Product',
      'price': 99.99,
      'short_des': 'A test product',
      'remark': 'Test remark',
      'image': 'https://example.com/image.jpg',
      'brand': null,
      'category': null,
    };

    //ACT

    final product = Product.fromJson(jsonData);

    //Assert - Check if the result matches our expectations
    expect(product.id, equals(1));
    expect(product.title, equals('Test Product'));
    expect(product.price, equals(99.99));
    expect(product.shortDescription, equals('A test product'));
    expect(product.remark, equals('Test remark'));
    expect(product.imageUrl, equals('https://example.com/image.jpg'));
    expect(product.brand, isNull);
    expect(product.categoryDetail, isNull);
  });

  test('should handle string price and convert to number', () {
    // Arrange - Price as string (sometimes APIs return strings)
    final jsonData = {
      'id': 3,
      'title': 'String Price Product',
      'price': '75.50', // String instead of number
      'image': 'https://example.com/string.jpg',
    };

    // Act
    final product = Product.fromJson(jsonData);

    // Assert - Should convert string to number
    expect(product.price, equals(75.50));
    expect(product.price, isA<num>());
  });
}