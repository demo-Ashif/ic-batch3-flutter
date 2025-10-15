import 'package:equatable/equatable.dart';
import 'package:ic_batch3_flutter_classes/domain/models/payment_method.dart';

class InvoiceResponse extends Equatable {
  const InvoiceResponse({required this.msg, required this.data});

  final String msg;
  final List<InvoiceData> data;

  factory InvoiceResponse.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List<dynamic>? ?? [];
    return InvoiceResponse(
      msg: json['msg'] as String? ?? '',
      data:
          dataList
              .map((item) => InvoiceData.fromJson(item as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'msg': msg,
    'data': data.map((item) => item.toJson()).toList(),
  };

  @override
  List<Object?> get props => [msg, data];
}

class InvoiceData extends Equatable {
  const InvoiceData({
    required this.paymentMethods,
    required this.payable,
    required this.vat,
    required this.total,
  });

  final List<PaymentMethod> paymentMethods;
  final int payable;
  final int vat;
  final int total;

  factory InvoiceData.fromJson(Map<String, dynamic> json) {
    final paymentMethodsList = json['paymentMethod'] as List<dynamic>? ?? [];
    return InvoiceData(
      paymentMethods:
          paymentMethodsList
              .map(
                (item) => PaymentMethod.fromJson(item as Map<String, dynamic>),
              )
              .toList(),
      payable: (json['payable'] as num?)?.toInt() ?? 0,
      vat: (json['vat'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'paymentMethod': paymentMethods.map((method) => method.toJson()).toList(),
    'payable': payable,
    'vat': vat,
    'total': total,
  };

  @override
  List<Object?> get props => [paymentMethods, payable, vat, total];
}
