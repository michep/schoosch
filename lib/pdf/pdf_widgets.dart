import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:schoosch/model/absence_model.dart';
import 'package:schoosch/model/mark_model.dart';

const defaultTextStyle = pw.TextStyle(fontSize: 8);

class PdfWidgets {
  static pw.Widget header({required String subject, required String title, required String subtitle}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(2),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            subject,
            style: defaultTextStyle.copyWith(fontWeight: pw.FontWeight.bold),
          ),
          pw.Row(
            children: [
              pw.Text(
                title,
                style: defaultTextStyle.copyWith(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(width: 10),
              pw.Text(
                subtitle,
                style: defaultTextStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget nameCell({required String text, double? angle, bool softWrap = true}) {
    var txt = pw.Padding(
      padding: const pw.EdgeInsets.all(2),
      child: pw.Expanded(
        child: pw.Text(text, style: defaultTextStyle, overflow: pw.TextOverflow.clip, softWrap: softWrap),
      ),
    );

    if (angle != null) {
      return pw.Transform.rotateBox(
        angle: angle,
        child: txt,
      );
    } else {
      return txt;
    }
  }

  static pw.Widget lessonMarkCell({
    required LessonMarkModel? mark,
    double? fontSize,
    pw.FontWeight? fontWeight,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(2),
      child: mark != null
          ? pw.Column(
              children: [
                pw.Text(
                  DateFormat.Md().format(mark.date),
                  style: defaultTextStyle.copyWith(fontSize: fontSize, fontWeight: fontWeight),
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  mainAxisSize: pw.MainAxisSize.min,
                  children: [
                    pw.Text(
                      mark.mark.toString(),
                      style: defaultTextStyle.copyWith(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(width: 4),
                    pw.Text('(x${mark.type.weight.toStringAsFixed(1)})', style: defaultTextStyle),
                  ],
                ),
              ],
            )
          : pw.Text('.', style: const pw.TextStyle(color: PdfColors.white)),
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
      child: absence != null && date != null
          ? pw.Column(
              children: [
                pw.Text(
                  DateFormat.Md().format(date),
                  style: defaultTextStyle.copyWith(fontSize: fontSize, fontWeight: fontWeight),
                ),
                pw.Text('Уроки:', style: defaultTextStyle),
                pw.Text(lessonsNums, style: defaultTextStyle),
              ],
            )
          : pw.Text('.', style: const pw.TextStyle(color: PdfColors.white)),
    );
  }

  static pw.Widget periodMarkCell({
    required PeriodMarkModel? mark,
    pw.FontWeight? fontWeight,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(2),
      child: mark != null
          ? pw.Text(
              mark.mark.toString(),
              style: defaultTextStyle.copyWith(fontWeight: fontWeight),
            )
          : pw.Text('.', style: const pw.TextStyle(color: PdfColors.white)),
    );
  }

  static pw.Widget summaryMarkCell({
    required String value,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(2),
      child: pw.Column(
        children: [
          pw.Text('Ср.балл', style: defaultTextStyle),
          pw.Text(
            value,
            style: defaultTextStyle.copyWith(fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }

  static pw.Widget emptyCell() {
    return pw.Text('.', style: const pw.TextStyle(color: PdfColors.white));
  }
}
