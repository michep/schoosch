import 'package:get/get.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/model/yearweek_model.dart';

class CurrentWeek extends GetxController {
  final _store = Get.find<FStore>();
  late final Rx<YearweekModel?> _currentWeek = Rx(null);
  int lastChange = 0;

  YearweekModel get currentWeek => _currentWeek.value!;
  Rx<YearweekModel> get currentWeek$ => _currentWeek as Rx<YearweekModel>;

  CurrentWeek(YearweekModel yw) {
    _currentWeek.value = yw;
  }

  bool changeCurrentWeek(int n) {
    if (_store.getYearweekModelByWeek(_currentWeek.value!.order + n) == null) {
      return false;
    }
    _currentWeek.value = _store.getYearweekModelByWeek(_currentWeek.value!.order + n);
    lastChange = n;
    return true;
  }

  bool changeToCurrentWeek() {
    var cw = _store.getYearweekModelByDate(DateTime.now());
    if (cw.order < currentWeek.order) {
      lastChange = -1;
    }
    if (cw.order > currentWeek.order) {
      lastChange = 1;
    }
    var wm = _store.getYearweekModelByWeek(cw.order);
    if (wm == null) {
      return false;
    }
    _currentWeek.value = wm;
    return true;
  }
}
