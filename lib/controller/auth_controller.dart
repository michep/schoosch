import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/proxy_controller.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/admin/admin_page.dart';
import 'package:schoosch/pages/home_page.dart';
import 'package:schoosch/pages/login_page.dart';

class FAuth {
  late final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;
  String? token;
  late Stream<PersonModel?> authStream$;
  StreamSubscription<PersonModel?>? sub;

  Future<void> init() async {
    await Future.delayed(const Duration(minutes: 0), _refreshToken);
    authStream$ = _auth.authStateChanges().asyncMap<PersonModel?>(_asyncMap).distinct();
  }

  void startListen() {
    sub?.cancel();
    sub = authStream$.listen(_authChanged);
  }

  Future<void> logout() {
    return _auth.signOut();
  }

  Future<PersonModel?> _asyncMap(User? user) async {
    var proxy = Get.find<ProxyStore>();
    if (user == null) {
      token = null;
      proxy.resetCurrentUser();
      return null;
    }
    if (proxy.currentUser == null) {
      token = await user.getIdToken(true);
      await proxy.init(user.email!);
    }
    return proxy.currentUser;
  }

  void _authChanged(PersonModel? user) async {
    var proxy = Get.find<ProxyStore>();
    if (user != null) {
      proxy.logEvent({
        'event': 'LOGIN',
        'useremail': user.email,
      });
      if (user.currentType == PersonType.admin) {
        return Get.offAll(() => const AdminPage());
      } else {
        return Get.offAll(() => const HomePage());
      }
    } else {
      return Get.offAll(() => const LoginPage());
    }
  }

  void _refreshToken() async {
    token = await _auth.currentUser?.getIdToken(true);
    Future.delayed(const Duration(minutes: 10), _refreshToken);
  }
}
