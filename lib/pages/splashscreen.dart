import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cramx_v0_0_1/auth/auth_gate.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Splashscreen extends StatelessWidget {
  
  const Splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return AnimatedSplashScreen(
      splash: Center(
        child: Lottie.asset('assets/splash.json'),
      ), 
      nextScreen: AuthGate(),
      splashIconSize: 300,
      duration: 1200,
      backgroundColor: isDarkMode ? Color(0xFF202123) : Color(0xFFF7F7F8),
      
    );
  }
}