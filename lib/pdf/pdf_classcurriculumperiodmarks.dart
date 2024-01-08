import 'dart:math';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/mark_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/studyperiod_model.dart';
import 'package:schoosch/pdf/pdf_theme.dart';
import 'package:schoosch/pdf/pdf_widgets.dart';
import 'package:schoosch/widgets/utils.dart';

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

          rows.add(
            pw.TableRow(
              children: [
                ...students.map(
                  (e) => PdfWidgets.nameCell(text: e.fullName),
                ),
              ],
            ),
          );

          buildMarksByRows(marks, students, rows);

          rows.add(
            pw.TableRow(
              children: [
                ...students.map(
                  (e) => PdfWidgets.summaryMarkCell(
                    value: marks[e] != null ? Utils.calculateWeightedAverageMark(marks[e]!).toStringAsFixed(1) : 'нет данных',
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
      subject: aclass.name,
      title: curriculum.name,
      subtitle: period.name,
    );
  }

  void buildMarksByRows(Map<StudentModel, List<LessonMarkModel>> data, List<StudentModel> studlist, List<pw.TableRow> rows) {
    int maxlen = 0;
    for (StudentModel i in studlist) {
      if (data[i] != null) maxlen = max(maxlen, data[i]!.length);
    }
    List<pw.Widget> cells = [];
    if (maxlen == 0) {
      for (StudentModel _ in studlist) {
        cells.add(PdfWidgets.nameCell(text: 'нет оценок.'));
      }
      rows.add(pw.TableRow(children: cells));
    } else {
      for (int i = 0; i < maxlen; i++) {
        cells = [];
        for (StudentModel s in studlist) {
          if (data[s] != null) {
            LessonMarkModel? mark = i >= data[s]!.length ? null : data[s]![i];
            cells.add(
              PdfWidgets.lessonMarkCell(
                mark: mark,
              ),
            );
          } else {
            cells.add(PdfWidgets.nameCell(text: ''));
          }
        }
        rows.add(
          pw.TableRow(
            children: cells,
          ),
        );
      }
    }
  }

  // pw.Widget _emptyCell() {
  //   return pw.Text('.', style: const pw.TextStyle(color: PdfColors.white));
  // }
}
