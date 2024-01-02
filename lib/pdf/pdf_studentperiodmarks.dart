import 'dart:math';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/mark_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/studyperiod_model.dart';
import 'package:schoosch/pdf/pdf_theme.dart';
import 'package:schoosch/pdf/pdf_widgets.dart';
import 'package:schoosch/widgets/utils.dart';

class PDFStudentPeriodMarks {
  final StudyPeriodModel period;
  final StudentModel student;

  PDFStudentPeriodMarks({
    required this.period,
    required this.student,
  });

  Future<Uint8List> generate(PdfPageFormat format) async {
    var curriculums = await student.curriculums();
    var curriculumsMarks = await student.getLessonMarksByCurriculums(curriculums, period);

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
                ...curriculums.map(
                  (e) => PdfWidgets.nameCell(text: e.aliasOrName),
                ),
              ],
            ),
          );

          buildMarksByRows(curriculumsMarks, curriculums, rows);

          rows.add(
            pw.TableRow(
              children: [
                ...curriculums.map(
                  (e) => PdfWidgets.summaryMarkCell(
                    value: Utils.calculateWeightedAverageMark(curriculumsMarks[e]!).toStringAsFixed(1),
                  ),
                ),
              ],
            ),
          );

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
      subtitle: period.name,
    );
  }

  void buildMarksByRows(Map<CurriculumModel, List<LessonMarkModel>> data, List<CurriculumModel> curlist, List<pw.TableRow> rows) {
    int maxlen = 0;
    for (CurriculumModel i in curlist) {
      maxlen = max(maxlen, data[i]!.length);
    }
    for (int i = 0; i < maxlen; i++) {
      List<pw.Widget> cells = [];
      for (CurriculumModel s in curlist) {
        if (data[s] != null) {
          LessonMarkModel? mark = i >= data[s]!.length ? null : data[s]![i];
          cells.add(
            PdfWidgets.lessonMarkCell(
              mark: mark,
            ),
          );
        }
      }
      rows.add(
        pw.TableRow(
          children: cells,
        ),
      );
    }
  }

  // pw.Widget _emptyCell() {
  //   return pw.Text('.', style: const pw.TextStyle(color: PdfColors.white));
  // }
}
