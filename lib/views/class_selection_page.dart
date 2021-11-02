import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/data/class_model.dart';
import 'package:schoosch/data/fire_store.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/class_list_tile.dart';

class ClassSelection extends StatelessWidget {
  const ClassSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = Get.find<FStore>();
    return Scaffold(
      appBar: const MAppBar('Выбор класса'),
      body: SafeArea(
        child: FutureBuilder<List<ClassModel>>(
          future: data.getClassesModel(),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ListView(
                    children: [
                      ...snapshot.data!.map((doc) => ClassListTile(doc)),
                    ],
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  );
          },
        ),
      ),
    );
  }
}
