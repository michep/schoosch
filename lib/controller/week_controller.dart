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
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        currentWeek.year * 100 + currentWeek.weekNumber,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeOutExpo,
      );
    }
  }

  void next() {
    _currentWeek.value = _currentWeek.value.next;
    Get.find<CurrentDay>().setDate(_currentWeek.value.days.first, isFromWeek: true);
    if (_pageController.hasClients) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeOutExpo,
      );
    }
  }

  void previous({bool isFromDay = false}) {
    _currentWeek.value = _currentWeek.value.previous;
    Get.find<CurrentDay>().setDate(isFromDay ? _currentWeek.value.days.last : _currentWeek.value.days.first, isFromWeek: true);
    if (_pageController.hasClients) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeOutExpo,
      );
    }
  }

  Future<void> changeToCurrentWeek() async {
    var week = Week.current();
    var nIdx = week.year * 100 + week.weekNumber;
    var cIdx = currentWeek.year * 100 + currentWeek.weekNumber;
    int direction = 0;
    if (nIdx > cIdx) direction = -1;
    if (nIdx < cIdx) direction = 1;
    if (direction == 0) return Future.value();
    _pageController.jumpToPage(nIdx + direction);
    _currentWeek.value = week;
    return _pageController.animateToPage(nIdx, duration: const Duration(milliseconds: 1000), curve: Curves.easeOutExpo);
  }
}
