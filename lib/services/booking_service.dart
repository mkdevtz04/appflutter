import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ticketbooking/models/bus_model.dart';
import 'package:ticketbooking/models/event_model.dart';
import 'package:ticketbooking/models/booking_model.dart';

class BookingService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // ===== BUS OPERATIONS =====

  /// Fetch all buses
  Future<List<Bus>> getAllBuses() async {
    try {
      final response = await _supabase.from('buses').select();
      return (response as List).map((bus) => Bus.fromJson(bus)).toList();
    } catch (e) {
      throw Exception('Error fetching buses: $e');
    }
  }

  /// Fetch bus by ID
  Future<Bus> getBusById(String busId) async {
    try {
      final response = await _supabase.from('buses').select().eq('id', busId).single();
      return Bus.fromJson(response);
    } catch (e) {
      throw Exception('Error fetching bus: $e');
    }
  }

  /// Search buses by route
  Future<List<Bus>> searchBuses(String departure, String arrival) async {
    try {
      final response = await _supabase
          .from('buses')
          .select()
          .eq('departure', departure)
          .eq('arrival', arrival);
      return (response as List).map((bus) => Bus.fromJson(bus)).toList();
    } catch (e) {
      throw Exception('Error searching buses: $e');
    }
  }

  // ===== EVENT OPERATIONS =====

  /// Fetch all events
  Future<List<Event>> getAllEvents() async {
    try {
      final response = await _supabase.from('events').select();
      return (response as List).map((event) => Event.fromJson(event)).toList();
    } catch (e) {
      throw Exception('Error fetching events: $e');
    }
  }

  /// Fetch events by type
  Future<List<Event>> getEventsByType(String eventType) async {
    try {
      final response = await _supabase.from('events').select().eq('event_type', eventType);
      return (response as List).map((event) => Event.fromJson(event)).toList();
    } catch (e) {
      throw Exception('Error fetching events: $e');
    }
  }

  /// Fetch event by ID
  Future<Event> getEventById(String eventId) async {
    try {
      final response = await _supabase.from('events').select().eq('id', eventId).single();
      return Event.fromJson(response);
    } catch (e) {
      throw Exception('Error fetching event: $e');
    }
  }

  // ===== BOOKING OPERATIONS =====

  /// Create bus booking
  Future<Booking> createBusBooking({
    required String busId,
    required int quantity,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      // Get bus details to calculate total price
      final bus = await getBusById(busId);
      final totalPrice = bus.price * quantity;

      final booking = Booking(
        id: '',
        userId: userId,
        bookingType: 'bus',
        busId: busId,
        eventId: '',
        quantity: quantity,
        totalPrice: totalPrice,
        bookingDate: DateTime.now().toString(),
        status: 'confirmed',
      );

      final response = await _supabase.from('bookings').insert(booking.toJson()).select().single();
      return Booking.fromJson(response);
    } catch (e) {
      throw Exception('Error creating bus booking: $e');
    }
  }

  /// Create event booking
  Future<Booking> createEventBooking({
    required String eventId,
    required int quantity,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      // Get event details to calculate total price
      final event = await getEventById(eventId);
      final totalPrice = event.price * quantity;

      final booking = Booking(
        id: '',
        userId: userId,
        bookingType: 'event',
        busId: '',
        eventId: eventId,
        quantity: quantity,
        totalPrice: totalPrice,
        bookingDate: DateTime.now().toString(),
        status: 'confirmed',
      );

      final response = await _supabase.from('bookings').insert(booking.toJson()).select().single();
      return Booking.fromJson(response);
    } catch (e) {
      throw Exception('Error creating event booking: $e');
    }
  }

  /// Get user bookings
  Future<List<Booking>> getUserBookings() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final response = await _supabase.from('bookings').select().eq('user_id', userId);
      return (response as List).map((booking) => Booking.fromJson(booking)).toList();
    } catch (e) {
      throw Exception('Error fetching bookings: $e');
    }
  }

  /// Cancel booking
  Future<void> cancelBooking(String bookingId) async {
    try {
      await _supabase.from('bookings').update({'status': 'cancelled'}).eq('id', bookingId);
    } catch (e) {
      throw Exception('Error cancelling booking: $e');
    }
  }
}
