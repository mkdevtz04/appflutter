import 'package:flutter/material.dart';
import 'package:ticketbooking/services/auth_service.dart';
import 'package:ticketbooking/services/admin_service.dart';
import 'package:ticketbooking/utils/app_styles.dart';
import 'package:gap/gap.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ticketbooking/screens/add_bus_screen.dart';
import 'package:ticketbooking/screens/add_event_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService = AuthService();
  final _adminService = AdminService();
  bool _isLoading = false;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
  }

  Future<void> _checkAdminStatus() async {
    final isAdmin = await _adminService.isUserAdmin();
    if (mounted) {
      setState(() => _isAdmin = isAdmin);
    }
  }

  Future<void> _logout() async {
    setState(() => _isLoading = true);
    try {
      await _authService.signOut();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logged out successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        // Navigate to login or home after logout if needed
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    return Scaffold(
      backgroundColor: Styles.bgColor,
      appBar: AppBar(
        backgroundColor: Styles.primaryColor,
        title: Text(
          'Profile',
          style: Styles.headLineStyle1.copyWith(color: Colors.white),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // Open settings if needed
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    const Gap(12),
                    Text(
                      user?.email ?? 'User Email',
                      style: Styles.headLineStyle1,
                    ),
                    Text(
                      'Member since ${user?.createdAt.toString().split('T').first ?? 'N/A'}',
                      style: Styles.headLineStyle4.copyWith(color: Colors.grey),
                    ),
                    const Gap(30),
                  ],
                ),
              ),
              // Personal Info Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.email, color: Styles.primaryColor),
                          const Gap(8),
                          Text('Email', style: Styles.headLineStyle3),
                        ],
                      ),
                      const Gap(8),
                      Text(
                        user?.email ?? 'No email',
                        style: Styles.headLineStyle4.copyWith(fontSize: 16),
                      ),
                      const Gap(20),
                      Row(
                        children: [
                          Icon(Icons.person_outline, color: Styles.primaryColor),
                          const Gap(8),
                          Text('User ID', style: Styles.headLineStyle3),
                        ],
                      ),
                      const Gap(8),
                      Text(
                        user?.id ?? 'N/A',
                        style: Styles.headLineStyle4.copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(30),
              // Settings Section
              Text(
                'Settings',
                style: Styles.headLineStyle2,
              ),
              const Gap(20),
              // Admin Panel (Conditional)
              if (_isAdmin) ...[
                Card(
                  color: Styles.primaryColor.withOpacity(0.05),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Styles.primaryColor.withOpacity(0.3)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.admin_panel_settings, color: Styles.primaryColor),
                            const Gap(8),
                            Text(
                              'Admin Panel',
                              style: Styles.headLineStyle3.copyWith(color: Styles.primaryColor),
                            ),
                          ],
                        ),
                        const Gap(16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const AddBusScreen()),
                                  );
                                },
                                icon: const Icon(Icons.directions_bus, size: 18),
                                label: Text('Add Bus'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Styles.primaryColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                            const Gap(12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const AddEventScreen()),
                                  );
                                },
                                icon: const Icon(Icons.event, size: 18),
                                label: Text('Add Event'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Styles.primaryColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(20),
              ],
              // Settings List
              _buildSettingsTile(
                icon: Icons.edit,
                title: 'Edit Profile',
                onTap: () => debugPrint('Edit Profile Tapped'),
              ),
              _buildSettingsTile(
                icon: Icons.notifications,
                title: 'Notifications',
                onTap: () => debugPrint('Notifications Tapped'),
              ),
              _buildSettingsTile(
                icon: Icons.help_outline,
                title: 'Help & Support',
                onTap: () => debugPrint('Help & Support Tapped'),
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
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                strokeWidth: 2,
                              ),
                            ),
                            const Gap(8),
                            Text(
                              'Logging out...',
                              style: Styles.headLineStyle3.copyWith(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.logout, size: 20),
                            const Gap(8),
                            Text(
                              'Logout',
                              style: Styles.headLineStyle3.copyWith(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Styles.primaryColor.withOpacity(0.1),
          child: Icon(icon, color: Styles.primaryColor),
        ),
        title: Text(
          title,
          style: Styles.headLineStyle3,
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}