import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/studyperiod_model.dart';
import 'package:schoosch/pdf/pdf_theme.dart';
import 'package:schoosch/pdf/pdf_widgets.dart';

class PDFStudentYearMarks {
  final List<StudyPeriodModel> periods;
  final StudentModel student;

  PDFStudentYearMarks({
    required this.periods,
    required this.student,
  });

  Future<Uint8List> generate(PdfPageFormat format) async {
    var curriculums = await student.curriculums();
    var periodMarks = await student.getAllPeriodsMarks(curriculums, periods);

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
                PdfWidgets.emptyCell(),
                ...periods.map(
                  (e) => PdfWidgets.nameCell(text: e.name),
                ),
              ],
            ),
          );

          for (var cur in curriculums) {
            rows.add(
              pw.TableRow(
                children: [
                  PdfWidgets.nameCell(text: cur.aliasOrName),
                  if (periodMarks[cur] != null)
                    ...periodMarks[cur]!.map((e) => PdfWidgets.periodMarkCell(
                          mark: e,
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 10,
                        )),
                  if (periodMarks[cur] == null) ...periods.map((e) => PdfWidgets.emptyCell()),
                ],
              ),
            );
          }

          return [
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.black),
              tableWidth: pw.TableWidth.min,
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
      subject: student.fullName,
      title: 'оценки по всем предметам',
      subtitle: 'годовые',
    );
  }
}
