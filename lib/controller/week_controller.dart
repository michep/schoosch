import 'package:get/get.dart';
import 'package:isoweek/isoweek.dart';

class CurrentWeek extends GetxController {
  late final Rx<Week> _currentWeek = Rx(Week.current());
  int lastChange = 0;

  Week get currentWeek => _currentWeek.value;
  Rx<Week> get currentWeek$ => _currentWeek;

  CurrentWeek(Week week) {
    _currentWeek.value = week;
  }

  bool changeCurrentWeek(int n) {
    _currentWeek.value = n >= 0 ? _currentWeek.value.next : _currentWeek.value.previous;
    lastChange = n;
    return true;
  }

  bool changeToCurrentWeek() {
    var week = Week.current();
    if (week.weekNumber < currentWeek.weekNumber || week.year < currentWeek.year) {
      lastChange = -1;
    } else if (week.weekNumber > currentWeek.weekNumber || week.year > currentWeek.year) {
      lastChange = 1;
    }
    _currentWeek.value = week;
    return true;
  }
}
