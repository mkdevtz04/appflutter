import 'package:flutter/material.dart';
import 'package:ticketbooking/models/bus_model.dart';
import 'package:ticketbooking/utils/app_styles.dart';
import 'package:gap/gap.dart';

class BusCard extends StatelessWidget {
  final Bus bus;
  final VoidCallback onTap;

  const BusCard({
    Key? key,
    required this.bus,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          children: [
            // Bus image
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(bus.image.isNotEmpty ? bus.image : 'assets/images/im2.jpg'),
                ),
              ),
            ),
            const Gap(12),
            // Bus company and name
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bus.busCompany,
                        style: Styles.headLineStyle4,
                      ),
                      const Gap(4),
                      Text(
                        bus.busName,
                        style: Styles.headLineStyle2,
                      ),
                    ],
                  ),
                ),
                Text(
                  'TSH ${bus.price.toStringAsFixed(0)}',
                  style: Styles.headLineStyle2.copyWith(color: Styles.primaryColor),
                ),
              ],
            ),
            const Gap(12),
            // Route info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bus.departure,
                      style: Styles.headLineStyle3,
                    ),
                    const Gap(4),
                    Text(
                      bus.departureTime,
                      style: Styles.headLineStyle4,
                    ),
                  ],
                ),
                Icon(Icons.arrow_forward, color: Styles.primaryColor),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      bus.arrival,
                      style: Styles.headLineStyle3,
                    ),
                    const Gap(4),
                    Text(
                      bus.arrivalTime,
                      style: Styles.headLineStyle4,
                    ),
                  ],
                ),
              ],
            ),
            const Gap(12),
            // Available seats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Available Seats: ${bus.availableSeats}',
                  style: Styles.headLineStyle4,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Styles.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Book Now',
                    style: Styles.textStyle.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
