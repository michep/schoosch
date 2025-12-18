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
                  Text('Для регистрации в приложении, для аккаунта требуется установить пароль.\nПридумайте пароль от 6 символов.'),

                  const SizedBox(height: 32),

                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'пароль',
                      prefixIcon: Icon(Icons.mail),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onChanged: (value) => passwordFirst = value,
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    obscureText: _obscurePasswordSecond, 
                    decoration: InputDecoration(
                      labelText: 'повторите пароль',
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
                          'подтвердить',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
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
    if (passwordFirst == null || passwordSecond == null || passwordFirst!.isEmpty || passwordSecond!.isEmpty) {
      Get.snackbar("Не заполнено", "Пожалуйста, заполните поля для установки пароля.", 
        snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if(passwordFirst != passwordSecond) {
      Get.snackbar("Пароль не совпадает", "Проверка показала, что веденные пароли не совпадают друг с другом.", 
        snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if(passwordFirst!.length < 6) {
      Get.snackbar("Пароль слишком короткий", "Придумайте пароль длиной не менее 6 символов.", 
        snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      var proxy = Get.find<ProxyStore>();
      await proxy.setNewPasswordForUser(passwordFirst!);
      if (proxy.currentUser == null) {
        proxy.logout();
        return;
      }
      if (proxy.currentUser!.currentType == PersonType.admin) {
        Get.offAll(() => const AdminPage());
      } else {
        Get.offAll(() => const HomePage());
      }
    } catch (e) {
      print(e); //TODO: auth error!!!
      if(currentRetryTimes < maxRetryTimes) {
        Get.snackbar("Возникла ошибка при смене пароля", e.toString(), 
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
      } else {
        print('Maximum set password attempts exceeded.');
        var proxy = Get.find<ProxyStore>();
        await proxy.logout();
      }
      currentRetryTimes++;
    }
  }
}