import 'package:flutter/material.dart';
import 'package:ic_batch3_flutter_classes/core/network/api_client.dart';
import 'package:ic_batch3_flutter_classes/core/network/dio_client.dart';
import 'package:ic_batch3_flutter_classes/data/remote_datasource/product_details_remote_datasource.dart';
import 'package:ic_batch3_flutter_classes/data/repository_impl/product_details_repository_impl.dart';
import 'package:ic_batch3_flutter_classes/presentation/home/pages/main_navigation_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ic_batch3_flutter_classes/data/remote_datasource/auth_remote_data_source.dart';
import 'package:ic_batch3_flutter_classes/data/remote_datasource/user_remote_data_source.dart';
import 'package:ic_batch3_flutter_classes/data/remote_datasource/cart_remote_data_source.dart';
import 'package:ic_batch3_flutter_classes/data/repository_impl/auth_repository_impl.dart';
import 'package:ic_batch3_flutter_classes/data/repository_impl/user_repository_impl.dart';
import 'package:ic_batch3_flutter_classes/data/repository_impl/cart_repository_impl.dart';
import 'package:ic_batch3_flutter_classes/domain/repository/auth_repository.dart';
import 'package:ic_batch3_flutter_classes/domain/repository/user_repository.dart';
import 'package:ic_batch3_flutter_classes/domain/repository/cart_repository.dart';
import 'package:ic_batch3_flutter_classes/core/storage/token_storage.dart';
import 'package:ic_batch3_flutter_classes/presentation/user/cubit/user_cubit.dart';
import 'package:ic_batch3_flutter_classes/presentation/cart/cubit/cart_cubit.dart';
import 'package:ic_batch3_flutter_classes/data/remote_datasource/brand_remote_data_source.dart';
import 'package:ic_batch3_flutter_classes/data/repository_impl/brand_repository_impl.dart';
import 'package:ic_batch3_flutter_classes/data/remote_datasource/category_remote_data_source.dart';
import 'package:ic_batch3_flutter_classes/data/repository_impl/category_repository_impl.dart';
import 'package:ic_batch3_flutter_classes/data/remote_datasource/product_remote_data_source.dart';
import 'package:ic_batch3_flutter_classes/data/repository_impl/product_repository_impl.dart';
import 'package:ic_batch3_flutter_classes/data/remote_datasource/product_slider_remote_data_source.dart';
import 'package:ic_batch3_flutter_classes/data/repository_impl/product_slider_repository_impl.dart';
import 'package:ic_batch3_flutter_classes/data/remote_datasource/invoice_remote_data_source.dart';
import 'package:ic_batch3_flutter_classes/data/repository_impl/invoice_repository_impl.dart';
import 'package:ic_batch3_flutter_classes/domain/repository/invoice_repository.dart';
import 'package:ic_batch3_flutter_classes/presentation/checkout/cubit/checkout_cubit.dart';

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

    // Initialize Dio client
    final dioClient = DioClient.instance;
    dioClient.configureBaseUrl('https://ecommerce-api.codesilicon.com');
    dioClient.configureHeaders({
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
    dioClient.configureTimeout(const Duration(seconds: 30));

    // DioApiClient is now available via dioClient.apiClient
    // You can use it like: dioClient.apiClient.getMethod('/api/endpoint')

    // Initialize data sources
    final brandRemoteDataSource = BrandRemoteDataSource(apiClient: apiClient);

    final categoryRemoteDataSource = CategoryRemoteDataSource(
      apiClient: apiClient,
    );

    final productSliderRemoteDataSource = ProductSliderRemoteDataSource(
      apiClient: apiClient,
    );

    final productRemoteDataSource = ProductRemoteDataSource(
      apiClient: dioClient.apiClient,
    );

    final productDetailsRemoteDataSource = ProductDetailsRemoteDataSource(
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

    final productDetailsRepository = ProductDetailsRepositoryImpl(
      remoteDataSource: productDetailsRemoteDataSource,
    );

    // Auth & User
    final authRemoteDataSource = AuthRemoteDataSource(apiClient: apiClient);
    final userRemoteDataSource = UserRemoteDataSource(apiClient: apiClient);
    final cartRemoteDataSource = CartRemoteDataSource(apiClient: apiClient);
    final invoiceRemoteDataSource = InvoiceRemoteDataSource(
      apiClient: apiClient,
    );
    final AuthRepository authRepository = AuthRepositoryImpl(
      remoteDataSource: authRemoteDataSource,
    );
    final UserRepository userRepository = UserRepositoryImpl(
      remoteDataSource: userRemoteDataSource,
    );
    final CartRepository cartRepository = CartRepositoryImpl(
      remoteDataSource: cartRemoteDataSource,
    );
    final InvoiceRepository invoiceRepository = InvoiceRepositoryImpl(
      remoteDataSource: invoiceRemoteDataSource,
    );
    final tokenStorage = TokenStorage();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) => UserCubit(
                authRepository: authRepository,
                userRepository: userRepository,
                tokenStorage: tokenStorage,
              )..initialize(),
        ),
        BlocProvider(
          create:
              (_) => CartCubit(
                cartRepository: cartRepository,
                tokenStorage: tokenStorage,
              )..loadCart(),
        ),
        BlocProvider(
          create:
              (_) => CheckoutCubit(
                invoiceRepository: invoiceRepository,
                tokenStorage: tokenStorage,
              ),
        ),
      ],
      child: MaterialApp(
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
          productDetailsRepository: productDetailsRepository,
        ),
      ),
    );
  }
}
