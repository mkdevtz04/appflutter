import 'package:flutter/material.dart';
import 'package:ticketbooking/utils/app_styles.dart';
import 'package:gap/gap.dart';
import 'package:ticketbooking/models/bus_model.dart';
import 'package:ticketbooking/models/event_model.dart';
import 'package:ticketbooking/services/booking_service.dart';
import 'package:ticketbooking/screens/bus_list_screen.dart';
import 'package:ticketbooking/screens/event_list_screen.dart';
import 'package:ticketbooking/widgets/bus_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BookingService _bookingService = BookingService();
  late Future<List<Bus>> _busesFuture;
  late Future<List<Event>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _busesFuture = _bookingService.getAllBuses();
    _eventsFuture = _bookingService.getAllEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.bgColor,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          const Gap(40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Good Morning",
                    style: Styles.headLineStyle3,
                  ),
                  const Gap(5),
                  Text(
                    "Book Tickets",
                    style: Styles.headLineStyle1,
                  ),
                ],
              ),
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/im1.jpg"),
                  ),
                ),
              ),
            ],
          ),
          const Gap(25),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFFF4F6FD),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Color(0xFFBFC205)),
                Text(
                  "Search",
                  style: Styles.headLineStyle4,
                ),
              ],
            ),
          ),
          const Gap(40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Available Buses",
                style: Styles.headLineStyle2,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BusListScreen()),
                  );
                },
                child: Text(
                  "View all",
                  style: Styles.textStyle.copyWith(color: Styles.primaryColor),
                ),
              )
            ],
          ),
          const Gap(15),
          FutureBuilder<List<Bus>>(
            future: _busesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 250,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError) {
                return SizedBox(
                  height: 100,
                  child: Center(child: Text('Error loading buses')),
                );
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return SizedBox(
                  height: 100,
                  child: Center(child: Text('No buses available')),
                );
              }

              final buses = snapshot.data!.take(2).toList();

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: buses
                      .map(
                        (bus) => Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: SizedBox(
                            width: 280,
                            child: BusCard(
                              bus: bus,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        BusDetailScreen(bus: bus),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              );
            },
          ),
          const Gap(40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Events Near You",
                style: Styles.headLineStyle2,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EventListScreen()),
                  );
                },
                child: Text(
                  "View all",
                  style: Styles.textStyle.copyWith(color: Styles.primaryColor),
                ),
              )
            ],
          ),
          const Gap(15),
          FutureBuilder<List<Event>>(
            future: _eventsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 250,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError) {
                return SizedBox(
                  height: 100,
                  child: Center(child: Text('Error loading events')),
                );
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return SizedBox(
                  height: 100,
                  child: Center(child: Text('No events available')),
                );
              }

              final events = snapshot.data!.take(2).toList();

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: events
                      .map(
                        (event) => Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: SizedBox(
                            width: 280,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EventDetailScreen(event: event),
                                  ),
                                );
                              },
                              child: Container(
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 150,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                        ),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                            event.image.isNotEmpty
                                                ? event.image
                                                : 'assets/images/im3.jpg',
                                          ),
                                        ),
                                      ),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          margin: const EdgeInsets.all(8),
                                          padding: const EdgeInsets
                                              .symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Styles.primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            event.eventType,
                                            style: Styles.headLineStyle4
                                                .copyWith(
                                              color: Colors.white,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            event.eventName,
                                            style:
                                                Styles.headLineStyle3,
                                            maxLines: 1,
                                            overflow:
                                                TextOverflow.ellipsis,
                                          ),
                                          const Gap(6),
                                          Text(
                                            event.venue,
                                            style:
                                                Styles.headLineStyle4,
                                            maxLines: 1,
                                            overflow:
                                                TextOverflow.ellipsis,
                                          ),
                                          const Gap(8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                            children: [
                                              Text(
                                                'TSH ${event.price.toStringAsFixed(0)}',
                                                style: Styles
                                                    .headLineStyle3
                                                    .copyWith(
                                                  color: Styles
                                                      .primaryColor,
                                                ),
                                              ),
                                              Text(
                                                '${event.availableTickets} left',
                                                style: Styles
                                                    .headLineStyle4,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              );
            },
          ),
          const Gap(40),
        ],
      ),
    );
  }
}