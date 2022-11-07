import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PDFSchedule {
  final List<Map<String, dynamic>> data;

  PDFSchedule({
    required this.data,
  });

  Future<Uint8List> generate(PdfPageFormat format) async {
    var doc = pw.Document();
    doc.addPage(
      pw.MultiPage(
        build: (context) {
          return [
            pw.Partitions(
              children: [
                pw.Partition(
                  child: pw.Column(
                    children: [
                      pw.Text('partition1'),
                    ],
                  ),
                ),
                pw.Partition(
                  child: pw.Column(
                    children: [
                      pw.Text('partition2'),
                    ],
                  ),
                ),
              ],
            ),
          ];
        },
      ),
    );
    return doc.save();
  }
}
