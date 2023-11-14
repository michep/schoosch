import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

Future<ThemeData> getTheme() async {
  return ThemeData.withFont(
    base: Font.ttf(await rootBundle.load("assets/fonts/Lato-Regular.ttf")),
    bold: Font.ttf(await rootBundle.load("assets/fonts/Lato-Bold.ttf")),
    italic: Font.ttf(await rootBundle.load("assets/fonts/Lato-Italic.ttf")),
    boldItalic: Font.ttf(await rootBundle.load("assets/fonts/Lato-BoldItalic.ttf")),
  );
}

PdfPageFormat get landscapePdfPageFormat {
  return PdfPageFormat.a4.landscape.copyWith(
    marginLeft: 1 * PdfPageFormat.cm,
    marginTop: 1 * PdfPageFormat.cm,
    marginRight: 1 * PdfPageFormat.cm,
    marginBottom: 1 * PdfPageFormat.cm,
  );
}

PdfPageFormat get portraitPdfPageFormat {
  return PdfPageFormat.a4.portrait.copyWith(
    marginLeft: 1 * PdfPageFormat.cm,
    marginTop: 1 * PdfPageFormat.cm,
    marginRight: 1 * PdfPageFormat.cm,
    marginBottom: 1 * PdfPageFormat.cm,
  );
}
