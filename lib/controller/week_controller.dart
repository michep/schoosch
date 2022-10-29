import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isoweek/isoweek.dart';
import 'package:schoosch/controller/day_controller.dart';

class CurrentWeek extends GetxController {
  late final Rx<Week> _currentWeek = Rx(Week.current());
  late final PageController _pageController;

  Week get currentWeek => _currentWeek.value;

  PageController get pageController => _pageController;

  CurrentWeek(Week week) {
    _currentWeek.value = week;
    _pageController = PageController(initialPage: currentWeek.year * 100 + currentWeek.weekNumber);
  }

  void setIdx(int idx) {
    _currentWeek.value = Week(year: idx ~/ 100, weekNumber: idx % 100);
    _pageController.animateToPage(
      currentWeek.year * 100 + currentWeek.weekNumber,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutExpo,
    );
  }

  void next() {
    _currentWeek.value = _currentWeek.value.next;
    Get.find<CurrentDay>().setDate(
      _currentWeek.value.days[0],
    );
    _pageController.nextPage(
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutExpo,
    );
  }

  void previous({bool isFromDay = false}) {
    _currentWeek.value = _currentWeek.value.previous;
    Get.find<CurrentDay>().setDate(
      _currentWeek.value.days[isFromDay ? 6 : 0],
    );
    _pageController.previousPage(
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutExpo,
    );
  }

  Future<void> changeToCurrentWeek() async {
    var week = Week.current();
    var cIdx = week.year * 100 + week.weekNumber;
    int direction = 0;
    if (cIdx > (currentWeek.year * 100 + currentWeek.weekNumber)) direction = 1;
    if (cIdx < (currentWeek.year * 100 + currentWeek.weekNumber)) direction = -1;
    if (direction == 0) return Future.value();
    _pageController.jumpToPage(cIdx + -1 * direction);
    _currentWeek.value = week;
    return _pageController.animateToPage(cIdx, duration: const Duration(milliseconds: 1000), curve: Curves.easeOutExpo);
  }
}
