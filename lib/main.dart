import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:isoweek/isoweek.dart';
import 'package:schoosch/controller/fire_auth_controller.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/controller/week_controller.dart';
import 'package:schoosch/firebase_options.dart';
import 'package:schoosch/pages/admin/admin_page.dart';
import 'package:schoosch/pages/home_page.dart';
import 'package:schoosch/pages/login_page.dart';

import 'model/person_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  var fauth = FAuth();
  var fstore = FStore();
  Get.put<FAuth>(fauth);
  Get.put<FStore>(fstore);
  Get.put(CurrentWeek(Week.current()));

  if (fauth.currentUser != null) {
    await fstore.init(fauth.currentUser!.email!);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      scrollBehavior: AppScrollBehavior(),
      title: 'School Schedule Application',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PersonModel.currentUser != null
          ? PersonModel.currentUser!.currentType == 'admin'
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
