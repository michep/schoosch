import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/studyperiod_model.dart';
import 'package:schoosch/pdf/pdf_theme.dart';

class PDFClassCurriculumPeriodMarks {
  final StudyPeriodModel period;
  final ClassModel aclass;
  final CurriculumModel curriculum;

  PDFClassCurriculumPeriodMarks({
    required this.period,
    required this.curriculum,
    required this.aclass,
  });

  Future<Uint8List> generate(PdfPageFormat format) async {
    var students = await curriculum.classStudents(aclass);
    var marks = await curriculum.getLessonMarksByStudents(students, period);
    // var periodMarks = await curriculum.getPeriodMarksByStudents(students, period);

    var doc = pw.Document(
      theme: await getTheme(),
    );
    doc.addPage(
      pw.MultiPage(
        pageFormat: format,
        header: (context) => _header(),
        build: (context) {
          List<pw.TableRow> rows = [];

          for (var student in students) {
            rows.add(
              pw.TableRow(
                children: [
                  _studentNameCell(text: student.fullName),
                  if (marks[student] != null)
                    ...marks[student]!.map((e) => _markCell(
                          text: e.mark.toString(),
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 10,
                        )),
                ],
              ),
            );
          }

          return [
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.black),
              children: rows,
            ),
          ];
        },
      ),
    );

    return doc.save();
  }

  pw.Widget _header() {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            aclass.name,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.Row(
            children: [
              pw.Text(
                curriculum.name,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(width: 10),
              pw.Text(
                period.name,
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _studentNameCell({required String text}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(2),
      child: pw.SizedBox(
        //constraints: const pw.BoxConstraints(minWidth: 30, maxWidth: 50),
        width: 10,
        child: pw.Text(text),
      ),
    );
  }

  pw.Widget _markCell({
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
