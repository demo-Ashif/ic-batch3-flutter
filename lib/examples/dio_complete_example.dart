import 'package:flutter/material.dart';
import 'package:ic_batch3_flutter_classes/core/network/dio_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Dio client
  final dioClient = DioClient.instance;
  dioClient.configureBaseUrl('https://ecommerce-api.codesilicon.com');
  dioClient.configureHeaders({
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });
  dioClient.configureTimeout(const Duration(seconds: 30));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dio Example App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const DioExamplePage(),
    );
  }
}

class DioExamplePage extends StatefulWidget {
  const DioExamplePage({super.key});

  @override
  State<DioExamplePage> createState() => _DioExamplePageState();
}

class _DioExamplePageState extends State<DioExamplePage> {
  final dioClient = DioClient.instance;
  String _response = 'No data yet';
  bool _isLoading = false;

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
      _response = 'Loading...';
    });

    try {
      // Get API client
      final apiClient = dioClient.apiClient;

      // Make API call
      final response = await apiClient.getMethod('/api/ListProductByBrand/1');

      setState(() {
        _response = 'Success!\n\nResponse: ${response.toString()}';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _response = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _testPostRequest() async {
    setState(() {
      _isLoading = true;
      _response = 'Loading POST request...';
    });

    try {
      final apiClient = dioClient.apiClient;

      // Example POST request
      final response = await apiClient.postMethod(
        '/api/test',
        data: {
          'message': 'Hello from Dio!',
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      setState(() {
        _response = 'POST Success!\n\nResponse: ${response.toString()}';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _response = 'POST Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dio API Client Example'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Dio API Client Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _isLoading ? null : _fetchProducts,
              child: Text(_isLoading ? 'Loading...' : 'Fetch Products (GET)'),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: _isLoading ? null : _testPostRequest,
              child: Text(_isLoading ? 'Loading...' : 'Test POST Request'),
            ),

            const SizedBox(height: 20),

            const Text(
              'Response:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _response,
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
