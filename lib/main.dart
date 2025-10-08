import 'dart:async';
import 'package:schoosch/core/providers/base_dio_functions.dart';
import 'package:schoosch/features/navigation/navigation.dart';
import 'package:schoosch/old/generated/l10n.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:isoweek/isoweek.dart';
import 'package:schoosch/old/controller/day_controller.dart';
import 'package:schoosch/old/controller/auth_controller.dart';
import 'package:schoosch/old/controller/prefs_controller.dart';
import 'package:schoosch/old/controller/proxy_controller.dart';
import 'package:schoosch/old/controller/week_controller.dart';
import 'package:schoosch/core/firebase/firebase_options.dart';
import 'package:schoosch/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  BaseDioFunctions(isLocal: true);

  var fauth = FAuth();
  await fauth.init();

  // var store = DataStore((path) => Uri.https('www.chepaykin.org', '/schoosch/api$path')); // NEW REAL

  // var store = ProxyStore((path) => Uri.http('localhost:8182', '/schoosch/api$path')); // NEW LOCAL

  var proxy = ProxyStore((path) => Uri.https('www.chepaykin.org', '/schoosch/api$path')); //real

  // var proxy = ProxyStore((path) => Uri.http('localhost:8182', '/schoosch/api$path')); // local

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

  runApp(
    const SchooschApp(),
  );
}

class SchooschApp extends StatefulWidget {
  const SchooschApp({super.key});

  @override
  State<SchooschApp> createState() => _SchooschAppState();
}

class _SchooschAppState extends State<SchooschApp> {
  final navigation = Navigation();
  @override
  void initState() async {
    super.initState();
    await navigation.init();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<FAuth>().startListen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      supportedLocales: S.delegate.supportedLocales,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FirebaseUILocalizations.delegate,
      ],
      locale: const Locale('ru'),
      scrollBehavior: AppScrollBehavior(),
      onGenerateTitle: (context) => S.of(context).appTiile,
      debugShowCheckedModeBanner: false,
      theme: darkTheme,
      getPages: navigation.pages(),
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
