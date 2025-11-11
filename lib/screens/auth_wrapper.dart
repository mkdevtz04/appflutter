import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ticketbooking/screens/login_screen.dart';
import 'package:ticketbooking/screens/register_screen.dart';
import 'package:ticketbooking/bottom_bar.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _showLogin = true;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        // While checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // If user is logged in, show home
        if (snapshot.hasData && snapshot.data?.session != null) {
          return const BottomBar();
        }

        // If user is not logged in, show auth screens
        return _showLogin
            ? LoginScreen(
                onSwitchToRegister: () {
                  setState(() {
                    _showLogin = false;
                  });
                },
              )
            : RegisterScreen(
                onSwitchToLogin: () {
                  setState(() {
                    _showLogin = true;
                  });
                },
              );
      },
    );
  }
}
