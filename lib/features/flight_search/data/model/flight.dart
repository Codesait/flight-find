class Flight {
  final String flightNumber;
  final String airlineName;
  final String airlineLogo;
  final String departureCity;
  final String arrivalCity;
  final String departureTime;
  final String arrivalTime;
  final double price;
  final String aircraft;
  final String duration;
  final int stops;
  final String details;
  final String? travelClass;

  Flight({
    required this.flightNumber,
    required this.airlineName,
    required this.airlineLogo,
    required this.departureCity,
    required this.arrivalCity,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
    required this.aircraft,
    required this.duration,
    required this.stops,
    required this.details,
    this.travelClass,
  });

  factory Flight.fromJson(Map<String, dynamic> json) {
    return Flight(
      flightNumber: json['flightNumber'] as String,
      airlineName: json['airlineName'] as String,
      airlineLogo: json['airlineLogo'] as String,
      departureCity: json['departureCity'] as String,
      arrivalCity: json['arrivalCity'] as String,
      departureTime: json['departureTime'] as String,
      arrivalTime: json['arrivalTime'] as String,
      price: (json['price'] as num).toDouble(),
      aircraft: json['aircraft'] as String,
      duration: json['duration'] as String,
      stops: json['stops'] as int,
      details: json['details'] as String,
      travelClass: json['class'] as String?,
    );
  }
}
