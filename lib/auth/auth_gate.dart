// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:cramx_v0_0_1/pages/home_page.dart';
import 'package:cramx_v0_0_1/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  _AuthGateState createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    // Listen to auth state changes and handle navigation
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      final currentRoute = ModalRoute.of(context)?.settings.name;

      if (session != null && currentRoute != "/profile") {
        // Navigate to ProfilePage if user is authenticated and not already there
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else if (session == null && currentRoute != "/login") {
        // Navigate to LoginPage if user is not authenticated and not already there
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  LoginPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()), // Initial loading screen
    );
  }
}
