
import 'package:cramx_v0_0_1/auth/auth_service.dart';
import 'package:cramx_v0_0_1/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

class LoginPage extends StatelessWidget {
   LoginPage({super.key});

  Duration get loginTime => const Duration(milliseconds: 2250);

  final authService = AuthService();

  Future<String?> _authUser(LoginData data) async {
    try {
      await authService.signInWithEmailPassword(data.name, data.password);
      return null; // success
    } catch (e) {
      return "Error: $e";
    }
  }

  Future<String?> _signupUser(SignupData data) async {
    try {
        await authService.signUpwithEmailPassword(data.name!, data.password!);
        return null;
    } catch (e) {
      return "Error: $e";
    }
  }

  Future<String?> _recoverPassword(String name) async {
    return "Password recovery is not implemented yet.";
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: FlutterLogin(
        logo: AssetImage(isDarkMode 
            ? 'assets/logo_dark.jpg' 
            : 'assets/logo_light.jpg',
        ),
        theme: LoginTheme(
          primaryColor: isDarkMode ? Color(0xFF202123) : Color(0xFFF7F7F8),
          accentColor: isDarkMode ? Color(0xFF2C2F32) : Color(0xFFE3E3E5),
          switchAuthTextColor: isDarkMode ? Colors.white70 : Colors.black87,
          textFieldStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          titleStyle: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
          buttonTheme: LoginButtonTheme(
            backgroundColor: isDarkMode ? Color(0xFF10A37F) : Color(0xFF008060),
            highlightColor: isDarkMode ? Color(0xFF08856D) : Color(0xFF006D52),
          ),
        ),

        onLogin: _authUser,
        onSignup: _signupUser,
        onRecoverPassword: _recoverPassword,
        onSubmitAnimationCompleted: () {
            Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
          }
      ),
    );
  }
}
