import 'package:get/get.dart';
import 'package:schoosch/model/yearweek_model.dart';

import 'fire_store_controller.dart';

class CurrentWeek extends GetxController {
  late YearweekModel _currentWeek;
  int lastChange = 0;

  final _store = Get.find<FStore>();

  Rx<YearweekModel> get currentWeek$ => _currentWeek.obs;
  YearweekModel get currentWeek => _currentWeek;

  CurrentWeek(this._currentWeek);

  bool changeCurrentWeek(int n) {
    if (_store.getYearweekModelByWeek(_currentWeek.order + n) == null) {
      return false;
    }
    _currentWeek = _store.getYearweekModelByWeek(_currentWeek.order + n)!;
    lastChange = n;
    update();
    return true;
  }
}
