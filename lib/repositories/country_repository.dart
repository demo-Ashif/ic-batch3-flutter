import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/country.dart';

class CountryRepository {
  static const String _baseUrl = 'https://countrylist.teamrabbil.com/api';
  static const String _countryListEndpoint = '/country-list';

  Future<List<Country>> getCountries() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl$_countryListEndpoint'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Country.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load countries: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load countries: $e');
    }
  }
}
