import 'dart:math';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:isoweek/isoweek.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/dayschedule_model.dart';
import 'package:schoosch/pdf/pdf_theme.dart';

class PDFClassesWeekSchedule {
  final List<ClassModel> classes;
  final Week week;

  final lessonOrderStyle = const pw.TextStyle(fontSize: 8);
  final lessonTimeStyle = const pw.TextStyle(fontSize: 8);
  final lessonNameStyle = const pw.TextStyle(fontSize: 8);
  final lessonMasterStyle = const pw.TextStyle(fontSize: 6, color: PdfColors.grey700);
  final lessonVenueStyle = const pw.TextStyle(fontSize: 6, color: PdfColors.grey700);

  PDFClassesWeekSchedule({
    required this.classes,
    required this.week,
  });

  Future<Uint8List> generate(PdfPageFormat format) async {
    Map<ClassModel, List<ClassScheduleModel>> data = {};
    for (var cls in classes) {
      var sched = await cls.getClassSchedulesWeek(week);
      data[cls] = sched;
    }

    var doc = pw.Document(
      theme: await getTheme(),
    );
    for (var day in [0, 1, 2, 3, 4]) {
      doc.addPage(
        pw.MultiPage(
          pageFormat: format,
          header: (context) => pw.Row(
            children: [
              pw.Padding(padding: const pw.EdgeInsets.fromLTRB(0, 0, 0, 32)),
              pw.Text(
                DateFormat.EEEE().format(week.days[day]).capitalizeFirst!,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ],
          ),
          footer: (context) => pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Text((day + 1).toString()),
            ],
          ),
          build: (context) {
            var oneDayAllClasseseLessons = data.keys.map(
              (aclass) {
                if (data[aclass]!.length > day) {
                  var sched = data[aclass]![day];
                  return sched.toMap(recursive: true)['lesson'] as List<Map<String, dynamic>>;
                } else {
                  return <Map<String, dynamic>>[];
                }
              },
            ).toList();

            var maxLessonsInOneDay = oneDayAllClasseseLessons.map<int>((e) => e.map<int>((e) => e['order']).reduce(max)).reduce(max);
            var maxLessonsInOneDayIdx = oneDayAllClasseseLessons.indexWhere((e) => e.map<int>((e) => e['order']).reduce(max) == maxLessonsInOneDay);

            List<pw.TableRow> rows = [];
            rows.add(pw.TableRow(
              children: [
                _emptyCell(),
                _emptyCell(),
                ...data.keys.map((e) => _cell(text: e.name, fontWeight: pw.FontWeight.bold, fontSize: 10)).toList(),
              ],
            ));

            for (var orderidx = 0; orderidx < maxLessonsInOneDay; orderidx++) {
              List<pw.Widget> rowcells = [];
              rowcells.add(_orderWidget((orderidx + 1).toString()));
              rowcells.add(_timePeriodWidget(oneDayAllClasseseLessons[maxLessonsInOneDayIdx][orderidx]));
              for (var colidx = 0; colidx < data.keys.length; colidx++) {
                orderidx < oneDayAllClasseseLessons[colidx].length
                    ? rowcells.add(_lessonWidget(_getLessonsByOrder(oneDayAllClasseseLessons[colidx], orderidx + 1)))
                    : rowcells.add(_emptyCell());
              }
              rows.add(pw.TableRow(children: rowcells));
            }
            return [
              pw.Table(
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
    }
    return doc.save();
  }

  List<Map<String, dynamic>> _getLessonsByOrder(List<Map<String, dynamic>> data, int order) {
    return data.where((element) => element['order'] == order).toList();
  }

  pw.Widget _orderWidget(String order) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(2),
      child: pw.Column(
        children: [
          pw.Text(order, style: lessonOrderStyle),
        ],
      ),
    );
  }

  pw.Widget _timePeriodWidget(Map<String, dynamic> data) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(2),
      child: pw.Column(
        children: [
          pw.Text('${data['time']['from']} — ${data['time']['till']}', style: lessonTimeStyle),
        ],
      ),
    );
  }

  pw.Widget _lessonWidget(List<Map<String, dynamic>> data) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(2),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisSize: pw.MainAxisSize.min,
        children: data.map((e) => _curriculumWidget(e)).toList(),
      ),
    );
  }

  pw.Widget _curriculumWidget(Map<String, dynamic> data) {
    return pw.Column(
      mainAxisSize: pw.MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          data['curriculum']['alias'] ?? data['curriculum']['name'],
          style: lessonNameStyle,
        ),
        pw.Text(
          '${data['curriculum']['master']['lastname']} ${data['curriculum']['master']['firstname']} ${data['curriculum']['master']['middlename'] ?? ''}',
          style: lessonMasterStyle,
        ),
        pw.Text(
          data['venue']['name'],
          style: lessonVenueStyle,
        ),
      ],
    );
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

  pw.Widget _emptyCell() {
    return pw.Text('.', style: const pw.TextStyle(color: PdfColors.white));
  }
}
