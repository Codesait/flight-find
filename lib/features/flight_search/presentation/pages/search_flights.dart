import 'package:flight_search/components/shared/custom_text.dart';
import 'package:flight_search/components/shared/gap.dart';
import 'package:flight_search/core/router/app_router.dart';
import 'package:flight_search/features/flight_search/presentation/pages/search_flight_results_page.dart';
import 'package:flight_search/features/flight_search/presentation/widgets/cities_dropdown.dart';
import 'package:flight_search/features/flight_search/presentation/widgets/date_input.dart';
import 'package:flight_search/features/flight_search/presentation/widgets/filter_selector.dart';
import 'package:flight_search/features/flight_search/presentation/widgets/filter_toggle_switch.dart';
import 'package:flight_search/features/flight_search/presentation/widgets/search_flights_btn.dart';
import 'package:flight_search/features/flight_search/presentation/widgets/trip_type.dart';
import 'package:flight_search/features/flight_search/presentation/provider/flight_search_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class SearchFlights extends ConsumerStatefulWidget {
  const SearchFlights({super.key});
  static const String route = 'search-flights';

  @override
  ConsumerState<SearchFlights> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<SearchFlights> {
  String? _fromCity;
  String? _toCity;
  String _tripType = 'One way';
  DateTime? _departureDate;
  bool _directFlightsOnly = false;
  bool _includeNearbyAirports = false;
  String _travelClass = 'Economy';
  int _passengers = 1;
  bool _isLoading = false;

  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    Future.microtask(() {
      ref.read(flightSearchViewmodelProvider.notifier).getCities();
    });
    super.initState();
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _departureDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 365 * 5),
      ), // 5 years from now
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue.shade700,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue.shade700,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _departureDate) {
      setState(() {
        _departureDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(_departureDate!);
      });
    }
  }

  void _onSearchFlights() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final result = await ref
          .read(flightSearchViewmodelProvider.notifier)
          .performSearch(
            fromCity: _fromCity,
            toCity: _toCity,
            departureDate: _departureDate,
            tripType: _tripType,
            directFlightsOnly: _directFlightsOnly,
            includeNearbyAirports: _includeNearbyAirports,
            travelClass: _travelClass,
            passengers: _passengers,
          );
      if (mounted) {
        context.pushNamed(SearchFlightResultsPage.route, extra: result);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        rootNavigatorKey.currentContext!,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final citiesAsyncValue =
        ref.watch(flightSearchViewmodelProvider.notifier).getCities();
    return FutureBuilder<List<String>>(
      future: citiesAsyncValue,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Text(
                'Failed to load city data. Please check your assets and try again.',
                style: TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        final cities = snapshot.data ?? [];
        if (cities.isEmpty) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: Text('No cities found in city data.')),
          );
        }
        return Scaffold(
          appBar: const _FlightSearchAppBar(),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CityDropdownField(
                  label: 'From',
                  value: _fromCity,
                  items: cities,
                  onChanged: (val) => setState(() => _fromCity = val),
                ),
                const Gap(16),
                CityDropdownField(
                  label: 'To',
                  value: _toCity,
                  items: cities,
                  onChanged: (val) => setState(() => _toCity = val),
                ),
                const Gap(24),

                //* Trip Type Segment Control
                TripTypeSegmentControl(
                  selectedValue: _tripType,
                  onChanged: (value) {
                    setState(() {
                      _tripType = value;
                    });
                  },
                ),
                const Gap(24),

                //* Departure Date Input Field
                DateInputField(
                  controller: _dateController,
                  onTap: () => _selectDate(rootNavigatorKey.currentContext!),
                ),
                const Gap(32),

                //* Optional Filters Title
                const Text(
                  'Optional Filters',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Gap(16),

                //* Direct Flights Only Toggle
                FilterToggleRow(
                  label: 'Direct Flights Only',
                  value: _directFlightsOnly,
                  onChanged: (value) {
                    setState(() {
                      _directFlightsOnly = value;
                    });
                  },
                ),
                const Gap(16),

                //* Include Nearby Airports Toggle
                FilterToggleRow(
                  label: 'Include Nearby Airports',
                  value: _includeNearbyAirports,
                  onChanged: (value) {
                    setState(() {
                      _includeNearbyAirports = value;
                    });
                  },
                ),
                const Gap(16),

                //* Travel Class Selection
                FilterSelectionRow(
                  label: 'Travel Class',
                  value: _travelClass,
                  onTap: () {
                    // Simulate dropdown for Travel Class
                    _showTravelClassSelection(rootNavigatorKey.currentContext!);
                  },
                ),
                const Gap(16),

                //* Passengers Selection
                FilterSelectionRow(
                  label: 'Passengers',
                  value: _passengers.toString(),
                  onTap: () {
                    // Simulate passenger selection
                    _showPassengerSelection(rootNavigatorKey.currentContext!);
                  },
                ),
                const Gap(40),
              ],
            ),
          ),
          bottomSheet: SearchFlightsButton(
            onPressed: _isLoading ? null : () => _onSearchFlights(),
            isLoading: _isLoading,
          ),
        );
      },
    );
  }

  void _showTravelClassSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.airplane_ticket),
                title: const Text('Economy'),
                onTap: () {
                  setState(() {
                    _travelClass = 'Economy';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.business_center),
                title: const Text('Business'),
                onTap: () {
                  setState(() {
                    _travelClass = 'Business';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.first_page),
                title: const Text('First Class'),
                onTap: () {
                  setState(() {
                    _travelClass = 'First Class';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPassengerSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Select Passengers',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      setState(() {
                        if (_passengers > 1) _passengers--;
                      });
                      // To update the UI in the bottom sheet immediately
                      (context as Element).markNeedsBuild();
                    },
                  ),
                  Text(
                    '$_passengers',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () {
                      setState(() {
                        _passengers++;
                      });
                      // To update the UI in the bottom sheet immediately
                      (context as Element).markNeedsBuild();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                ),
                child: const Text('Done'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}

///* App Bar for the Flight Search Page
class _FlightSearchAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _FlightSearchAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent, // Transparent background
      elevation: 0, // No shadow

      title: const TextView(
        text: 'Search Flights',
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
