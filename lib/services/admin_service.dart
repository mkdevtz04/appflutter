import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ticketbooking/models/bus_model.dart';
import 'package:ticketbooking/models/event_model.dart';

class AdminService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Check if user is admin
  Future<bool> isUserAdmin() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      final response = await _supabase
          .from('user_roles')
          .select('role')
          .eq('user_id', user.id)
          .single();
      return response['role'] == 'admin';
    } catch (e) {
      return false;
    }
  }

  // Add Bus
  Future<Bus> addBus({
    required String busName,
    required String busCompany,
    required String departure,
    required String arrival,
    required String departureTime,
    required String arrivalTime,
    required String route,
    required double price,
    required int availableSeats,
    required String image,
  }) async {
    try {
      final bus = {
        'bus_name': busName,
        'bus_company': busCompany,
        'departure': departure,
        'arrival': arrival,
        'departure_time': departureTime,
        'arrival_time': arrivalTime,
        'route': route,
        'price': price,
        'available_seats': availableSeats,
        'image': image,
      };

      final response = await _supabase.from('buses').insert(bus).select().single();
      return Bus.fromJson(response);
    } catch (e) {
      throw Exception('Error adding bus: $e');
    }
  }

  // Add Event
  Future<Event> addEvent({
    required String eventName,
    required String eventType,
    required String location,
    required String venue,
    required String date,
    required String time,
    required String description,
    required double price,
    required int availableTickets,
    required String image,
  }) async {
    try {
      final event = {
        'event_name': eventName,
        'event_type': eventType,
        'location': location,
        'venue': venue,
        'date': date,
        'time': time,
        'description': description,
        'price': price,
        'available_tickets': availableTickets,
        'image': image,
      };

      final response = await _supabase.from('events').insert(event).select().single();
      return Event.fromJson(response);
    } catch (e) {
      throw Exception('Error adding event: $e');
    }
  }

  // Update Bus
  Future<Bus> updateBus({
    required String busId,
    required String busName,
    required String busCompany,
    required String departure,
    required String arrival,
    required String departureTime,
    required String arrivalTime,
    required String route,
    required double price,
    required int availableSeats,
    required String image,
  }) async {
    try {
      final bus = {
        'bus_name': busName,
        'bus_company': busCompany,
        'departure': departure,
        'arrival': arrival,
        'departure_time': departureTime,
        'arrival_time': arrivalTime,
        'route': route,
        'price': price,
        'available_seats': availableSeats,
        'image': image,
      };

      final response = await _supabase.from('buses').update(bus).eq('id', busId).select().single();
      return Bus.fromJson(response);
    } catch (e) {
      throw Exception('Error updating bus: $e');
    }
  }

  // Delete Bus
  Future<void> deleteBus(String busId) async {
    try {
      await _supabase.from('buses').delete().eq('id', busId);
    } catch (e) {
      throw Exception('Error deleting bus: $e');
    }
  }

  // Delete Event
  Future<void> deleteEvent(String eventId) async {
    try {
      await _supabase.from('events').delete().eq('id', eventId);
    } catch (e) {
      throw Exception('Error deleting event: $e');
    }
  }
}
