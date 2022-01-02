import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
}
