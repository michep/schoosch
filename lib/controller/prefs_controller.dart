import 'package:get/get.dart';
import 'package:encrypt_shared_preferences/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsController extends GetxController {
  late Rx<bool> isDayView;
  static const String viewKey = 'view';
  static const String refreshTokenKey = 'refresh_token';

  late final EncryptedSharedPreferences prefs;

  Future<void> init() async {
    await EncryptedSharedPreferences.initialize('schooschschoosch');
    prefs = EncryptedSharedPreferences.getInstance();
    try {
      prefs.getKeys();
    } on ArgumentError {
      var sp = await SharedPreferences.getInstance();
      var viewVal = sp.getKeys().contains(viewKey) ? sp.getBool(viewKey) : false;
      sp.clear();
      prefs.setBool(viewKey, viewVal);
    }
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
    return prefs.getKeys().contains(viewKey) ? prefs.getBool(viewKey) : false;
  }

  String? getRefreshToken() {
    if (prefs.getKeys().contains(refreshTokenKey)) {
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
