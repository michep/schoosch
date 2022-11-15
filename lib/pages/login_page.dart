import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/auth_controller.dart';
import 'package:schoosch/controller/proxy_controller.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/admin/admin_page.dart';
import 'package:schoosch/pages/home_page.dart';
import 'package:schoosch/widgets/appbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = Get.find<FAuth>();
  late StreamSubscription _sub;
  firebase_auth.User? prevUser;

  @override
  void initState() {
    if (_auth.currentUser != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) => _authenticated(_auth.currentUser!));
    }
    _sub = _auth.authStateChanges$.listen(_authenticated);
    super.initState();
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MAppBar(
        S.of(context).loginPageTitle,
      ),
      body: SignInScreen(
        providers: [
          EmailAuthProvider(),
          // GoogleProviderConfiguration(clientId: '245847143504-ipg09aij94ufg1msovph5cbvsesvnvhm.apps.googleusercontent.com'),
        ],
      ),
    );
  }

  void _authenticated(firebase_auth.User? user) async {
    var proxy = Get.find<ProxyStore>();

    if (user == null) {
      proxy.resetCurrentUser();
    }
    if (user != null && proxy.currentUser == null) {
      await proxy.init(user.email!);

      proxy.logEvent({
        'event': 'LOGIN',
        'useremail': user.email,
      });

      PersonModel.currentUser!.currentType == PersonType.admin ? Get.offAll(() => const AdminPage()) : Get.offAll(() => const HomePage());
    }
  }
}
