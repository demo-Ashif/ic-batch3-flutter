import 'package:ic_batch3_flutter_classes/domain/models/invoice_response.dart';

abstract class InvoiceRepository {
  Future<InvoiceResponse> createInvoice({required String token});
}
