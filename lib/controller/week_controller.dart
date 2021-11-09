import 'package:get/get.dart';
import 'package:schoosch/model/yearweek_model.dart';

class CurrentWeek extends GetxController {
  late YearweekModel _currentWeek;
  List<YearweekModel> cwl = [];

  get currentWeek$ => cwl[0].obs;

  set currentWeek(YearweekModel ywm) {
    _currentWeek = ywm;
    cwl.removeAt(0);
    cwl.add(ywm);
    update();
  }

  CurrentWeek(this._currentWeek) {
    cwl.add(_currentWeek);
  }
}
