import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ic_batch3_flutter_classes/core/network/api_client.dart';
import 'package:ic_batch3_flutter_classes/features/products/data/product_remote_data_source.dart';
import 'package:ic_batch3_flutter_classes/features/products/data/product_repository_impl.dart';
import 'package:ic_batch3_flutter_classes/features/products/presentation/bloc/product_bloc.dart';
import 'package:ic_batch3_flutter_classes/features/products/presentation/pages/products_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiClient = ApiClient(baseUrl: 'https://fakestoreapi.com');
    final remote = ProductRemoteDataSource(apiClient: apiClient);
    final repo = ProductRepositoryImpl(remoteDataSource: remote);

    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => ProductBloc(repository: repo))],
      child: MaterialApp(
        title: 'Ecommerce (BLoC) Demo',
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
        home: const ProductsPage(),
      ),
    );
  }
}
