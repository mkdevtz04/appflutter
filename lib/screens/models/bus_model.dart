class Bus {
  final String id;
  final String busName;
  final String departure;
  final String arrival;
  final String departureTime;
  final String arrivalTime;
  final double price;
  final int availableSeats;
  final String image;
  final String busCompany;
  final String route;

  Bus({
    required this.id,
    required this.busName,
    required this.departure,
    required this.arrival,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
    required this.availableSeats,
    required this.image,
    required this.busCompany,
    required this.route,
  });

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      id: json['id'] ?? '',
      busName: json['bus_name'] ?? '',
      departure: json['departure'] ?? '',
      arrival: json['arrival'] ?? '',
      departureTime: json['departure_time'] ?? '',
      arrivalTime: json['arrival_time'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      availableSeats: json['available_seats'] ?? 0,
      image: json['image'] ?? '',
      busCompany: json['bus_company'] ?? '',
      route: json['route'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bus_name': busName,
      'departure': departure,
      'arrival': arrival,
      'departure_time': departureTime,
      'arrival_time': arrivalTime,
      'price': price,
      'available_seats': availableSeats,
      'image': image,
      'bus_company': busCompany,
      'route': route,
    };
  }
}