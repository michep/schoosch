import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/proxy_controller.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/admin/admin_page.dart';
import 'package:schoosch/pages/home_page.dart';
import 'package:schoosch/pages/login_page_new.dart';

class LoaderPage extends StatefulWidget {
  const LoaderPage({super.key});

  @override
  State<LoaderPage> createState() => _LoaderPageState();
}

class _LoaderPageState extends State<LoaderPage> {
  @override
  void initState() {
    super.initState();
    _checkLoginWithToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Future<void> _checkLoginWithToken() async {
    var proxy = Get.find<ProxyStore>();
    bool hasLoggedInWithToken = await proxy.loginWithToken();
    if (hasLoggedInWithToken) {
      if (proxy.currentUser!.currentType == PersonType.admin) {
        Get.offAll(() => const AdminPage());
      } else {
        Get.offAll(() => const HomePage());
      }
    } else {
       Get.offAll(() => const LoginPageNew());
    }
  }
}
