import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/proxy_controller.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/admin/admin_page.dart';
import 'package:schoosch/pages/home_page.dart';
import 'package:schoosch/widgets/appbar.dart';

class SetPasswordPage extends StatefulWidget {
  const SetPasswordPage({super.key});

  @override
  State<SetPasswordPage> createState() => _SetPasswordPageState();
}

class _SetPasswordPageState extends State<SetPasswordPage> {
  String? passwordFirst;
  String? passwordSecond;
  bool _obscurePasswordSecond = true;

  int maxRetryTimes = 3;
  int currentRetryTimes = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MAppBar(
        S.of(context).loginPageTitle,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //TODO: использовать форму
                  Text('Требуется сменить пароль.\nПридумайте пароль от 6 символов.'),

                  const SizedBox(height: 32),

                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Новый пароль',
                      prefixIcon: Icon(Icons.mail),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onChanged: (value) => passwordFirst = value,
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    obscureText: _obscurePasswordSecond,
                    decoration: InputDecoration(
                      labelText: 'Повторите новый пароль',
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePasswordSecond ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePasswordSecond = !_obscurePasswordSecond;
                          });
                        },
                      ),
                    ),
                    onChanged: (value) => passwordSecond = value,
                  ),
                  const SizedBox(height: 32),

                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () => _save(),
                        child: const Text(
                          'Подтвердить',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ), //TODO: тут еще должна быть кнопка Отмены, которая делает logout
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    //TODO: использовать валидацию формы и подписи ошибок к полям, а не снэкбарами
    if (passwordFirst == null || passwordSecond == null || passwordFirst!.isEmpty || passwordSecond!.isEmpty) {
      Get.snackbar("Не заполнено", "Пожалуйста, заполните поля для установки пароля.", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (passwordFirst != passwordSecond) {
      Get.snackbar("Пароль не совпадает", "Проверка показала, что веденные пароли не совпадают друг с другом.", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (passwordFirst!.length < 6) {
      Get.snackbar("Пароль слишком короткий", "Придумайте пароль длиной не менее 6 символов.", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      var proxy = Get.find<ProxyStore>();
      proxy.currentUser!.shouldSetPassword = false;
      proxy.currentUser!.password = passwordFirst;
      proxy.currentUser!.save();
      proxy.currentUser!.password = null;
      if (proxy.currentUser!.currentType == PersonType.admin) {
        Get.offAll(() => const AdminPage());
      } else {
        Get.offAll(() => const HomePage());
      }
    } catch (e) {
      Get.snackbar(
        "Возникла ошибка при смене пароля",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }
}
