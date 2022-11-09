import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class Preview extends StatelessWidget {
  final LayoutCallback generate;
  final PdfPageFormat format;

  const Preview({
    required this.generate,
    required this.format,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
