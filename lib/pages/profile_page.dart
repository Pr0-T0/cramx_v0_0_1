import 'package:cramx_v0_0_1/auth/auth_service.dart';
import 'package:cramx_v0_0_1/pages/login_page.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final authService = AuthService();

  void logout() async {
    await authService.signOut();
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final currentUserDetails = authService.getCurrentUserDetails();

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF202123) : const Color(0xFFF7F7F8),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Avatar
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueGrey,
              child: Icon(
                Icons.person,
                size: 50,
                color: isDarkMode ? Colors.white70 : Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            // User Information Card
            Card(
              elevation: 4,
              color: isDarkMode ? const Color(0xFF2C2F32) : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ProfileInfoRow(
                      icon: Icons.account_circle,
                      label: "User ID",
                      value: currentUserDetails?['uuid'] ?? "Unknown",
                    ),
                    const Divider(),
                    ProfileInfoRow(
                      icon: Icons.email,
                      label: "Email",
                      value: currentUserDetails?['email'] ?? "Unknown",
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: logout,
                icon: const Icon(Icons.logout),
                label: const Text("Log Out"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: isDarkMode ? const Color(0xFF10A37F) : const Color(0xFF008060),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget for profile info rows
class ProfileInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ProfileInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 28, color: isDarkMode ? Colors.white70 : Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "$label: $value",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
