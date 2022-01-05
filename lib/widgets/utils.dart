import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Utils {
  static Widget progressIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  static String? validateTextNotEmpty(String? value, String error) {
    return (value == null || value.isEmpty) ? error : null;
  }

  static String? validateDateTimeNotEmpty(DateTime? value, String error) {
    if (value == null) return error;
  }

  static Future<void> showErrorSnackbar(String text) async {
    Get.snackbar(
      'Ошибка',
      text,
      snackPosition: SnackPosition.BOTTOM,
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
}
