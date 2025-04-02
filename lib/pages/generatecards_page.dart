// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:cramx_v0_0_1/auth/auth_service.dart';
import 'package:cramx_v0_0_1/utils/api_calls.dart';
import 'package:cramx_v0_0_1/utils/pdf_to_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

final AuthService _authService = AuthService();

class GeneratecardsPage extends StatefulWidget {
  const GeneratecardsPage({super.key});

  @override
  _GeneratecardsPageState createState() => _GeneratecardsPageState();
}

class _GeneratecardsPageState extends State<GeneratecardsPage> {
  final TextEditingController _deckNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedSpeed = "Faster";
  String? _selectedFileName;
  String? _extractedText;
  List<Map<String, String>> _flashcards = [];

  // Upload and extract text from PDF
  void _uploadPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      String filePath = result.files.single.path!;
      
      // Extract text from PDF
      _extractedText = await extractTextFromPdf(filePath);

      setState(() {
        _selectedFileName = result.files.single.name;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Extracted Text: $_extractedText")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No file selected")),
      );
    }
  }

  // Generate flashcards without connecting to Supabase
  void _generateCards() async {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Generating test flashcards for '${_deckNameController.text}'")),
  );

  try {
    // Get current user details
    final userDetails = _authService.getCurrentUserDetails();
    if (userDetails == null) {
      throw Exception("User not authenticated.");
    }

    final String userId = userDetails["uuid"]!;

    // Insert the new deck (subject) and get its ID
    String? subjectId = await _authService.insertSubject(
      userId,
      _deckNameController.text,
      _descriptionController.text,
    );

    if (subjectId == null) {
      throw Exception("Failed to insert subject.");
    }

    // Fetch generated flashcards from the API
    Map<String, dynamic>? response = await sendTextToNgrok(_extractedText!);

    if (response == null || !response.containsKey("flashcards")) {
      throw Exception("Invalid response from API.");
    }

    List<Map<String, String>> flashcardData = List<Map<String, String>>.from(
      (response["flashcards"] as List).map((flashcard) => {
        "question": flashcard["question"].toString(),
        "answer": flashcard["answer"].toString(),
      })
    );

    // Insert flashcards into the database
    await _authService.insertFlashcards(userId, subjectId, flashcardData);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Flashcards saved to Supabase!")),
    );

    setState(() {
      _flashcards = flashcardData;
    });

  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: ${e.toString()}")),
    );
  }
}



  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    Color backgroundColor = isDarkMode ? Color(0xFF202123) : Color(0xFFF7F7F8);
    Color textColor = isDarkMode ? const Color(0xFFECECF1) : const Color(0xFF2C2C2F);
    Color fieldColor = isDarkMode ? const Color(0xFF444654) : Colors.white;
    Color buttonColor = const Color(0xFF10A37F);
    Color cardColor = isDarkMode ? const Color(0xFF444654) : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            TextField(
              controller: _deckNameController,
              decoration: InputDecoration(
                labelText: "Deck Name",
                filled: true,
                fillColor: fieldColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              style: TextStyle(color: textColor),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: "Description",
                filled: true,
                fillColor: fieldColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              style: TextStyle(color: textColor),
            ),
            const SizedBox(height: 12),
            Center(
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: _uploadPDF,
                  icon: const Icon(Icons.upload_file),
                  label: Text(_selectedFileName ?? "Upload PDF"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    )
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedSpeed,
              items: ["Faster", "Slower"]
                  .map((speed) => DropdownMenuItem(value: speed, child: Text(speed)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSpeed = value!;
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: fieldColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 100),
            Center(
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _generateCards,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    )
                  ),
                  child: const Text("Generate Flashcards"),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _flashcards.isEmpty
                  ? const Center(
                      child: Text("No flashcards generated yet!", style: TextStyle(fontSize: 16)),
                    )
                  : ListView.builder(
                      itemCount: _flashcards.length,
                      itemBuilder: (context, index) {
                        return Align(
                          alignment: index % 2 == 0 ? Alignment.centerLeft : Alignment.centerRight,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  // ignore: deprecated_member_use
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Q: ${_flashcards[index]['question']!}",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
                                const SizedBox(height: 5),
                                Text("A: ${_flashcards[index]['answer']!}", style: TextStyle(color: textColor)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

}