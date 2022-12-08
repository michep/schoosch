import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/widgets/appbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
}
