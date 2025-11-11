import 'package:flutter/material.dart';
import 'package:ticketbooking/models/bus_model.dart';
import 'package:ticketbooking/services/booking_service.dart';
import 'package:ticketbooking/utils/app_styles.dart';
import 'package:ticketbooking/widgets/bus_card.dart';
import 'package:gap/gap.dart';

class BusListScreen extends StatefulWidget {
  const BusListScreen({Key? key}) : super(key: key);

  @override
  State<BusListScreen> createState() => _BusListScreenState();
}

class _BusListScreenState extends State<BusListScreen> {
  final BookingService _bookingService = BookingService();
  late Future<List<Bus>> _busesFuture;

  @override
  void initState() {
    super.initState();
    _busesFuture = _bookingService.getAllBuses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.bgColor,
      appBar: AppBar(
        backgroundColor: Styles.bgColor,
        elevation: 0,
        title: Text(
          'Available Buses',
          style: Styles.headLineStyle2,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF3b3b3b)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<Bus>>(
        future: _busesFuture,
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
              child: Text(
                'No buses available',
                style: Styles.headLineStyle2,
              ),
            );
          }

          final buses = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            children: [
              ...buses.map(
                (bus) => BusCard(
                  bus: bus,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BusDetailScreen(bus: bus),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class BusDetailScreen extends StatefulWidget {
  final Bus bus;

  const BusDetailScreen({Key? key, required this.bus}) : super(key: key);

  @override
  State<BusDetailScreen> createState() => _BusDetailScreenState();
}

class _BusDetailScreenState extends State<BusDetailScreen> {
  final BookingService _bookingService = BookingService();
  int _selectedSeats = 1;
  bool _isBooking = false;

  void _bookBus() async {
    setState(() => _isBooking = true);

    try {
      await _bookingService.createBusBooking(
        busId: widget.bus.id,
        quantity: _selectedSeats,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking confirmed!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking failed: $e')),
        );
      }
    } finally {
      setState(() => _isBooking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = widget.bus.price * _selectedSeats;

    return Scaffold(
      backgroundColor: Styles.bgColor,
      appBar: AppBar(
        backgroundColor: Styles.bgColor,
        elevation: 0,
        title: Text('Bus Details', style: Styles.headLineStyle2),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF3b3b3b)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bus image
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(widget.bus.image.isNotEmpty ? widget.bus.image : 'assets/images/im2.jpg'),
                  ),
                ),
              ),
              const Gap(20),
              // Bus name and company
              Text(widget.bus.busName, style: Styles.headLineStyle1),
              const Gap(8),
              Text(widget.bus.busCompany, style: Styles.headLineStyle4),
              const Gap(20),
              // Route details
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Departure', style: Styles.headLineStyle4),
                            const Gap(8),
                            Text(widget.bus.departure, style: Styles.headLineStyle2),
                            const Gap(4),
                            Text(widget.bus.departureTime, style: Styles.headLineStyle4),
                          ],
                        ),
                        const Icon(Icons.arrow_forward),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Arrival', style: Styles.headLineStyle4),
                            const Gap(8),
                            Text(widget.bus.arrival, style: Styles.headLineStyle2),
                            const Gap(4),
                            Text(widget.bus.arrivalTime, style: Styles.headLineStyle4),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Gap(20),
              // Price and available seats
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Price per seat', style: Styles.headLineStyle4),
                        const Gap(8),
                        Text('TSH ${widget.bus.price.toStringAsFixed(0)}', style: Styles.headLineStyle2),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Available seats', style: Styles.headLineStyle4),
                        const Gap(8),
                        Text('${widget.bus.availableSeats}', style: Styles.headLineStyle2),
                      ],
                    ),
                  ],
                ),
              ),
              const Gap(20),
              // Seat selection
              Text('Number of seats', style: Styles.headLineStyle3),
              const Gap(12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: _selectedSeats > 1
                          ? () => setState(() => _selectedSeats--)
                          : null,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _selectedSeats > 1 ? Styles.primaryColor : Colors.grey,
                        ),
                        child: const Icon(Icons.remove, color: Colors.white),
                      ),
                    ),
                    Text('$_selectedSeats', style: Styles.headLineStyle2),
                    GestureDetector(
                      onTap: _selectedSeats < widget.bus.availableSeats
                          ? () => setState(() => _selectedSeats++)
                          : null,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _selectedSeats < widget.bus.availableSeats ? Styles.primaryColor : Colors.grey,
                        ),
                        child: const Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(30),
              // Total price and book button
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Price', style: Styles.headLineStyle3),
                        Text('TSH ${totalPrice.toStringAsFixed(0)}', style: Styles.headLineStyle1.copyWith(color: Styles.primaryColor)),
                      ],
                    ),
                    const Gap(16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isBooking ? null : _bookBus,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Styles.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _isBooking
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white)),
                              )
                            : Text(
                                'Confirm Booking',
                                style: Styles.headLineStyle3.copyWith(color: Colors.white),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
