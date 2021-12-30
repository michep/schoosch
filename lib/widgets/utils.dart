import 'package:flutter/material.dart';

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
}
