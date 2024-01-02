import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/studyperiod_model.dart';
import 'package:schoosch/pdf/pdf_theme.dart';

class PDFStudentPeriodMarks {
  final StudyPeriodModel period;
  final StudentModel student;

  PDFStudentPeriodMarks({
    required this.period,
    required this.student,
  });

  Future<Uint8List> generate(PdfPageFormat format) async {
    var doc = pw.Document(
      theme: await getTheme(),
    );

    return doc.save();
  }

  // pw.Widget _header() {
  //   return pw.Padding(
  //     padding: const pw.EdgeInsets.only(bottom: 8),
  //     child: pw.Column(
  //       crossAxisAlignment: pw.CrossAxisAlignment.start,
  //       children: [
  //         pw.Text(
  //           aclass.name,
  //           style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
  //         ),
  //         pw.Row(
  //           children: [
  //             pw.Text(
  //               curriculum.name,
  //               style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
  //             ),
  //             pw.SizedBox(width: 10),
  //             pw.Text(
  //               period.name,
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // pw.Widget _studentNameCell({required String text}) {
  //   return pw.Padding(
  //     padding: const pw.EdgeInsets.all(2),
  //     child: pw.SizedBox(
  //       //constraints: const pw.BoxConstraints(minWidth: 30, maxWidth: 50),
  //       width: 10,
  //       child: pw.Text(text),
  //     ),
  //   );
  // }

  // pw.Widget _markCell({
  //   required String text,
  //   double? fontSize,
  //   pw.FontWeight? fontWeight,
  // }) {
  //   return pw.Padding(
  //     padding: const pw.EdgeInsets.all(2),
  //     child: pw.Text(text, style: pw.TextStyle(fontSize: fontSize, fontWeight: fontWeight)),
  //   );
  // }

  // pw.Widget _emptyCell() {
  //   return pw.Text('.', style: const pw.TextStyle(color: PdfColors.white));
  // }
}
