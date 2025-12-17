import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/proxy_controller.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/admin/admin_page.dart';
import 'package:schoosch/pages/home_page.dart';
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
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'e-mail',
                      prefixIcon: Icon(Icons.mail),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onChanged: (value) => username = value,
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    obscureText: _obscurePassword, 
                    decoration: InputDecoration(
                      labelText: 'пароль',
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
                    onChanged: (value) => password = value,
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
                          'войти',
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
    if (username == null || password == null || username!.isEmpty || password!.isEmpty) {
      Get.snackbar("Error", "Пожалуйста, введите e-mail и пароль.", 
        snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      var proxy = Get.find<ProxyStore>();
      await proxy.loginWithUsernamePassword(username!, password!);
      if (proxy.currentUser!.currentType == PersonType.admin) {
        Get.offAll(() => const AdminPage());
      } else {
        Get.offAll(() => const HomePage());
      }
    } catch (e) {
        print(e); //TODO: auth error!!!
        Get.snackbar("Login Failed", e.toString(), 
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
    }
  }
}