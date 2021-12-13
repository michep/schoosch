import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class FAuth extends GetxController {
  late final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get userChanges$ => _auth.userChanges();

  Future<void> logout() {
    return _auth.signOut();
  }
}
