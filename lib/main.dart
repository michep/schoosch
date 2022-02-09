import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutterfire_ui/i10n.dart';
import 'package:get/get.dart';
import 'package:isoweek/isoweek.dart';
import 'package:schoosch/controller/blueprint_controller.dart';
import 'package:schoosch/controller/fire_auth_controller.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/controller/week_controller.dart';
import 'package:schoosch/firebase_options.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/pages/admin/admin_page.dart';
import 'package:schoosch/pages/home_page.dart';
import 'package:schoosch/pages/login_page.dart';

import 'model/person_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  var fauth = FAuth();
  var fstore = FStore();
  var bcont = BlueprintController();
  Get.put<FAuth>(fauth);
  Get.put<FStore>(fstore);
  Get.put(CurrentWeek(Week.current()));
  Get.put<BlueprintController>(bcont);
  if (fauth.currentUser != null) {
    await fstore.init(fauth.currentUser!.email!);
    await bcont.init();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      supportedLocales: S.delegate.supportedLocales,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      // locale: const Locale('ru'),
      scrollBehavior: AppScrollBehavior(),
      onGenerateTitle: (context) => S.of(context).appTiile,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PersonModel.currentUser != null
          ? PersonModel.currentUser!.currentType == PersonType.admin
              ? const AdminPage()
              : const HomePage()
          : const LoginPage(),
    );
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
