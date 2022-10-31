import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutterfire_ui/i10n.dart';
import 'package:get/get.dart';
import 'package:isoweek/isoweek.dart';
import 'package:schoosch/controller/day_controller.dart';
import 'package:schoosch/controller/fire_auth_controller.dart';
import 'package:schoosch/controller/proxy_controller.dart';
import 'package:schoosch/controller/storage_controller.dart';
import 'package:schoosch/controller/week_controller.dart';
import 'package:schoosch/firebase_options.dart';
import 'package:schoosch/flutterfire_ui_ru.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/pages/admin/admin_page.dart';
import 'package:schoosch/pages/home_page.dart';
import 'package:schoosch/pages/login_page.dart';
import 'package:schoosch/theme.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'model/person_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  var fauth = FAuth();
  // var fstore = FStore();
  // var mstore = MStore();
  var store = FStorage();
  var proxy = ProxyStore((path) => Uri.https('www.chepaykin.org:8182', path));
  var curweek = CurrentWeek(Week.current());
  // var bcont = BlueprintController();
  Get.put<FAuth>(fauth);
  // Get.put<FStore>(fstore);
  // Get.put<MStore>(mstore);
  Get.put<FStorage>(store);
  Get.put<ProxyStore>(proxy);
  Get.put<CurrentWeek>(curweek);
  Get.put<CurrentDay>(CurrentDay(DateTime.now()));
  // Get.put<BlueprintController>(bcont);
  if (fauth.currentUser != null) {
    // await fstore.init(fauth.currentUser!.email!);
    // await mstore.init(fauth.currentUser!.email!);
    await proxy.init(fauth.currentUser!.email!);
    // await bcont.init();
    // await store.init(fstore.currentInstitution!.id);
    // await store.init(mstore.db);
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
        FlutterFireUILocalizations.delegate,
        FlutterFireUIRuLocalizationsDelegate(),
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
