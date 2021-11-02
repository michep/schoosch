import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:schoosch/data/fire_auth.dart';
import 'package:schoosch/data/fire_store.dart';
import 'package:schoosch/views/class_selection_page.dart';
import 'package:schoosch/views/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put<FAuth>(
    FAuth(),
    permanent: true,
  );
  var auth = Get.find<FAuth>();
  if (auth.currentUser != null) {
    await _authenticated();
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: auth.currentUser == null ? const LoginPage() : const ClassSelection(),
    );
  }
}

Future _authenticated() async {
  final auth = Get.find<FAuth>();
  await Get.putAsync<FStore>(() async {
    FStore store = FStore(auth.currentUser!.email!);
    await store.init();
    return store;
  });
}
