import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/country_bloc.dart';
import '../blocs/country_event.dart';
import '../repositories/country_repository.dart';
import '../widgets/searchable_country_list.dart';

class CountryListScreen extends StatelessWidget {
  const CountryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              CountryBloc(countryRepository: CountryRepository())
                ..add(const FetchCountries()),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text(
            'Countries of the World',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: Colors.blue[600],
          elevation: 0,
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () {
                context.read<CountryBloc>().add(const RefreshCountries());
              },
              tooltip: 'Refresh countries',
            ),
          ],
        ),
        body: const SafeArea(child: SearchableCountryList()),
      ),
    );
  }
}
