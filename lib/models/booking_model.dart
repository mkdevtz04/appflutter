class Booking {
  final String id;
  final String userId;
  final String bookingType;
  final String busId;
  final String eventId;
  final int quantity;
  final double totalPrice;
  final String bookingDate;
  final String status;

  Booking({
    required this.id,
    required this.userId,
    required this.bookingType,
    required this.busId,
    required this.eventId,
    required this.quantity,
    required this.totalPrice,
    required this.bookingDate,
    required this.status,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      bookingType: json['booking_type'] ?? '',
      busId: json['bus_id'] ?? '',
      eventId: json['event_id'] ?? '',
      quantity: json['quantity'] ?? 0,
      totalPrice: (json['total_price'] ?? 0).toDouble(),
      bookingDate: json['booking_date'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'booking_type': bookingType,
      'bus_id': busId,
      'event_id': eventId,
      'quantity': quantity,
      'total_price': totalPrice,
      'booking_date': bookingDate,
      'status': status,
    };
  }
}
