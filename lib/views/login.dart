import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:get/get.dart';
import 'package:schoosch/data/fireauth.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Вход в приложение'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SignInButton(
              Buttons.GoogleDark,
              text: 'Вход c помощью Google',
              onPressed: _onPressedGoogle,
            ),
          ),
          Center(
            child: SignInButton(
              Buttons.Email,
              text: 'Вход по email и паролю',
              onPressed: _onPressedEmail,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onPressedGoogle() async {
    var fa = Get.find<FAuth>();

    var creds = await fa.signInWithGoogle();
    if (creds != null) {
      var u = creds.user;
      if (u != null) {
        print(u.toString());
      }
    }
  }

  Future<void> _onPressedEmail() async {
    var fa = Get.find<FAuth>();
    var creds = await fa.signInWithEmail();
    if (creds != null) {
      var u = creds.user;
      if (u != null) {
        print(u.toString());
      }
    }
  }
}
