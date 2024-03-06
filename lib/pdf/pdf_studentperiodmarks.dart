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
    var allcurriculums = await student.curriculums();
    var curriculumsMarks = await student.getLessonMarksByCurriculums(allcurriculums, period);

    var doc = pw.Document(
      theme: await getTheme(),
    );

    const columnsPerSplit = 15;

    var splits = allcurriculums.length / columnsPerSplit;

    List<pw.Widget> tables = [];

    for (var split = 0; split < splits; split++) {
      var curriculums = allcurriculums.sublist(split * columnsPerSplit, min(split * columnsPerSplit + columnsPerSplit, allcurriculums.length));
      List<pw.TableRow> rows = [];
      Map<int, pw.TableColumnWidth> colW = {for (var v in Iterable.generate(15)) v: const pw.FixedColumnWidth(50)};

      rows.add(
        pw.TableRow(
          children: [
            ...curriculums.map(
              (e) => PdfWidgets.nameCell(text: e.aliasOrName, angle: pi / 2, softWrap: false),
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
                value: curriculumsMarks[e] != null ? Utils.calculateWeightedAverageMark(curriculumsMarks[e]!).toStringAsFixed(1) : 'нет',
              ),
            ),
          ],
        ),
      );

      tables.add(
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 50),
          child: pw.Table(
            border: pw.TableBorder.all(color: PdfColors.black),
            tableWidth: pw.TableWidth.min,
            columnWidths: colW,
            defaultVerticalAlignment: pw.TableCellVerticalAlignment.full,
            children: rows,
          ),
        ),
      );
    }

    doc.addPage(
      pw.MultiPage(
        pageFormat: format,
        header: (context) => _header(),
        build: (context) {
          return tables;
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
      if (data[i] != null) maxlen = max(maxlen, data[i]!.length);
    }
    List<pw.Widget> cells = [];
    // if (maxlen == 0) {
    //   for (CurriculumModel _ in curlist) {
    //     cells.add(PdfWidgets.nameCell(text: 'нет оценок.'));
    //     rows.add(pw.TableRow(children: cells));
    //   }
    // } else {
    for (int i = 0; i < maxlen; i++) {
      cells = [];
      for (CurriculumModel s in curlist) {
        if (data[s] != null) {
          LessonMarkModel? mark = i >= data[s]!.length ? null : data[s]![i];
          cells.add(
            PdfWidgets.lessonMarkCell(
              mark: mark,
            ),
          );
          // } else if (i == 0) {
          //   cells.add(PdfWidgets.nameCell(text: 'нет оценок.'));
        } else {
          cells.add(PdfWidgets.emptyCell());
        }
      }
      rows.add(
        pw.TableRow(
          children: cells,
        ),
      );
    }
    // }
  }
}
