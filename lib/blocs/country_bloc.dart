import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/country_repository.dart';
import 'country_event.dart';
import 'country_state.dart';

class CountryBloc extends Bloc<CountryEvent, CountryState> {
  final CountryRepository _countryRepository;

  CountryBloc({required CountryRepository countryRepository})
    : _countryRepository = countryRepository,
      super(CountryInitial()) {
    on<FetchCountries>(_onFetchCountries);
    on<RefreshCountries>(_onRefreshCountries);
  }

  Future<void> _onFetchCountries(
    FetchCountries event,
    Emitter<CountryState> emit,
  ) async {
    emit(CountryLoading());
    try {
      final countries = await _countryRepository.getCountries();
      emit(CountrySuccess(countries));
    } catch (e) {
      emit(CountryError(e.toString()));
    }
  }

  Future<void> _onRefreshCountries(
    RefreshCountries event,
    Emitter<CountryState> emit,
  ) async {
    try {
      final countries = await _countryRepository.getCountries();
      emit(CountrySuccess(countries));
    } catch (e) {
      emit(CountryError(e.toString()));
    }
  }
}
