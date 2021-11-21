import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:schoosch/controller/fire_auth_controller.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/controller/week_controller.dart';
import 'package:schoosch/pages/home_page.dart';
import 'package:schoosch/pages/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initializeDateFormatting();
  var fauth = FAuth();
  Get.put<FAuth>(
    fauth,
    permanent: true,
  );
  if (fauth.currentUser != null) {
    await Get.putAsync(
      () async {
        FStore store = FStore();
        await store.init(fauth.currentUser!.email!);
        return store;
      },
      permanent: true,
    ).then((value) {
      Get.put(
        CurrentWeek(Get.find<FStore>().getYearweekModelByDate(DateTime.now())),
      );
    });
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var auth = Get.find<FAuth>();
    return GetMaterialApp(
      title: 'School Schedule Application',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: auth.currentUser == null ? const LoginPage() : const HomePage(),
    );
  }
}
