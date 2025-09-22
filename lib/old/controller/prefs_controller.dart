import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsController extends GetxController {
  late Rx<bool> isDayView;
  static const String viewKey = 'view';
  static const String refreshTokenKey = 'refresh_token';

  late final SharedPreferences prefs;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    isDayView = getView()!.obs;
  }

  bool get dayview => isDayView.value;

  Future<void> setView(bool nv) {
    return prefs.setBool(viewKey, nv);
  }

  Future<void> setRefreshToken(String token) {
    return prefs.setString(refreshTokenKey, token);
  }

  bool? getView() {
    return prefs.containsKey(viewKey) ? prefs.getBool(viewKey) : false;
  }

  String? getRefreshToken() {
    if(prefs.containsKey(refreshTokenKey)) {
      return prefs.getString(refreshTokenKey);
    } else {
      return null;
    }
  }

  Future<void> changeViewType(bool v) async {
    isDayView.value = v;
    await setView(v);
  }

   Future<void> clearRefreshToken() {
    return prefs.remove(refreshTokenKey);
  }
}
