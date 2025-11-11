class Event {
  final String id;
  final String eventName;
  final String eventType;
  final String location;
  final String date;
  final String time;
  final double price;
  final int availableTickets;
  final String image;
  final String description;
  final String venue;

  Event({
    required this.id,
    required this.eventName,
    required this.eventType,
    required this.location,
    required this.date,
    required this.time,
    required this.price,
    required this.availableTickets,
    required this.image,
    required this.description,
    required this.venue,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? '',
      eventName: json['event_name'] ?? '',
      eventType: json['event_type'] ?? '',
      location: json['location'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      availableTickets: json['available_tickets'] ?? 0,
      image: json['image'] ?? '',
      description: json['description'] ?? '',
      venue: json['venue'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_name': eventName,
      'event_type': eventType,
      'location': location,
      'date': date,
      'time': time,
      'price': price,
      'available_tickets': availableTickets,
      'image': image,
      'description': description,
      'venue': venue,
    };
  }
}
