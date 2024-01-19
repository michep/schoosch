import 'dart:math';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:schoosch/model/absence_model.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/studyperiod_model.dart';
import 'package:schoosch/pdf/pdf_theme.dart';
import 'package:schoosch/pdf/pdf_widgets.dart';

class PDFClassCurriculumPeriodAbsences {
  final StudyPeriodModel period;
  final ClassModel aclass;
  final CurriculumModel curriculum;

  PDFClassCurriculumPeriodAbsences({
    required this.period,
    required this.curriculum,
    required this.aclass,
  });

  Future<Uint8List> generate(PdfPageFormat format) async {
    var students = await curriculum.classStudents(aclass);
    // var marks = await curriculum.getLessonMarksByStudents(students, period);
    var absencesList = await period.getAllPeriodAbsences(students);
    // var periodMarks = await curriculum.getPeriodMarksByStudents(students, period);
    Map<StudentModel, Map<DateTime, List<AbsenceModel>>> absences = {};

    for (StudentModel sm in students) {
      List<AbsenceModel> studabsences = absencesList.where((element) => element.personId == sm.id).toList();
      List<DateTime> dates = [];
      for(AbsenceModel am in studabsences) {
        if(!dates.contains(am.date)) {
          dates.add(am.date);
        }
      }
      Map<DateTime, List<AbsenceModel>> absencesbydate = {};
      for(DateTime d in dates) {
        absencesbydate[d] = studabsences.where((element) => element.date == d).toList();
      }
      absences[sm] = absencesbydate; 
    }

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

          buildAbsencesByRows(absences, students, rows);

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
      title: 'Пропуски',
      subtitle: period.name,
    );
  }

  void buildAbsencesByRows(Map<StudentModel, Map<DateTime, List<AbsenceModel>>> data, List<StudentModel> studlist, List<pw.TableRow> rows) {
    int maxlen = 0;
    for (StudentModel i in studlist) {
      if (data[i] != null) maxlen = max(maxlen, data[i]!.length);
    }
    List<pw.Widget> cells = [];
    if (maxlen == 0) {
      for (StudentModel _ in studlist) {
        cells.add(PdfWidgets.nameCell(text: 'нет пропусков.'));
      }
      rows.add(pw.TableRow(children: cells));
    } else {
      for (int i = 0; i < maxlen; i++) {
        cells = [];
        for (StudentModel s in studlist) {
          if (data[s] != null) {
            var keyslist = data[s]!.keys.toList();
            DateTime? dateKey = i >= keyslist.length ? null : keyslist[i];
            List<AbsenceModel>? abs = i >= data[s]!.length || dateKey == null ? null : data[s]![dateKey];
            cells.add(
              PdfWidgets.absenceMarkCell(
                absence: abs,
                date: dateKey,
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
