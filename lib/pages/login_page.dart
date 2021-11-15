import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/fire_auth_controller.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/controller/week_controller.dart';
import 'package:schoosch/pages/home_page.dart';
import 'package:schoosch/widgets/appbar.dart';

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
      appBar: const MAppBar(
        'Вход в приложение',
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
          await _authenticated(null);
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
          await _authenticated(null);
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

  Future<void> _authenticated(_) async {
    var auth = Get.find<FAuth>();
    Get.delete<FStore>();
    await Get.putAsync(
      () async {
        FStore store = FStore();
        await store.init(auth.currentUser!.email!);
        return store;
      },
      permanent: true,
    ).then((_) {
      Get.put(CurrentWeek(Get.find<FStore>().getYearweekModelByDate(DateTime.now())));
      Get.offAll(() => HomePage());
    });
  }
}
