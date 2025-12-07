import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsController extends GetxController {
  late Rx<bool> isDayView;
  static const String viewKey = 'view';

  late final SharedPreferences prefs;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    isDayView = getView()!.obs;
  }

  bool get dayview => isDayView.value;

  Future<void> setView(bool nv) {
    return prefs.setBool(viewKey, nv);
  }

  bool? getView() {
    return prefs.containsKey(viewKey) ? prefs.getBool(viewKey) : false;
  }

  Future<void> changeViewType(bool v) async {
    isDayView.value = v;
    await setView(v);
  }
}
