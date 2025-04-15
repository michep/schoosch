import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:schoosch/widgets/appbar.dart';

class PDFPreview extends StatelessWidget {
  final LayoutCallback generate;
  final PdfPageFormat format;
  final String title;

  const PDFPreview({
    required this.generate,
    required this.format,
    this.title = '',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MAppBar(title),
      body: PdfPreview(
        initialPageFormat: format,
        canChangeOrientation: false,
        canChangePageFormat: false,
        build: (PdfPageFormat format) {
          return generate(format);
        },
      ),
    );
  }
}
