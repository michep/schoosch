import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsController extends GetxController {
  late bool isDayView;
  static const String viewKey = 'view';

  late final SharedPreferences prefs;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    isDayView = getView()!;
  }

  Future<void> setView() {
    return prefs.setBool(viewKey, !isDayView);
  }

  bool? getView() {
    return prefs.containsKey(viewKey) ? prefs.getBool(viewKey) : false;
  }
}