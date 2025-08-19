import 'package:equatable/equatable.dart';

class Country extends Equatable {
  final int id;
  final String name;
  final String capital;
  final String shortDescription;
  final String flag;

  const Country({
    required this.id,
    required this.name,
    required this.capital,
    required this.shortDescription,
    required this.flag,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'] as int,
      name: json['name'] as String,
      capital: json['capital'] as String,
      shortDescription: json['short_description'] as String,
      flag: json['flag'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'capital': capital,
      'short_description': shortDescription,
      'flag': flag,
    };
  }

  @override
  List<Object?> get props => [id, name, capital, shortDescription, flag];

  @override
  String toString() {
    return 'Country(id: $id, name: $name, capital: $capital, shortDescription: $shortDescription, flag: $flag)';
  }
}
