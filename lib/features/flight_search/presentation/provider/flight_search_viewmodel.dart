import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/model/flight.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'flight_search_viewmodel.g.dart';

@riverpod
class FlightSearchViewmodel extends _$FlightSearchViewmodel {
  @override
  FutureOr<List<Flight>> build() async {
    return await _loadFlights();
  }

  Future<List<Flight>> _loadFlights() async {
    final String jsonString = await rootBundle.loadString(
      'assets/dummy/dummy_flight_data.json',
    );
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    final List<dynamic> jsonList = jsonMap['flights'] ?? [];
    print('Loaded ${jsonList.length} flights from JSON');
    return jsonList.map((e) => Flight.fromJson(e)).toList();
  }

  Future<List<String>> getCities() async {
    final String jsonString = await rootBundle.loadString(
      'assets/dummy/dummy_flight_data.json',
    );
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    final List<dynamic> citiesList = jsonMap['cities'] ?? [];
    final cities = <String>{};
    for (final city in citiesList) {
      if (city is Map && city['name'] != null) {
        cities.add(city['name']);
      }
    }
    return cities.toList()..sort();
  }

  Future<List<Flight>> searchFlights({String? from, String? to}) async {
    final flights = await _loadFlights();
    print('Searching from: $from, to: $to');
    for (final f in flights) {
      print(
        'Flight: [38;5;2m${f.departureCity}[0m -> [38;5;1m${f.arrivalCity}[0m',
      );
    }
    return flights.where((f) {
      final matchFrom =
          from == null ||
          from.isEmpty ||
          f.departureCity.trim().toLowerCase() == from.trim().toLowerCase();
      final matchTo =
          to == null ||
          to.isEmpty ||
          f.arrivalCity.trim().toLowerCase() == to.trim().toLowerCase();
      return matchFrom && matchTo;
    }).toList();
  }

  Future<Map<String, dynamic>> performSearch({
    required String? fromCity,
    required String? toCity,
    required DateTime? departureDate,
    required String tripType,
    required bool directFlightsOnly,
    required bool includeNearbyAirports,
    required String travelClass,
    required int passengers,
  }) async {
    if (fromCity == null || toCity == null || departureDate == null) {
      throw Exception('Please select From, To, and Departure Date.');
    }
    final results = await searchFlights(from: fromCity, to: toCity);
    final searchParams = {
      'fromCity': fromCity,
      'toCity': toCity,
      'departureDate': departureDate,
      'tripType': tripType,
      'directFlightsOnly': directFlightsOnly,
      'includeNearbyAirports': includeNearbyAirports,
      'travelClass': travelClass,
      'passengers': passengers,
    };
    return {'searchParams': searchParams, 'results': results};
  }
}

final fromCityProvider = StateProvider<String?>((ref) => null);
final toCityProvider = StateProvider<String?>((ref) => null);
