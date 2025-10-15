import 'package:ic_batch3_flutter_classes/core/network/api_client.dart';
import 'package:ic_batch3_flutter_classes/domain/models/invoice_response.dart';

class InvoiceRemoteDataSource {
  InvoiceRemoteDataSource({required this.apiClient});

  final ApiClient apiClient;

  Future<InvoiceResponse> createInvoice({required String token}) async {
    final result =
        await apiClient.get('/api/InvoiceCreate', headers: {'token': token})
            as Map<String, dynamic>;

    return InvoiceResponse.fromJson(result);
  }
}
