import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ticketbooking/utils/app_styles.dart';

class TicketView extends StatelessWidget {
  const TicketView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(21),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          // Blue part of the ticket
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF526799),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(21),
                topRight: Radius.circular(21),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "NYC",
                      style: Styles.headLineStyle3.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const Icon(Icons.sync_alt_rounded, color: Colors.white),
                    Text(
                      "LDN",
                      style: Styles.headLineStyle3.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const Gap(8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "New York",
                      style: Styles.headLineStyle4.copyWith(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "8H 30M",
                      style: Styles.headLineStyle4.copyWith(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "London",
                      style: Styles.headLineStyle4.copyWith(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Dashed line part
          Container(
            color: Styles.orangeColor,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Container(
                  height: 20,
                  width: 10,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SizedBox(
                      height: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          20,
                          (index) => Container(
                            width: 4,
                            height: 1,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 20,
                  width: 10,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Bottom part of the ticket
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Styles.orangeColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(21),
                bottomRight: Radius.circular(21),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "1 MAY",
                      style: Styles.headLineStyle3.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const Gap(3),
                    Text(
                      "Date",
                      style: Styles.headLineStyle4.copyWith(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "08:00 AM",
                      style: Styles.headLineStyle3.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const Gap(3),
                    Text(
                      "Departure",
                      style: Styles.headLineStyle4.copyWith(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "23",
                      style: Styles.headLineStyle3.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const Gap(3),
                    Text(
                      "Number",
                      style: Styles.headLineStyle4.copyWith(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}