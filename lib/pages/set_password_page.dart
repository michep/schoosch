import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/proxy_controller.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/admin/admin_page.dart';
import 'package:schoosch/pages/home_page.dart';
import 'package:schoosch/pages/login_page_new.dart';
import 'package:schoosch/widgets/appbar.dart';

class SetPasswordPage extends StatefulWidget {
  const SetPasswordPage({super.key});

  @override
  State<SetPasswordPage> createState() => _SetPasswordPageState();
}

class _SetPasswordPageState extends State<SetPasswordPage> {
  String? passwordFirst;
  String? passwordSecond;
  bool _obscurePasswordFirst = true;
  bool _obscurePasswordSecond = true;

  int maxRetryTimes = 3;
  int currentRetryTimes = 0;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MAppBar(
        S.of(context).loginPageTitle,
        showBackButton: false,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Требуется сменить пароль.\nПридумайте пароль от 6 символов.'),
                    const SizedBox(height: 32),
                    TextFormField(
                      obscureText: _obscurePasswordFirst,
                      decoration: InputDecoration(
                        labelText: 'Новый пароль',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePasswordFirst ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePasswordFirst = !_obscurePasswordFirst;
                            });
                          },
                        ),
                      ),
                      onChanged: (value) => passwordFirst = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Установите новый пароль';
                        } else if (value.length < 6) {
                          return 'Пароль должен быть не менее 6 символов';
                        } else {
                          return null;
                        }
                      },
                      autofocus: true,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      obscureText: _obscurePasswordSecond,
                      decoration: InputDecoration(
                        labelText: 'Повторите пароль',
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
                      validator: (value) {
                        if (value != null && value != passwordFirst) {
                          return 'Пароль не совпадает.';
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) => _save(),
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
                            backgroundColor: Get.theme.primaryColor,
                            foregroundColor: Get.theme.colorScheme.onPrimary,
                          ),
                          onPressed: () => _save(),
                          child: const Text(
                            'Подтвердить',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
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
                          onPressed: () => _logout(),
                          child: const Text(
                            'Назад',
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
      ),
    );
  }

  Future<void> _save() async {
    if (formKey.currentState != null && formKey.currentState!.validate()) {
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
          "Ошибка!",
          'Возникла ошибка при смене пароля.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black,
        );
      }
    }
  }

  Future<void> _logout() async {
    try {
      await Get.find<ProxyStore>().logout();
      Get.offAll(() => const LoginPageNew());
    } catch (e) {
      Get.snackbar(
        "Ошибка!",
        'Возникла ошибка при выходе из профиля',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black,
      );
    }
  }
}
