import 'package:flight_search/components/shared/gap.dart';
import 'package:flight_search/components/shared/page_indicator.dart';
import 'package:flight_search/components/shared/pageview.dart';
import 'package:flight_search/utils/utile_functions.dart';
import 'package:flutter/material.dart';

class SearchFlightResultsPage extends StatefulWidget {
  const SearchFlightResultsPage({this.flightResult, super.key});
  final Map<String, dynamic>? flightResult;

  static const String route = 'search-results';

  @override
  State<SearchFlightResultsPage> createState() =>
      _SearchFlightResultsPageState();
}

class _SearchFlightResultsPageState extends State<SearchFlightResultsPage> {
  late PageController _pageController;

  int _page = 0;
  void setPage(int i) {
    _page = i;
    setState(() {});
  }

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Get the extra data from GoRouter
    final searchParams =
        widget.flightResult?['searchParams'] as Map<String, dynamic>?;
    final results = widget.flightResult?['results'] as List<dynamic>?;

    // Fallbacks for demo
    final fromCity = searchParams?['fromCity'] ?? '-';
    final toCity = searchParams?['toCity'] ?? '-';
    final departureDate =
        searchParams?['departureDate'] != null
            ? (searchParams!['departureDate'] is DateTime
                ? searchParams['departureDate']
                : DateTime.tryParse(searchParams['departureDate'].toString()))
            : null;
    final passengers = searchParams?['passengers'] ?? 1;

    return Scaffold(
      appBar: const _FlightResultsAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Origin and Destination Header
          _OriginDestinationHeader(
            originCode: 'LAXD',
            originCity: fromCity.toString(),
            destinationCode: 'MFGT',
            destinationCity: toCity.toString(),
          ),
          const SizedBox(height: 16),
          // Date and Adult Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '${departureDate != null ? UtileFunctions.formatDate(departureDate) : '-'} • $passengers Adult${passengers == 1 ? '' : 's'}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 24),

          //* Sort & Filter Row
          _SortFilterRow(onSortTap: () {}, onFilterTap: () {}),
          const SizedBox(height: 24),

          //* Flight Cards Horizontal List
          Expanded(
            child:
                results == null || results.isEmpty
                    ? const Center(child: Text('No flights found.'))
                    : Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: CustomPageView(
                            pageController: _pageController,
                            pageSnapping: false,
                            onPageChange: setPage,
                            autoScrollDuration: const Duration(seconds: 5),
                            pages:
                                results
                                    .map(
                                      (flight) => Padding(
                                        padding: const EdgeInsets.only(
                                          right: 16,
                                          left: 10,
                                        ),

                                        child: _FlightCard(
                                          price:
                                              (flight.price is int)
                                                  ? flight.price
                                                  : (flight.price is double)
                                                  ? flight.price.round()
                                                  : int.tryParse(
                                                        flight.price.toString(),
                                                      ) ??
                                                      0,
                                          flightClass:
                                              flight.travelClass ?? '-',
                                          airlineLogo: flight.airlineLogo ?? '',
                                          airlineName:
                                              flight.airlineName ?? '-',
                                          stops:
                                              flight.stops == 0
                                                  ? 'Non-stop'
                                                  : '${flight.stops} Stop',
                                          departureTime:
                                              UtileFunctions.formatTime(
                                                flight.departureTime,
                                              ),
                                          arrivalTime:
                                              UtileFunctions.formatTime(
                                                flight.arrivalTime,
                                              ),
                                          duration: flight.duration ?? '-',
                                          departureAirportCode: '-',
                                          arrivalAirportCode: '-',
                                          onTap: () {},
                                        ),
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),
                        const Gap(24),
                        PageViewIndicator(
                          itemCount: results.length,
                          currentPage: _page,
                        ),
                      ],
                    ),
          ),
        ],
      ),
    );
  }
}

/// Private Widget: App Bar for the Flight Results Page
class _FlightResultsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _FlightResultsAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent, // Transparent background
      elevation: 0, // No shadow
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          // Handle back button press
          Navigator.pop(context);
        },
      ),
      title: const Text(
        'Flights',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Private Widget: Displays Origin and Destination with a plane icon in between
class _OriginDestinationHeader extends StatelessWidget {
  final String originCode;
  final String originCity;
  final String destinationCode;
  final String destinationCity;

  const _OriginDestinationHeader({
    required this.originCode,
    required this.originCity,
    required this.destinationCode,
    required this.destinationCity,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                originCode,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                originCity,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.flight, color: Colors.blue.shade700, size: 28),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                destinationCode,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                destinationCity,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Private Widget: Row for Sort and Filter options
class _SortFilterRow extends StatelessWidget {
  final VoidCallback onSortTap;
  final VoidCallback onFilterTap;

  const _SortFilterRow({required this.onSortTap, required this.onFilterTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Sort & Filter',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          GestureDetector(
            onTap: onFilterTap, // Use onFilterTap for the icon
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons
                    .sort, // Using sort icon as it resembles the filter icon in the image
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Private Widget: Individual Flight Card for horizontal list
class _FlightCard extends StatelessWidget {
  final int price;
  final String flightClass;
  final String airlineLogo;
  final String airlineName;
  final String stops;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final String departureAirportCode;
  final String arrivalAirportCode;
  final VoidCallback onTap;

  const _FlightCard({
    required this.price,
    required this.flightClass,
    required this.airlineLogo,
    required this.airlineName,
    required this.stops,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.departureAirportCode,
    required this.arrivalAirportCode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280, // Fixed width for each card
        decoration: BoxDecoration(
          color: Colors.blue.shade700, // Dark blue background for the card
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Price and Class Tag
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(
                    alpha: .2,
                  ), // Semi-transparent white
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Text(
                  '\$$price • $flightClass',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Airline Logo and Name
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(
                      airlineLogo,
                      height: 50,
                      width: 150,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Text(
                          airlineName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      airlineName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            // Flight Details at the bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(
                    alpha: 0.2,
                  ), // Dark overlay for readability
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stops,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$departureAirportCode $departureTime • $arrivalAirportCode $arrivalTime • $duration',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
