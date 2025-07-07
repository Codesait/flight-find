import 'package:flight_search/components/shared/custom_text.dart';
import 'package:flight_search/components/shared/gap.dart';
import 'package:flight_search/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SearchFlights extends StatefulWidget {
  const SearchFlights({super.key});
  static const String route = 'search-flights';

  @override
  State<SearchFlights> createState() => _HomePageState();
}

class _HomePageState extends State<SearchFlights> {
  String _fromCity = '';
  String _toCity = '';
  String _tripType = 'One way'; // Default selected trip type
  DateTime? _departureDate;
  bool _directFlightsOnly = false;
  bool _includeNearbyAirports = false;
  String _travelClass = 'Economy';
  int _passengers = 1;

  // Controller for the date text field
  final TextEditingController _dateController = TextEditingController();

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

  void _onSearchFlights() {
    // Implement search logic here
    // For now, just print the selected values
    print('From: $_fromCity');
    print('To: $_toCity');
    print('Trip Type: $_tripType');
    print('Departure Date: $_departureDate');
    print('Direct Flights Only: $_directFlightsOnly');
    print('Include Nearby Airports: $_includeNearbyAirports');
    print('Travel Class: $_travelClass');
    print('Passengers: $_passengers');

    // You would typically trigger a Riverpod provider or a BLoC event here
    // For example: ref.read(flightSearchNotifierProvider.notifier).searchFlights(...)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _FlightSearchAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //* From Input Field
            _CityInputField(
              label: 'From',
              onChanged: (value) {
                setState(() {
                  _fromCity = value;
                });
              },
            ),
            const Gap(16),

            //* To Input Field
            _CityInputField(
              label: 'To',
              onChanged: (value) {
                setState(() {
                  _toCity = value;
                });
              },
            ),
            const Gap(24),

            //* Trip Type Segment Control
            _TripTypeSegmentControl(
              selectedValue: _tripType,
              onChanged: (value) {
                setState(() {
                  _tripType = value;
                });
              },
            ),
            const Gap(24),

            //* Departure Date Input Field
            _DateInputField(
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
            _FilterToggleRow(
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
            _FilterToggleRow(
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
            _FilterSelectionRow(
              label: 'Travel Class',
              value: _travelClass,
              onTap: () {
                // Simulate dropdown for Travel Class
                _showTravelClassSelection(rootNavigatorKey.currentContext!);
              },
            ),
            const Gap(16),

            //* Passengers Selection
            _FilterSelectionRow(
              label: 'Passengers',
              value: _passengers.toString(),
              onTap: () {
                // Simulate passenger selection
                _showPassengerSelection(rootNavigatorKey.currentContext!);
              },
            ),
            const Gap(40),

            //* Search Flights Button
            _SearchButton(onPressed: _onSearchFlights),
          ],
        ),
      ),
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

///* Input field for From/To cities
class _CityInputField extends StatelessWidget {
  final String label;
  final ValueChanged<String> onChanged;

  const _CityInputField({required this.label, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade50, // Light blue background
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.blueGrey.shade700),
          border: InputBorder.none, // No border for TextFormField
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          suffixIcon: const Icon(
            Icons.unfold_more,
            color: Colors.grey,
          ), // Up/down arrow icon
        ),
        onChanged: onChanged,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }
}

///* Segment control for One way, Round trip, Multi-City
class _TripTypeSegmentControl extends StatefulWidget {
  final String selectedValue;
  final ValueChanged<String> onChanged;

  const _TripTypeSegmentControl({
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  State<_TripTypeSegmentControl> createState() =>
      _TripTypeSegmentControlState();
}

class _TripTypeSegmentControlState extends State<_TripTypeSegmentControl> {
  late String _currentSelection;

  @override
  void initState() {
    super.initState();
    _currentSelection = widget.selectedValue;
  }

  @override
  void didUpdateWidget(covariant _TripTypeSegmentControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedValue != widget.selectedValue) {
      _currentSelection = widget.selectedValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:
            Colors.blue.shade50, // Light blue background for the whole control
        borderRadius: BorderRadius.circular(50),
      ),
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children:
            ['One way', 'Round trip', 'Multi-City'].map((type) {
              bool isSelected = _currentSelection == type;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentSelection = type;
                    });
                    widget.onChanged(type);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(45),
                    ),
                    alignment: Alignment.center,
                    child: TextView(
                      text: type,

                      color:
                          isSelected ? Colors.black : Colors.blueGrey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}

///* Input field for Departure Date
class _DateInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onTap;

  const _DateInputField({required this.controller, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade50, // Light blue background
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        readOnly: true, // Make it read-only so date picker is the only input
        decoration: InputDecoration(
          labelText: 'Departure Date',
          labelStyle: TextStyle(color: Colors.blueGrey.shade700),
          border: InputBorder.none, // No border for TextFormField
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
        ),
        onTap: onTap,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }
}

///* Row for filter toggles (e.g., Direct Flights Only)
class _FilterToggleRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _FilterToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.blue.shade700,
        ),
      ],
    );
  }
}

///* Row for filter selections (e.g., Travel Class, Passengers)
class _FilterSelectionRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _FilterSelectionRow({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            Row(
              children: [
                Text(
                  value,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

///* Search Flights Button
class _SearchButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SearchButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Make button full width
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent, // Button background color
          foregroundColor: Colors.white, // Button text color
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
          elevation: 5, // Shadow
        ),
        child: const Text(
          'Search Flights',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
