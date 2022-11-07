import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:isoweek/isoweek.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/dayschedule_model.dart';
import 'package:schoosch/pdf/pdf_theme.dart';

class PDFSchedule {
  final Map<ClassModel, List<ClassScheduleModel>> data;
  final Week week;

  PDFSchedule({
    required this.data,
    required this.week,
  });

  Future<Uint8List> generate(PdfPageFormat format) async {
    var doc = pw.Document(
      theme: await getTheme(),
    );
    for (var day in [1, 2, 3, 4, 5]) {
      doc.addPage(
        pw.MultiPage(
          pageFormat: format,
          header: (context) => pw.Row(
            children: [
              pw.Padding(padding: const pw.EdgeInsets.fromLTRB(0, 0, 0, 32)),
              pw.Text(
                DateFormat.EEEE().format(week.days[day - 1]).capitalizeFirst!,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ],
          ),
          footer: (context) => pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Text(day.toString()),
            ],
          ),
          build: (context) {
            return [
              pw.Partitions(
                children: [
                  ...data.keys.skip(4).map((aclass) {
                    var sched = data[aclass]![day - 1];
                    var lessonsMap = sched.toMap(recursive: true)['lesson'] as List<Map<String, dynamic>>;
                    return pw.Partition(
                      child: pw.Column(
                        children: [
                          _decoratedBox(
                            child: pw.Row(
                              children: [
                                pw.Text(aclass.name),
                              ],
                            ),
                          ),
                          ...lessonsMap
                              .map(
                                (lessonMap) => _decoratedBox(
                                  child: pw.Row(
                                    children: [
                                      pw.Expanded(
                                        child: pw.Text(lessonMap['curriculum']!['name'] as String),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList()
                        ],
                      ),
                    );
                  }).toList(),
                ],
              )
            ];
          },
        ),
      );
    }
    return doc.save();
  }

  pw.Widget _decoratedBox({required pw.Widget child}) {
    return pw.DecoratedBox(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black),
      ),
      child: child,
    );
  }
}
