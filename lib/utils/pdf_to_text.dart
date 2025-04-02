import 'dart:io';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

Future<String> extractTextFromPdf(String filePath) async {
  try {
    // Read file bytes
    Uint8List bytes = await File(filePath).readAsBytes();

    // Load the PDF document
    final PdfDocument document = PdfDocument(inputBytes: bytes);

    // Extract text
    String text = PdfTextExtractor(document).extractText();

    // Dispose the document to free memory
    document.dispose();

    return text;
  } catch (e) {
    return 'Error extracting text: $e';
  }
}
