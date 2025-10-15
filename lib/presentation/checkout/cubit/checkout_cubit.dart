import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ic_batch3_flutter_classes/core/storage/token_storage.dart';
import 'package:ic_batch3_flutter_classes/domain/repository/invoice_repository.dart';
import 'package:ic_batch3_flutter_classes/presentation/checkout/cubit/checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit({required this.invoiceRepository, required this.tokenStorage})
    : super(const CheckoutState());

  final InvoiceRepository invoiceRepository;
  final TokenStorage tokenStorage;

  Future<String?> _getToken() async => tokenStorage.readToken();

  Future<void> createInvoice() async {
    final token = await _getToken();
    if (token == null || token.isEmpty) {
      emit(
        state.copyWith(
          status: CheckoutStatus.error,
          errorMessage: 'No authentication token found',
        ),
      );
      return;
    }

    emit(state.copyWith(status: CheckoutStatus.loading));
    try {
      final response = await invoiceRepository.createInvoice(token: token);
      if (response.data.isNotEmpty) {
        emit(
          state.copyWith(
            status: CheckoutStatus.loaded,
            invoiceData: response.data.first,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: CheckoutStatus.error,
            errorMessage: 'No invoice data received',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: CheckoutStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
