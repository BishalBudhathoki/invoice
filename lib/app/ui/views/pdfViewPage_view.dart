import 'package:flutter/material.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';

class PdfViewPage extends StatelessWidget {
  final String pdfPath;

  const PdfViewPage({super.key, required this.pdfPath});

  @override
  Widget build(BuildContext context) {
    print("PDF Path view page: $pdfPath");
    return Scaffold(
      body: PdfView(path: pdfPath),
    );
  }
}
