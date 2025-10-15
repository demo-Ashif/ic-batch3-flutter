import 'package:equatable/equatable.dart';
import 'package:ic_batch3_flutter_classes/domain/models/invoice_response.dart';

enum CheckoutStatus { idle, loading, loaded, error }

class CheckoutState extends Equatable {
  const CheckoutState({
    this.status = CheckoutStatus.idle,
    this.invoiceData,
    this.errorMessage,
  });

  final CheckoutStatus status;
  final InvoiceData? invoiceData;
  final String? errorMessage;

  CheckoutState copyWith({
    CheckoutStatus? status,
    InvoiceData? invoiceData,
    String? errorMessage,
  }) {
    return CheckoutState(
      status: status ?? this.status,
      invoiceData: invoiceData ?? this.invoiceData,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, invoiceData, errorMessage];
}
