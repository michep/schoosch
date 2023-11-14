import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/studyperiod_model.dart';
import 'package:schoosch/pdf/pdf_theme.dart';

class PDFClassCurriculumPeriodMarks {
  final StudyPeriodModel period;
  final ClassModel? aclass;
  final CurriculumModel curriculum;

  PDFClassCurriculumPeriodMarks({
    required this.period,
    required this.curriculum,
    this.aclass,
  });

  Future<Uint8List> generate(PdfPageFormat format) async {
    var students = aclass != null ? await curriculum.classStudents(aclass!) : await curriculum.students();
    var marks = await curriculum.getLessonMarksByStudents(students, period);
    var periodMarks = await curriculum.getPeriodMarksByStudents(students, period);

    var doc = pw.Document(
      theme: await getTheme(),
    );
    doc.addPage(
      pw.MultiPage(
        pageFormat: format,
        header: (context) => pw.Row(
          children: [
            if (aclass != null)
              pw.Text(
                aclass!.name,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            pw.Text(
              curriculum.name,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              period.name,
            ),
          ],
        ),
        build: (context) {
          List<pw.TableRow> rows = [];

          for (var student in students) {
            rows.add(
              pw.TableRow(
                children: [
                  _cell(text: student.fullName),
                  if (marks[student] != null) ...marks[student]!.map((e) => _cell(text: e.mark.toString(), fontWeight: pw.FontWeight.bold, fontSize: 10)),
                ],
              ),
            );
          }

          return [
            pw.Table(
              defaultColumnWidth: const pw.FractionColumnWidth(0.10),
              columnWidths: {
                0: const pw.FractionColumnWidth(0.03),
                1: const pw.FractionColumnWidth(0.10),
              },
              border: pw.TableBorder.all(color: PdfColors.black),
              children: rows,
            ),
          ];
        },
      ),
    );

    return doc.save();
  }

  pw.Widget _cell({
    required String text,
    double? fontSize,
    pw.FontWeight? fontWeight,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(2),
      child: pw.Text(text, style: pw.TextStyle(fontSize: fontSize, fontWeight: fontWeight)),
    );
  }

  // pw.Widget _emptyCell() {
  //   return pw.Text('.', style: const pw.TextStyle(color: PdfColors.white));
  // }
}
