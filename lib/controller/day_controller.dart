import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:isoweek/isoweek.dart';
import 'package:schoosch/controller/week_controller.dart';

class CurrentDay extends GetxController {
  late final Rx<DateTime> _currentDay = Rx(DateTime.now());
  late final PageController _pageController;

  DateTime get currentDay => _currentDay.value;

  PageController get pageController => _pageController;

  CurrentDay(DateTime dt) {
    _currentDay.value = dt;
    _pageController = PageController(
      initialPage: currentDay.year * 1000 +
          int.parse(
            DateFormat('D').format(
              currentDay,
            ),
          ),
    );
  }

  void setIdx(int idx) {
    _currentDay.value = DateFormat('y D').parse('${idx ~/ 1000} ${idx % 1000}');
    _pageController.animateToPage(
      currentDay.year * 1000 +
          int.parse(
            DateFormat('D').format(
              currentDay,
            ),
          ),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutExpo,
    );
  }

  void next() {
    if (_currentDay.value.weekday == 7) {
      Get.find<CurrentWeek>().next();
    } else {
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
  }

  void previous() {
    if (_currentDay.value.weekday == 1) {
      Get.find<CurrentWeek>().previous(
        isFromDay: true,
      );
    } else {
      _currentDay.value = _currentDay.value.subtract(
        const Duration(
          days: 1,
        ),
      );
      _pageController.previousPage(
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeOutExpo,
      );
    }
  }

  void setDate(DateTime date, {bool isFromWeek = false}) {
    _currentDay.value = date;
    if (!isFromWeek) Get.find<CurrentWeek>().setIdx(date.year * 100 + Week.fromDate(date).weekNumber);
    _pageController.animateToPage(
      date.year * 1000 +
          int.parse(
            DateFormat('D').format(
              date,
            ),
          ),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutExpo,
    );
  }

  void changeToCurrentDay() {
    setDate(
      DateTime.now(),
    );
  }
}