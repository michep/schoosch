import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:schoosch/views/class_selection.dart';

import 'data/firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FS.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'School Schedule Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ClassSelection(),
    );
  }
}
