import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/proxy_controller.dart';

class FAuth extends GetxController {
  late final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;
  String? token;
  late Stream<User?> authStream$;

  @override
  onInit() {
    super.onInit();
    _auth.idTokenChanges().listen((user) {
      user == null ? token = null : user.getIdToken().then((value) => token = value);
    });

    authStream$ = _auth.authStateChanges().asyncMap<User?>((user) async {
      var proxy = Get.find<ProxyStore>();
      if (user == null) {
        proxy.resetCurrentUser();
      }
      if (user != null && proxy.currentUser == null) {
        await proxy.init(user.email!);
      }
      return user;
    });
    authStream$.listen(_authenticated);
  }

  Future<void> logout() {
    return _auth.signOut();
  }

  void _authenticated(User? user) async {
    if (user != null) {
      Get.find<ProxyStore>().logEvent({
        'event': 'LOGIN',
        'useremail': user.email,
      });
    }
  }
}
