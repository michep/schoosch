import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:isoweek/isoweek.dart';
import 'package:schoosch/controller/day_controller.dart';
import 'package:schoosch/controller/auth_controller.dart';
import 'package:schoosch/controller/prefs_controller.dart';
import 'package:schoosch/controller/proxy_controller.dart';
import 'package:schoosch/controller/week_controller.dart';
import 'package:schoosch/firebase_options.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/admin/admin_page.dart';
import 'package:schoosch/pages/home_page.dart';
import 'package:schoosch/pages/login_page.dart';
import 'package:schoosch/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  var fauth = FAuth();
  var proxy = ProxyStore((path) => Uri.https('www.chepaykin.org:8182', path));
  var curweek = CurrentWeek(Week.current());
  var prefs = PrefsController();
  await prefs.init();
  // var bcont = BlueprintController();
  Get.put<FAuth>(fauth);
  Get.put<ProxyStore>(proxy);
  Get.put<CurrentWeek>(curweek);
  Get.put<CurrentDay>(CurrentDay(DateTime.now()));
  Get.put<PrefsController>(prefs);
  // Get.put<BlueprintController>(bcont);
  if (fauth.currentUser != null) {
    await proxy.init(fauth.currentUser!.email!);
    // await bcont.init();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      supportedLocales: S.delegate.supportedLocales,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FirebaseUILocalizations.delegate,
      ],
      locale: const Locale('ru'),
      scrollBehavior: AppScrollBehavior(),
      onGenerateTitle: (context) => S.of(context).appTiile,
      debugShowCheckedModeBanner: false,
      theme: darkTheme,
      home: _homePageSelector(),
    );
  }

  Widget _homePageSelector() {
    if (PersonModel.currentUser == null) return const LoginPage();
    if (PersonModel.currentUser!.currentType == PersonType.admin) return const AdminPage();

    return const HomePage();
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
