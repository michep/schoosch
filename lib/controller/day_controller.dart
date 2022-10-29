import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/week_controller.dart';

class CurrentDay extends GetxController {
  late final Rx<DateTime> _currentDay = Rx(DateTime.now());
  late final PageController _pageController;
  late final CurrentWeek _week;

  DateTime get currentDay => _currentDay.value;

  PageController get pageController => _pageController;

  final cw = Get.find<CurrentWeek>();

  CurrentDay(DateTime dt) {
    _currentDay.value = dt;
    _pageController = PageController(initialPage: currentDay.weekday);
  }

  void setIdx(idx) {
    _currentDay.value = idx + 1;
    _pageController.animateToPage(
      idx + 1,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutExpo,
    );
  }

  void next() {
    _currentDay.value = _currentDay.value.add(
      const Duration(
        days: 1,
      ),
    );
    _pageController.nextPage(
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutExpo,
    );
  }

  void previous() {
    _currentDay.value = _currentDay.value.subtract(
      const Duration(
        days: 1,
      ),
    );
    _pageController.nextPage(
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutExpo,
    );
  }
}
