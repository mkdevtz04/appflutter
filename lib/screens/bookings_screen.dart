import 'package:flutter/material.dart';
import 'package:ticketbooking/models/booking_model.dart';
import 'package:ticketbooking/services/booking_service.dart';
import 'package:ticketbooking/utils/app_styles.dart';
import 'package:gap/gap.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({Key? key}) : super(key: key);

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  final BookingService _bookingService = BookingService();
  late Future<List<Booking>> _bookingsFuture;

  @override
  void initState() {
    super.initState();
    _bookingsFuture = _bookingService.getUserBookings();
  }

  void _cancelBooking(String bookingId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _bookingService.cancelBooking(bookingId);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Booking cancelled successfully')),
                  );
                  setState(() {
                    _bookingsFuture = _bookingService.getUserBookings();
                  });
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
            child: const Text('Yes', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.bgColor,
      appBar: AppBar(
        backgroundColor: Styles.bgColor,
        elevation: 0,
        title: Text(
          'My Bookings',
          style: Styles.headLineStyle2,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF3b3b3b)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<Booking>>(
        future: _bookingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: Styles.headLineStyle4,
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 64,
                    color: Colors.grey.shade300,
                  ),
                  const Gap(16),
                  Text(
                    'No bookings yet',
                    style: Styles.headLineStyle2,
                  ),
                  const Gap(8),
                  Text(
                    'Start booking buses and events to see them here',
                    style: Styles.headLineStyle4,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final bookings = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            children: [
              ...bookings.map(
                (booking) => BookingCard(
                  booking: booking,
                  onCancel: () => _cancelBooking(booking.id),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback onCancel;

  const BookingCard({
    Key? key,
    required this.booking,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with booking ID and status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Booking ID', style: Styles.headLineStyle4),
                    const Gap(4),
                    Text(booking.id.substring(0, 8), style: Styles.headLineStyle3),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: booking.status == 'confirmed'
                      ? Colors.green.shade100
                      : booking.status == 'pending'
                          ? Colors.orange.shade100
                          : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  booking.status.toUpperCase(),
                  style: Styles.headLineStyle4.copyWith(
                    color: booking.status == 'confirmed'
                        ? Colors.green.shade700
                        : booking.status == 'pending'
                            ? Colors.orange.shade700
                            : Colors.red.shade700,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const Gap(16),
          // Booking details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Type', style: Styles.headLineStyle4),
                  const Gap(4),
                  Text(
                    booking.bookingType.toUpperCase(),
                    style: Styles.headLineStyle3,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Quantity', style: Styles.headLineStyle4),
                  const Gap(4),
                  Text(
                    '${booking.quantity}x',
                    style: Styles.headLineStyle3,
                  ),
                ],
              ),
            ],
          ),
          const Gap(12),
          Divider(color: Colors.grey.shade200),
          const Gap(12),
          // Total price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Price', style: Styles.headLineStyle3),
              Text(
                'TSH ${booking.totalPrice.toStringAsFixed(0)}',
                style: Styles.headLineStyle2.copyWith(color: Styles.primaryColor),
              ),
            ],
          ),
          const Gap(16),
          // Cancel button (only for pending bookings)
          if (booking.status == 'pending')
            SizedBox(
              width: double.infinity,
              height: 40,
              child: OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Cancel Booking',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
