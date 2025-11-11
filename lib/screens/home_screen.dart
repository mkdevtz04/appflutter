import 'package:flutter/material.dart';
import 'package:ticketbooking/utils/app_styles.dart';
import 'package:gap/gap.dart';
import 'package:ticketbooking/widgets/ticket_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                "Upcoming Flights",
                style: Styles.headLineStyle2,
              ),
              InkWell(
                onTap: () {
                  print("You are tapped");
                },
                child: Text(
                  "View all",
                  style: Styles.textStyle.copyWith(color: Styles.primaryColor),
                ),
              )
            ],
          ),
          const Gap(15),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: const [
                TicketView(),
                TicketView(), // Add another TicketView for demonstration
              ],
            ),
          ),
          const Gap(40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Hotels",
                style: Styles.headLineStyle2,
              ),
              InkWell(
                onTap: () {
                  print("You are tapped");
                },
                child: Text(
                  "View all",
                  style: Styles.textStyle.copyWith(color: Styles.primaryColor),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}