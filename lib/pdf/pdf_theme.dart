import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart';

Future<ThemeData> getTheme() async {
  return ThemeData.withFont(
    base: Font.ttf(await rootBundle.load("assets/fonts/Lato-Regular.ttf")),
    bold: Font.ttf(await rootBundle.load("assets/fonts/Lato-Bold.ttf")),
    italic: Font.ttf(await rootBundle.load("assets/fonts/Lato-Italic.ttf")),
    boldItalic: Font.ttf(await rootBundle.load("assets/fonts/Lato-BoldItalic.ttf")),
  );
}
