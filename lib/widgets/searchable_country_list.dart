import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/country_bloc.dart';
import '../blocs/country_event.dart';
import '../blocs/country_state.dart';
import '../models/country.dart';
import 'country_list_item.dart';

class SearchableCountryList extends StatefulWidget {
  const SearchableCountryList({super.key});

  @override
  State<SearchableCountryList> createState() => _SearchableCountryListState();
}

class _SearchableCountryListState extends State<SearchableCountryList> {
  final TextEditingController _searchController = TextEditingController();
  List<Country> _filteredCountries = [];
  List<Country> _allCountries = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterCountries);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCountries() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _filteredCountries = _allCountries;
      });
    } else {
      setState(() {
        _filteredCountries =
            _allCountries.where((country) {
              return country.name.toLowerCase().contains(query) ||
                  country.capital.toLowerCase().contains(query) ||
                  country.shortDescription.toLowerCase().contains(query);
            }).toList();
      });
    }
  }

  void _updateCountries(List<Country> countries) {
    setState(() {
      _allCountries = countries;
      _filteredCountries = countries;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CountryBloc, CountryState>(
      listener: (context, state) {
        if (state is CountrySuccess) {
          _updateCountries(state.countries);
        }
      },
      child: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: BlocBuilder<CountryBloc, CountryState>(
              builder: (context, state) {
                if (state is CountryLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CountrySuccess) {
                  return _buildCountryList();
                } else if (state is CountryError) {
                  return _buildErrorWidget(state.message);
                } else {
                  return const Center(child: Text('No countries loaded'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search countries, capitals, or descriptions...',
          prefixIcon: const Icon(Icons.search),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 16.0,
          ),
        ),
      ),
    );
  }

  Widget _buildCountryList() {
    if (_filteredCountries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No countries found',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search terms',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<CountryBloc>().add(const RefreshCountries());
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: _filteredCountries.length,
        itemBuilder: (context, index) {
          final country = _filteredCountries[index];
          return CountryListItem(country: country);
        },
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
          const SizedBox(height: 16),
          Text(
            'Error loading countries',
            style: TextStyle(fontSize: 18, color: Colors.red[600]),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<CountryBloc>().add(const FetchCountries());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
