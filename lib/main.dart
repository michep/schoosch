import 'dart:async';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:isoweek/isoweek.dart';
import 'package:schoosch/controller/socket_controller.dart';
import 'package:schoosch/controller/day_controller.dart';
import 'package:schoosch/controller/auth_controller.dart';
import 'package:schoosch/controller/prefs_controller.dart';
import 'package:schoosch/controller/proxy_controller.dart';
import 'package:schoosch/controller/week_controller.dart';
import 'package:schoosch/firebase_options.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  var fauth = FAuth();
  await fauth.init();
  Get.put<FAuth>(fauth);
  // var proxy = ProxyStore((path) => Uri.https('www.chepaykin.org:8182', path));

  // var proxy = ProxyStore((path) => Uri.https('localhost:8182', path));
  // var chat = ChatController((path) => Uri(scheme: 'wss', host: 'localhost', port: 8182, path: path));

  var proxy = ProxyStore((path) => Uri.http('10.0.2.2:8182', path));
  Get.put<ProxyStore>(proxy);

  var curweek = CurrentWeek(Week.current());
  Get.put<CurrentWeek>(curweek);

  var prefs = PrefsController();
  await prefs.init();
  Get.put<PrefsController>(prefs);

  // var bcont = BlueprintController();

  Get.put<CurrentDay>(CurrentDay(DateTime.now()));
  // Get.put<BlueprintController>(bcont);

  var chat = SocketController((path) => Uri(scheme: 'ws', host: '10.0.2.2', port: 8182, path: path));
  Get.put<SocketController>(chat);

  if (fauth.currentUser != null) {
    await proxy.init(fauth.currentUser!.email!);
    // await bcont.init();
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
        FirebaseUILocalizations.delegate,
      ],
      locale: const Locale('ru'),
      scrollBehavior: AppScrollBehavior(),
      onGenerateTitle: (context) => S.of(context).appTiile,
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
