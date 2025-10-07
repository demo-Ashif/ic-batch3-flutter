import 'package:flutter/material.dart';
import 'package:ic_batch3_flutter_classes/core/network/api_client.dart';
import 'package:ic_batch3_flutter_classes/presentation/home/pages/main_navigation_page.dart';
import 'package:ic_batch3_flutter_classes/data/remote_datasource/brand_remote_data_source.dart';
import 'package:ic_batch3_flutter_classes/data/repository_impl/brand_repository_impl.dart';
import 'package:ic_batch3_flutter_classes/data/remote_datasource/category_remote_data_source.dart';
import 'package:ic_batch3_flutter_classes/data/repository_impl/category_repository_impl.dart';
import 'package:ic_batch3_flutter_classes/data/remote_datasource/product_remote_data_source.dart';
import 'package:ic_batch3_flutter_classes/data/repository_impl/product_repository_impl.dart';
import 'package:ic_batch3_flutter_classes/data/remote_datasource/product_slider_remote_data_source.dart';
import 'package:ic_batch3_flutter_classes/data/repository_impl/product_slider_repository_impl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize API client for the new ecommerce API

    final apiClient = ApiClient(
      baseUrl: 'https://ecommerce-api.codesilicon.com',
    );

    // Initialize data sources
    final brandRemoteDataSource = BrandRemoteDataSource(
        apiClient: apiClient
    );

    final categoryRemoteDataSource = CategoryRemoteDataSource(
        apiClient: apiClient
    );

    final productSliderRemoteDataSource = ProductSliderRemoteDataSource(
      apiClient: apiClient,
    );

    final productRemoteDataSource = ProductRemoteDataSource(
      apiClient: apiClient,
    );

    // Initialize repositories
    final brandRepository = BrandRepositoryImpl(
      remoteDataSource: brandRemoteDataSource,
    );
    final categoryRepository = CategoryRepositoryImpl(
      remoteDataSource: categoryRemoteDataSource,
    );
    final productSliderRepository = ProductSliderRepositoryImpl(
      remoteDataSource: productSliderRemoteDataSource,
    );
    final productRepository = ProductRepositoryImpl(
      remoteDataSource: productRemoteDataSource,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ecommerce App',
      theme: ThemeData(
        useMaterial3: true,

        colorSchemeSeed: const Color(0xFF6750A4),
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        chipTheme: ChipThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      home: MainNavigationPage(
        brandRepository: brandRepository,
        categoryRepository: categoryRepository,
        productSliderRepository: productSliderRepository,
        productRepository: productRepository,
      ),
    );
  }
}
