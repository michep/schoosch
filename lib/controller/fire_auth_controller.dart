import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class FAuth extends GetxController {
  late final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;
  String? token;
  Stream<User?> get authStateChanges$ => _auth.authStateChanges();

  @override
  onInit() {
    super.onInit();
    _auth.idTokenChanges().listen((user) {
      user == null ? token = null : user.getIdToken().then((value) => token = value);
    });
  }

  Future<void> logout() {
    return _auth.signOut();
  }
}
