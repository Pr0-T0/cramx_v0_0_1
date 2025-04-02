// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _ngrokController = TextEditingController();
  static const String _ngrokKey = "ngrok_url";
  String _savedUrl = "No URL saved"; // Default message

  @override
  void initState() {
    super.initState();
    _loadNgrokUrl();
  }

  // Load the saved ngrok URL
  Future<void> _loadNgrokUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUrl = prefs.getString(_ngrokKey);
    setState(() {
      _savedUrl = savedUrl ?? "No URL saved";
    });
  }

  // Save the ngrok URL
  Future<void> _saveNgrokUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = _ngrokController.text;
    await prefs.setString(_ngrokKey, url);
    setState(() {
      _savedUrl = url; // Update displayed URL
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Ngrok URL saved successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    Color backgroundColor = isDarkMode ? Color(0xFF202123) : Color(0xFFF7F7F8);
    Color appBarColor = isDarkMode ? Color(0xFF202123) : Color(0xFFF7F7F8);
    Color textColor = isDarkMode ? Color(0xFFECECF1) : Color(0xFF2C2C2F);
    Color fieldColor = isDarkMode ? Color(0xFF444654) : Colors.white;
    Color borderColor = isDarkMode ? Colors.grey : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(color: textColor)),
        backgroundColor: appBarColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Ngrok Tunnel URL",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _ngrokController,
              decoration: InputDecoration(
                hintText: "Enter ngrok URL",
                filled: true,
                fillColor: fieldColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: borderColor),
                ),
              ),
              style: TextStyle(color: textColor),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveNgrokUrl,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF10A37F),
              ),
              child: Text("Save", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            Text(
              "Saved Ngrok URL:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: fieldColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: borderColor),
              ),
              child: Text(
                _savedUrl,
                style: TextStyle(color: textColor, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
