import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:schoosch/model/absence_model.dart';
import 'package:schoosch/model/mark_model.dart';

class PdfWidgets {
  static pw.Widget header({required String subject, required String title, required String subtitle}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            subject,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.Row(
            children: [
              pw.Text(
                title,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(width: 10),
              pw.Text(
                subtitle,
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget nameCell({required String text}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(2),
      child: pw.SizedBox(
        //constraints: const pw.BoxConstraints(minWidth: 30, maxWidth: 50),
        width: 100,
        child: pw.Text(text),
      ),
    );
  }

  static pw.Widget lessonMarkCell({
    required LessonMarkModel? mark,
    double? fontSize,
    pw.FontWeight? fontWeight,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(2),
      child: pw.SizedBox(
        width: 10,
        child: mark != null
            ? pw.Column(
                children: [
                  pw.Text(
                    DateFormat.Md().format(mark.date),
                    style: pw.TextStyle(fontSize: fontSize, fontWeight: fontWeight),
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    mainAxisSize: pw.MainAxisSize.min,
                    children: [
                      pw.Text(
                        mark.mark.toString(),
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(width: 4),
                      pw.Text('(x${mark.type.weight.toStringAsFixed(1)})'),
                    ],
                  ),
                ],
              )
            : pw.Text('.', style: const pw.TextStyle(color: PdfColors.white)),
      ),
    );
  }

  static pw.Widget absenceMarkCell({
    required List<AbsenceModel>? absence,
    required DateTime? date,
    double? fontSize,
    pw.FontWeight? fontWeight,
  }) {
    String lessonsNums = '';
    List<int> nums = [];
    if (absence != null) {
      for (AbsenceModel a in absence) {
        nums.add(a.lessonOrder);
      }
    }
    nums.sort();
    lessonsNums = nums.toString().replaceAll('[', '').replaceAll(']', '');
    return pw.Padding(
      padding: const pw.EdgeInsets.all(2),
      child: pw.SizedBox(
        width: 10,
        child: absence != null && date != null
            ? pw.Column(
                children: [
                  pw.Text(
                    DateFormat.Md().format(date),
                    style: pw.TextStyle(fontSize: fontSize, fontWeight: fontWeight),
                  ),
                  pw.Text('Уроки:'),
                  pw.Text(lessonsNums),
                ],
              )
            : pw.Text('.', style: const pw.TextStyle(color: PdfColors.white)),
      ),
    );
  }

  static pw.Widget periodMarkCell({
    required PeriodMarkModel? mark,
    double? fontSize,
    pw.FontWeight? fontWeight,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(2),
      child: pw.SizedBox(
        width: 10,
        child: mark != null
            ? pw.Text(
                mark.mark.toString(),
                style: pw.TextStyle(
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                ),
              )
            : pw.Text('.', style: const pw.TextStyle(color: PdfColors.white)),
      ),
    );
  }

  static pw.Widget summaryMarkCell({
    required String value,
    double? fontSize,
    pw.FontWeight? fontWeight,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(2),
      child: pw.SizedBox(
        width: 10,
        child: pw.Column(
          children: [
            pw.Text('средний балл'),
            pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: fontSize,
                fontWeight: fontWeight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static pw.Widget emptyCell() {
    return pw.Text('.', style: const pw.TextStyle(color: PdfColors.white));
  }
}
