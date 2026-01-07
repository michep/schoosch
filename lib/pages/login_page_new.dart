import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/proxy_controller.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/admin/admin_page.dart';
import 'package:schoosch/pages/home_page.dart';
import 'package:schoosch/pages/set_password_page.dart';
import 'package:schoosch/widgets/appbar.dart';

class LoginPageNew extends StatefulWidget {
  const LoginPageNew({super.key});

  @override
  State<LoginPageNew> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPageNew> {
  String? username;
  String? password;
  bool _obscurePassword = true;

  final formKey = GlobalKey<FormState>();

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
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Электронная почта',
                        prefixIcon: Icon(Icons.mail),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onChanged: (value) {
                        formKey.currentState!.setState(() {
                          username = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Введите электронную почту';
                        }
                        return null;
                      },
                      autofocus: true,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Пароль',
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      onChanged: (value) {
                        formKey.currentState!.setState(() {
                          password = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Введите пароль';
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
                            'Войти',
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
        await proxy.loginWithUsernamePassword(username!.trim(), password!.trim());
        if (proxy.currentUser!.shouldSetPassword) {
          Get.to(() => const SetPasswordPage());
          return;
        }
        if (proxy.currentUser!.currentType == PersonType.admin) {
          Get.offAll(() => const AdminPage());
        } else {
          Get.offAll(() => const HomePage());
        }
      } catch (e) {
        Get.snackbar(
          'Не удалось войти',
          'Неправильная электронная почта или пароль.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black,
        );
      }
    }
  }
}
