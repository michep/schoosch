import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:schoosch/data/datasource_interface.dart';
import 'package:schoosch/data/mongo.dart';
import 'package:schoosch/views/class_selection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await FS.instance.init();
  await Get.putAsync<SchooschDatasource>(
    () async {
      var fs = MDB();
      await fs.init();
      return fs;
    },
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
      home: const ClassSelection(),
    );
  }
}
