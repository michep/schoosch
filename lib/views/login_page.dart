import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:get/get.dart';
import 'package:schoosch/data/fire_auth.dart';
import 'package:schoosch/data/fire_store.dart';
import 'package:schoosch/views/class_selection_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final username = TextEditingController();
  final password = TextEditingController();
  final auth = Get.find<FAuth>();

  @override
  void initState() {
    super.initState();
    if (auth.currentUser != null) {
      SchedulerBinding.instance!.addPostFrameCallback(_authenticated);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Вход в приложение'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'email'),
              controller: username,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'password'),
              obscureText: true,
              autocorrect: false,
              enableSuggestions: false,
              controller: password,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  child: const Text('Зарегистрироваться'),
                  onPressed: _onPressedEmail,
                ),
                ElevatedButton(
                  child: const Text('Войти'),
                  onPressed: _onPressedEmail,
                ),
              ],
            ),
            Center(
              child: SignInButton(
                Buttons.GoogleDark,
                text: 'Вход c помощью Google',
                onPressed: _onPressedGoogle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onPressedGoogle() async {
    try {
      var creds = await auth.signInWithGoogle();
      if (creds != null) {
        var u = creds.user;
        if (u != null) {
          _authenticated(null);
        }
      }
    } on Exception catch (e) {
      Get.showSnackbar(
        GetBar(
          title: 'Ошибка входа',
          message: e.toString(),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  Future<void> _onPressedEmail() async {
    try {
      var creds = await auth.signInWithEmail(username.text, password.text);
      if (creds != null) {
        var u = creds.user;
        if (u != null) {
          _authenticated(null);
        }
      }
    } on Exception catch (e) {
      Get.showSnackbar(
        GetBar(
          title: 'Ошибка входа',
          message: e.toString(),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  void _authenticated(_) {
    final auth = Get.find<FAuth>();
    Get.putAsync<FStore>(() async {
      FStore store = FStore(auth.currentUser!.email!);
      await store.init();
      return store;
    }).then((_) => Get.offAll(() => const ClassSelection()));
  }
}
