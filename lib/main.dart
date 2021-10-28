import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:schoosch/data/fireauth.dart';
import 'package:schoosch/data/data_model.dart';
import 'package:schoosch/views/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Get.putAsync<DataModel>(
    () async {
      var data = DataModel.empty();
      await data.init();
      return data;
    },
    permanent: true,
  );
  Get.put<FAuth>(
    FAuth(),
    permanent: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'School Schedule Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}
