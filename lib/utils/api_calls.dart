// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

const String defaultNgrokUrl = "https://e5bd-35-197-158-4.ngrok-free.app"; // Replace with actual Ngrok URL

Future<Map<String, dynamic>?> sendTextToNgrok(String extractedText) async {
  String ngrokUrl = await _getNgrokUrl();
  if (ngrokUrl.isEmpty) {
    print("Error: Ngrok URL is not set. Please configure it in the settings.");
    return null;
  }

  String endpoint = "$ngrokUrl/generate_flashcards";
  
  Map<String, dynamic> data = {
    "text": extractedText,
    "num_flashcards": 20
  };

  try {
    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print("Flashcards Generated Successfully!");
      return jsonDecode(response.body); // Print response from server
    } else {
      print("Error ${response.statusCode}: ${response.body}");
      return null;
    }
  } catch (e) {
    print("Error sending text to ngrok: $e");
    return null;
  }
}

// Retrieve ngrok URL from SharedPreferences
Future<String> _getNgrokUrl() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("ngrok_url") ?? defaultNgrokUrl;
}