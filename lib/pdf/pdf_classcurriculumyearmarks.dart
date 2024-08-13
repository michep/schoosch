import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/studyperiod_model.dart';
import 'package:schoosch/pdf/pdf_theme.dart';
import 'package:schoosch/pdf/pdf_widgets.dart';

class PDFClassCurriculumYearMarks {
  final List<StudyPeriodModel> periods;
  final ClassModel aclass;
  final CurriculumModel curriculum;

  PDFClassCurriculumYearMarks({
    required this.periods,
    required this.curriculum,
    required this.aclass,
  });

  Future<Uint8List> generate(PdfPageFormat format) async {
    var students = await curriculum.classStudents(aclass);
    // var marks = await curriculum.getLessonMarksByStudents(students, period);
    var periodMarks = await curriculum.getAllPeriodsMarksByStudents(students, periods);

    var doc = pw.Document(
      theme: await getTheme(),
    );
    doc.addPage(
      pw.MultiPage(
        pageFormat: format,
        header: (context) => _header(),
        build: (context) {
          List<pw.TableRow> rows = [];

          rows.add(
            pw.TableRow(
              children: [
                PdfWidgets.nameCell(text: ''),
                ...periods.map(
                  (e) => PdfWidgets.nameCell(text: e.name),
                ),
              ],
            ),
          );

          for (var student in students) {
            rows.add(
              pw.TableRow(
                children: [
                  PdfWidgets.nameCell(text: student.fullName),
                  if (periodMarks[student] != null)
                    ...periodMarks[student]!.map((e) => PdfWidgets.periodMarkCell(
                          mark: e,
                          fontWeight: pw.FontWeight.bold,
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
    return PdfWidgets.header(
      subject: aclass.name,
      title: curriculum.name,
      subtitle: 'годовые (${periods.first.from.year} - ${periods.last.till.year})',
    );
  }
}
