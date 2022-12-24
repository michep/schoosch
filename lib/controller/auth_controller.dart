import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/proxy_controller.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/admin/admin_page.dart';
import 'package:schoosch/pages/home_page.dart';
import 'package:schoosch/pages/login_page.dart';

class FAuth extends GetxController {
  late final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;
  String? token;
  late Stream<User?> authStream$;
  late StreamSubscription<User?> sub;

  @override
  void onInit() {
    super.onInit();
    _auth.idTokenChanges().listen((user) {
      user == null ? token = null : user.getIdToken().then((value) => token = value);
    });

    authStream$ = _auth.authStateChanges().asyncMap<User?>(_asyncMap);
    sub = authStream$.distinct().listen(_authChanged);
  }

  @override
  void onClose() {
    sub.cancel();
  }

  Future<void> logout() {
    return _auth.signOut();
  }

  Future<User?> _asyncMap(User? user) async {
    var proxy = Get.find<ProxyStore>();
    if (user == null) {
      proxy.resetCurrentUser();
    }
    if (user != null && proxy.currentUser == null) {
      await proxy.init(user.email!);
    }
    return user;
  }

  void _authChanged(User? user) async {
    var proxy = Get.find<ProxyStore>();
    if (user != null) {
      proxy.logEvent({
        'event': 'LOGIN',
        'useremail': user.email,
      });
      if (proxy.currentUser!.currentType == PersonType.admin) {
        return Get.offAll(() => const AdminPage());
      } else {
        return Get.offAll(() => const HomePage());
      }
    } else {
      return Get.offAll(() => const LoginPage());
    }
  }
}
