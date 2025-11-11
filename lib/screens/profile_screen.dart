import 'package:flutter/material.dart';
import 'package:ticketbooking/services/auth_service.dart';
import 'package:ticketbooking/utils/app_styles.dart';
import 'package:gap/gap.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService = AuthService();
  bool _isLoading = false;

  Future<void> _logout() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.signOut();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logged out successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      backgroundColor: Styles.bgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(40),
              Text(
                "Profile",
                style: Styles.headLineStyle1,
              ),
              const Gap(30),
              // User Info Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Email",
                      style: Styles.headLineStyle4,
                    ),
                    const Gap(8),
                    Text(
                      user?.email ?? 'No email',
                      style: Styles.headLineStyle3.copyWith(fontSize: 16),
                    ),
                    const Gap(20),
                    Text(
                      "User ID",
                      style: Styles.headLineStyle4,
                    ),
                    const Gap(8),
                    Text(
                      user?.id ?? 'No user ID',
                      style: Styles.headLineStyle3.copyWith(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const Gap(20),
                    Text(
                      "Joined",
                      style: Styles.headLineStyle4,
                    ),
                    const Gap(8),
                    Text(
                      user?.createdAt.toString().split('T').first ?? 'N/A',
                      style: Styles.headLineStyle3.copyWith(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const Gap(40),
              // Settings Section
              Text(
                "Settings",
                style: Styles.headLineStyle2,
              ),
              const Gap(20),
              // Edit Profile Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    print("Edit profile");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Styles.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Edit Profile",
                    style: Styles.headLineStyle3.copyWith(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const Gap(15),
              // Notifications Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    print("Notifications");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Styles.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Notifications",
                    style: Styles.headLineStyle3.copyWith(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const Gap(15),
              // Help & Support Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    print("Help & Support");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Styles.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Help & Support",
                    style: Styles.headLineStyle3.copyWith(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const Gap(40),
              // Logout Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _logout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    disabledBackgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          "Logout",
                          style: Styles.headLineStyle3.copyWith(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                ),
              ),
              const Gap(40),
            ],
          ),
        ),
      ),
    );
  }
}