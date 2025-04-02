import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key});


  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF202123) : const Color(0xFFF7F7F8),
      body: Stack(
        children: [
          Center(
            child: Text(
              'No Decks available.',
              style: GoogleFonts.patrickHand(fontSize: 22, color: isDarkMode ? Colors.white : Colors.black),
            ),
          ),
          Positioned(
            right: 20,
            top: 150,
            child: Column(
              children: [
                Text(
                  'Swipe to add new →',
                  style: GoogleFonts.patrickHand(fontSize: 18, color: isDarkMode ? Colors.white : Colors.black),
                ),
                //Icon(Icons.arrow_right_alt, color: Colors.white, size: 30),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 190,
            child: Column(
              children: [
                Text(
                  'or click here \n      ↓',
                  style: GoogleFonts.patrickHand(fontSize: 18, color: isDarkMode ? Colors.white : Colors.black),
                ),
                //Icon(Icons.arrow_downward, color: Colors.white, size: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
