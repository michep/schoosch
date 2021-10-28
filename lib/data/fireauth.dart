import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FAuth extends GetxController {
  late final FirebaseAuth _auth;

  FAuth() {
    _auth = FirebaseAuth.instance;
    print(_auth.currentUser);
  }

  Future<UserCredential?> signInWithGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser != null) {
      GoogleSignInAuthentication? googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return await _auth.signInWithCredential(credential);
    } else {
      return null;
    }
  }

  Future<UserCredential?> signInWithEmail() async {
    final credential = await _auth.signInWithEmailAndPassword(email: 'michep@mail.ru', password: '123123123');
    return credential;
  }
}
