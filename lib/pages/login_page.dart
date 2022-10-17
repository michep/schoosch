import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:get/get.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:schoosch/controller/fire_auth_controller.dart';
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

  @override
  void initState() {
    if (_auth.currentUser != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) => _authenticated(_auth.currentUser!));
    }
    _sub = _auth.userChanges$.listen(_authenticated);
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
      body: const SignInScreen(
        providerConfigs: [
          EmailProviderConfiguration(),
          // GoogleProviderConfiguration(clientId: '245847143504-ipg09aij94ufg1msovph5cbvsesvnvhm.apps.googleusercontent.com'),
        ],
      ),
    );
  }

  void _authenticated(User? user) async {
    // var fstore = Get.find<FStore>();
    // var store = Get.find<FStorage>();
    // var bcont = Get.find<BlueprintController>();
    // var mstore = Get.find<MStore>();
    // var store = Get.find<FStorage>();
    var proxy = Get.find<ProxyStore>();

    if (user == null) {
      // mstore.resetCurrentUser();
      proxy.resetCurrentUser();
    }
    if (user != null && proxy.currentUser == null) {
      // await fstore.init(user.email!);
      // await store.init(fstore.currentInstitution!.id);
      // await bcont.init();
      // await mstore.init(user.email!);
      // await store.init(mstore.db);
      await proxy.init(user.email!);

      // OneSignal.shared.setExternalUserId(PersonModel.currentUser!.id!.toHexString());
      PersonModel.currentUser!.currentType == PersonType.admin ? Get.offAll(() => const AdminPage()) : Get.offAll(() => const HomePage());
    }
  }
}
