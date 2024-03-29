import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoosch/model/mark_model.dart';
import 'package:schoosch/model/marktype_model.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static DefaultMaterialLocalizations defaultLocalizations = const DefaultMaterialLocalizations();
  static Widget progressIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  static String? validateTextNotEmpty(String? value, String error) {
    return (value == null || value.isEmpty) ? error : null;
  }

  static String? validateNumNotEmpty(String? value, String error) {
    return (value == null || value.isEmpty || !value.isNum) ? error : null;
  }

  static String? validateTextAndvAlueNotEmpty<T>(String? textValue, T? value, String error) {
    return (textValue == null || textValue.isEmpty || value == null) ? error : null;
  }

  static String? validateDateTimeNotEmpty(DateTime? value, String error) {
    return (value == null) ? error : null;
  }

  static String? validaTimeNotEmptyeAndValid(String? value, String error) {
    if (value == null) return error;
    var a = value.split(':');
    if (a.length != 2) return error;
    var h = int.tryParse(a[0]);
    var m = int.tryParse(a[1]);
    if (h == null || h < 0 || h > 24) return error;
    if (m == null || m < 0 || m > 60) return error;
    return null;
  }

  static String? validateMark(int? mark, String error) {
    return (mark == null || mark < 1 || mark > 5) ? error : null;
  }

  static String? validateMarkType(MarkType? type, String error) {
    return (type == null || type.id == null) ? error : null;
  }

  static Future<void> showErrorSnackbar(String text) async {
    Get.snackbar(
      'Ошибка',
      text,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      colorText: Colors.red,
      animationDuration: const Duration(milliseconds: 500),
    );
  }

  static String dayName(int n) {
    List<String> dayNames = ['Понедельник', 'Вторник', 'Среда', 'Четверг', 'Пятница', 'Суббота', 'Воскресенье'];
    return dayNames[n];
  }

  static String formatPeriod(DateTime from, DateTime? till, {String format = 'dd MMM yyyy', locale = 'ru'}) {
    if (till != null) {
      return '${DateFormat(format, locale).format(from)} \u2014 ${DateFormat(format, locale).format(till)}';
    } else {
      return '${DateFormat(format, locale).format(from)} \u2014 по сей день';
    }
  }

  static String formatDatetime(DateTime value, {String format = 'dd MMM yyyy', locale = 'ru'}) {
    return DateFormat(format, locale).format(value);
  }

  static String formatTimeOfDay(TimeOfDay? value, {bool alwaysUse24HourFormat = true}) {
    if (value != null) return defaultLocalizations.formatTimeOfDay(value, alwaysUse24HourFormat: alwaysUse24HourFormat);
    return '';
  }

  static Map<String, List<LessonMarkModel>> splitLessonMarksByStudent(List<LessonMarkModel> marks) {
    Map<String, List<LessonMarkModel>> res = {};
    for (var m in marks) {
      if (res[m.studentId] == null) res[m.studentId] = [];
      res[m.studentId]!.add(m);
    }
    return res;
  }

  static Map<String, List<LessonMarkModel>> splitLessonMarksByCurriculum(List<LessonMarkModel> marks) {
    Map<String, List<LessonMarkModel>> res = {};
    for (var m in marks) {
      if (res[m.curriculumId] == null) res[m.curriculumId] = [];
      res[m.curriculumId]!.add(m);
    }
    return res;
  }

  static Map<String, PeriodMarkModel> splitPeriodMarksByStudent(List<PeriodMarkModel> marks) {
    Map<String, PeriodMarkModel> res = {};
    for (var m in marks) {
      res[m.studentId] = m;
    }
    return res;
  }

  static Map<String, PeriodMarkModel> splitPeriodMarksByCurriculum(List<PeriodMarkModel> marks) {
    Map<String, PeriodMarkModel> res = {};
    for (var m in marks) {
      res[m.curriculumId] = m;
    }
    return res;
  }

  static Map<String, List<PeriodMarkModel>> splitPeriodMarksListByCurriculum(List<PeriodMarkModel> marks) {
    Map<String, List<PeriodMarkModel>> res = {};
    for (var m in marks) {
      if (res[m.curriculumId] == null) res[m.curriculumId] = [];
      res[m.curriculumId]!.add(m);
    }
    return res;
  }

  static Future<void> openLink(String adress) async {
    final url = Uri.parse(adress);
    if (!(await launchUrl(url))) {
      Get.showSnackbar(
        const GetSnackBar(
          title: 'Ой...',
          message: 'Не получилось открыть ссылку.',
        ),
      );
    }
  }

  static double calculateWeightedAverageMark(List<LessonMarkModel> listmarks) {
    double sum = 0;
    double kolvo = 0;
    for (LessonMarkModel mark in listmarks) {
      double times = mark.type.weight;
      sum += mark.mark * times;
      kolvo += times;
      // sum += mark.mark;
    }
    return (sum / kolvo);
  }
}
