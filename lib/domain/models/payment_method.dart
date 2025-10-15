import 'package:equatable/equatable.dart';

class PaymentMethod extends Equatable {
  const PaymentMethod({
    required this.name,
    required this.type,
    required this.logo,
    required this.gw,
    this.rFlag,
    this.redirectGatewayURL,
  });

  final String name;
  final String type;
  final String logo;
  final String gw;
  final String? rFlag;
  final String? redirectGatewayURL;

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
      logo: json['logo'] as String? ?? '',
      gw: json['gw'] as String? ?? '',
      rFlag: json['r_flag'] as String?,
      redirectGatewayURL: json['redirectGatewayURL'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'type': type,
    'logo': logo,
    'gw': gw,
    'r_flag': rFlag,
    'redirectGatewayURL': redirectGatewayURL,
  };

  @override
  List<Object?> get props => [name, type, logo, gw, rFlag, redirectGatewayURL];
}
