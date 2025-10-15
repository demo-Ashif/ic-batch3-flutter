import 'package:ic_batch3_flutter_classes/data/remote_datasource/invoice_remote_data_source.dart';
import 'package:ic_batch3_flutter_classes/domain/models/invoice_response.dart';
import 'package:ic_batch3_flutter_classes/domain/repository/invoice_repository.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  InvoiceRepositoryImpl({required this.remoteDataSource});

  final InvoiceRemoteDataSource remoteDataSource;

  @override
  Future<InvoiceResponse> createInvoice({required String token}) async {
    return await remoteDataSource.createInvoice(token: token);
  }
}
