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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MAppBar(
        S.of(context).loginPageTitle,
      ),
      body: SafeArea(
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                label: Text('Username'),
              ),
              onChanged: (value) => username = value,
            ),
            TextField(
              decoration: InputDecoration(
                label: Text('Password'),
              ),
              onChanged: (value) => password = value,
            ),
            ElevatedButton(
              child: Text('Login'),
              onPressed: () => _save(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    try {
      var proxy = Get.find<ProxyStore>();
      await proxy.loginWithUsernamePassword(username!, password!);
      if (proxy.currentUser!.currentType == PersonType.admin) {
        return Get.offAll(() => const AdminPage());
      } else {
        return Get.offAll(() => const HomePage());
      }
    } catch (e) {
      print(e); //TODO: auth error!!!
    }
  }
}
