import 'package:equatable/equatable.dart';

abstract class CountryEvent extends Equatable {
  const CountryEvent();

  @override
  List<Object?> get props => [];
}

class FetchCountries extends CountryEvent {
  const FetchCountries();
}

class RefreshCountries extends CountryEvent {
  const RefreshCountries();
}
