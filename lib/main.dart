import 'dart:async';
import 'package:schoosch/generated/l10n.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:isoweek/isoweek.dart';
import 'package:schoosch/controller/day_controller.dart';
import 'package:schoosch/controller/prefs_controller.dart';
import 'package:schoosch/controller/proxy_controller.dart';
import 'package:schoosch/controller/week_controller.dart';
import 'package:schoosch/pages/loader_page.dart';
import 'package:schoosch/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // var proxy = ProxyStore((path) => Uri.https('www.chepaykin.org', '/schoosch/api$path')); //real
  var proxy = ProxyStore((path) => Uri.http('localhost:8182', '/schoosch/api$path')); // local
  // var proxy = ProxyStore((path) => Uri.http('10.0.2.2:8182', '/schoosch/api$path')); // local emulator
  var curweek = CurrentWeek(Week.current());
  var prefs = PrefsController();
  await prefs.init();

  Get.put<PrefsController>(prefs);
  Get.put<ProxyStore>(proxy);
  Get.put<CurrentWeek>(curweek);
  Get.put<CurrentDay>(CurrentDay(DateTime.now()));

  runApp(const SchooschApp());
}

class SchooschApp extends StatefulWidget {
  const SchooschApp({super.key});

  @override
  State<SchooschApp> createState() => _SchooschAppState();
}

class _SchooschAppState extends State<SchooschApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      supportedLocales: S.delegate.supportedLocales,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: const Locale('ru'),
      scrollBehavior: AppScrollBehavior(),
      onGenerateTitle: (context) => S.of(context).appTiile,
      debugShowCheckedModeBanner: false,
      theme: darkTheme,
      home: const LoaderPage(),
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
