import 'package:cramx_v0_0_1/pages/card_view.dart';
import 'package:cramx_v0_0_1/pages/placeholder_page.dart';
import 'package:cramx_v0_0_1/pages/shimmer_view.dart';
import 'package:flutter/material.dart';
import 'package:cramx_v0_0_1/auth/auth_service.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<List<Map<String, dynamic>>> _subjectsFuture;
  final authService = AuthService();

  @override
  void initState() {
    super.initState();
    _subjectsFuture = authService.fetchSubjects();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF202123) : const Color(0xFFF7F7F8),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _subjectsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: ShimmerView());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: PlaceholderPage());
          }

          List<Map<String, dynamic>> subjects = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView.builder(
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                final subject = subjects[index];

                // Get and format 'created_at' timestamp
                String creationTime = "Unknown Date";
                if (subject.containsKey('created_at') && subject['created_at'] != null) {
                  try {
                    DateTime dateTime = DateTime.parse(subject['created_at']);
                    creationTime = DateFormat.yMMMd().format(dateTime); 
                    // Output: "Mar 29, 2025 3:21 PM"
                  } catch (e) {
                    creationTime = "Invalid Date";
                  }
                }

                return Card(
                  elevation: 4,
                  color: isDarkMode ? const Color(0xFF2C2F32) : const Color(0xFFE3E3E5),
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      subject['name'] ?? 'Not Defined',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          creationTime,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins', // Monospace font
                            color: isDarkMode ? const Color(0xFF5C6370) : Colors.black87, // Comment-like color,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Number Of Flashcards : ",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins', // Monospace font
                            color: isDarkMode ? const Color(0xFFABB2BF) : Colors.black, // Light gray (code text)
                          ),
                        ),
                        Text(
                          "Description : ",
                          style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Poppins', // Monospace font
                          color: isDarkMode ? const Color(0xFFABB2BF) : Colors.black, // Light gray (code text)
                        ),
                        ),
                      ],
                    ),
                    leading: SizedBox(
                      width: 55,
                      height: 55,
                      child: CircularProgressIndicator(
                        strokeWidth: 7,
                        value: 0.7,
                        valueColor: AlwaysStoppedAnimation<Color>(
                           Colors.blue,
                        ),
                        backgroundColor: isDarkMode ? Colors.grey : Colors.grey,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                    onTap: () {
                      //
                      final subjectid = subject['id'].toString();
                      Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => CardView(subjectId: subjectid,))
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
