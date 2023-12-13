import 'dart:async';
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
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:schoosch/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  var fauth = FAuth();
  await fauth.init();
  var proxy = ProxyStore((path) => Uri.https('www.chepaykin.org:8182', path)); //real
  // var proxy = ProxyStore((path) => Uri.http('localhost:8182', path)); // local
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

  runApp(const SchooschApp());
}

class SchooschApp extends StatefulWidget {
  const SchooschApp({super.key});

  @override
  State<SchooschApp> createState() => _SchooschAppState();
}

class _SchooschAppState extends State<SchooschApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<FAuth>().startListen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: [
        ...AppLocalizations.localizationsDelegates,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FirebaseUILocalizations.delegate,
      ],
      locale: const Locale('ru'),
      scrollBehavior: AppScrollBehavior(),
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTiile,
      debugShowCheckedModeBanner: false,
      theme: darkTheme,
      home: const SizedBox.shrink(),
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
