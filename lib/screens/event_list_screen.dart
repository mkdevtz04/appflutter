import 'package:flutter/material.dart';
import 'package:ticketbooking/models/event_model.dart';
import 'package:ticketbooking/services/booking_service.dart';
import 'package:ticketbooking/utils/app_styles.dart';
import 'package:gap/gap.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({Key? key}) : super(key: key);

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  final BookingService _bookingService = BookingService();
  late Future<List<Event>> _eventsFuture;
  String _selectedType = 'All';

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  void _loadEvents() {
    if (_selectedType == 'All') {
      _eventsFuture = _bookingService.getAllEvents();
    } else {
      _eventsFuture = _bookingService.getEventsByType(_selectedType);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.bgColor,
      appBar: AppBar(
        backgroundColor: Styles.bgColor,
        elevation: 0,
        title: Text(
          'Events & Entertainment',
          style: Styles.headLineStyle2,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF3b3b3b)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Event type filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: ['All', 'Cinema', 'Club', 'Concert'].map((type) {
                final isSelected = _selectedType == type;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedType = type;
                        _loadEvents();
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? Styles.primaryColor : Colors.white,
                        border: Border.all(
                          color: isSelected ? Styles.primaryColor : Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        type,
                        style: Styles.headLineStyle4.copyWith(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // Events list
          Expanded(
            child: FutureBuilder<List<Event>>(
              future: _eventsFuture,
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
                      'No events available',
                      style: Styles.headLineStyle2,
                    ),
                  );
                }

                final events = snapshot.data!;

                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  children: [
                    ...events.map(
                      (event) => EventCard(
                        event: event,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventDetailScreen(event: event),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;

  const EventCard({
    Key? key,
    required this.event,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event image
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: event.image.isNotEmpty
                      ? NetworkImage(event.image)
                      : const AssetImage('assets/images/im3.jpg'),
                ),
              ),
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Styles.primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    event.eventType,
                    style: Styles.headLineStyle4.copyWith(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event name
                  Text(
                    event.eventName,
                    style: Styles.headLineStyle3,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Gap(6),
                  // Venue
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                      const Gap(4),
                      Expanded(
                        child: Text(
                          event.venue,
                          style: Styles.headLineStyle4,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Gap(6),
                  // Date and time
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey),
                      const Gap(4),
                      Text(
                        event.date,
                        style: Styles.headLineStyle4,
                      ),
                      const Gap(12),
                      const Icon(Icons.access_time_outlined, size: 14, color: Colors.grey),
                      const Gap(4),
                      Text(
                        event.time,
                        style: Styles.headLineStyle4,
                      ),
                    ],
                  ),
                  const Gap(12),
                  // Price and available tickets
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Price', style: Styles.headLineStyle4),
                          Text(
                            'TSH ${event.price.toStringAsFixed(0)}',
                            style: Styles.headLineStyle3.copyWith(color: Styles.primaryColor),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Tickets left', style: Styles.headLineStyle4),
                          Text(
                            '${event.availableTickets}',
                            style: Styles.headLineStyle3,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EventDetailScreen extends StatefulWidget {
  final Event event;

  const EventDetailScreen({Key? key, required this.event}) : super(key: key);

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  final BookingService _bookingService = BookingService();
  int _selectedTickets = 1;
  bool _isBooking = false;

  void _bookEvent() async {
    setState(() => _isBooking = true);

    try {
      await _bookingService.createEventBooking(
        eventId: widget.event.id,
        quantity: _selectedTickets,
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
    final totalPrice = widget.event.price * _selectedTickets;

    return Scaffold(
      backgroundColor: Styles.bgColor,
      appBar: AppBar(
        backgroundColor: Styles.bgColor,
        elevation: 0,
        title: Text('Event Details', style: Styles.headLineStyle2),
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
              // Event image
              Container(
                height: 280,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: widget.event.image.isNotEmpty
                        ? NetworkImage(widget.event.image)
                        : const AssetImage('assets/images/im3.jpg'),
                  ),
                ),
              ),
              const Gap(20),
              // Event name and type
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(widget.event.eventName, style: Styles.headLineStyle1),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Styles.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.event.eventType,
                      style: Styles.headLineStyle4.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const Gap(20),
              // Venue and location details
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Venue', style: Styles.headLineStyle3),
                    const Gap(8),
                    Text(widget.event.venue, style: Styles.headLineStyle2),
                    const Gap(12),
                    Text('Location', style: Styles.headLineStyle3),
                    const Gap(8),
                    Text(widget.event.location, style: Styles.headLineStyle2),
                  ],
                ),
              ),
              const Gap(20),
              // Date and time
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
                        Text('Date', style: Styles.headLineStyle4),
                        const Gap(8),
                        Text(widget.event.date, style: Styles.headLineStyle2),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Time', style: Styles.headLineStyle4),
                        const Gap(8),
                        Text(widget.event.time, style: Styles.headLineStyle2),
                      ],
                    ),
                  ],
                ),
              ),
              const Gap(20),
              // Description
              Text('About this event', style: Styles.headLineStyle3),
              const Gap(12),
              Text(
                widget.event.description,
                style: Styles.headLineStyle4,
              ),
              const Gap(20),
              // Price and available tickets
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
                        Text('Price per ticket', style: Styles.headLineStyle4),
                        const Gap(8),
                        Text('TSH ${widget.event.price.toStringAsFixed(0)}', style: Styles.headLineStyle2),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Available tickets', style: Styles.headLineStyle4),
                        const Gap(8),
                        Text('${widget.event.availableTickets}', style: Styles.headLineStyle2),
                      ],
                    ),
                  ],
                ),
              ),
              const Gap(20),
              // Ticket selection
              Text('Number of tickets', style: Styles.headLineStyle3),
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
                      onTap: _selectedTickets > 1
                          ? () => setState(() => _selectedTickets--)
                          : null,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _selectedTickets > 1 ? Styles.primaryColor : Colors.grey,
                        ),
                        child: const Icon(Icons.remove, color: Colors.white),
                      ),
                    ),
                    Text('$_selectedTickets', style: Styles.headLineStyle2),
                    GestureDetector(
                      onTap: _selectedTickets < widget.event.availableTickets
                          ? () => setState(() => _selectedTickets++)
                          : null,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _selectedTickets < widget.event.availableTickets ? Styles.primaryColor : Colors.grey,
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
                        onPressed: _isBooking ? null : _bookEvent,
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
