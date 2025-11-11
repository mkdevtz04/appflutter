import 'package:flutter/material.dart';
import 'package:ticketbooking/screens/home_screen.dart';
import 'package:ticketbooking/screens/search_screen.dart';
import 'package:ticketbooking/screens/ticket_screen.dart';
import 'package:ticketbooking/screens/profile_screen.dart';
import 'package:ticketbooking/services/auth_service.dart';
import 'package:ticketbooking/utils/app_styles.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;
  final _authService = AuthService();
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
  }

  void _checkAdminStatus() async {
    final isAdmin = await _authService.isUserAdmin();
    setState(() => _isAdmin = isAdmin);
  }

  late final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const SearchScreen(),
    const TicketScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        elevation: 10,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        selectedItemColor: Styles.primaryColor,
        unselectedItemColor: const Color(0xFF526480),
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          const BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          const BottomNavigationBarItem(icon: Icon(Icons.airplane_ticket), label: "Ticket"),
          BottomNavigationBarItem(
            icon: _isAdmin 
              ? Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.admin_panel_settings, color: Colors.white, size: 18),
                )
              : const Icon(Icons.person),
            label: _isAdmin ? "Admin" : "Profile",
          ),
        ],
      ),
    );
  }
}
