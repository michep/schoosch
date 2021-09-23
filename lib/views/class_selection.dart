import 'package:flutter/material.dart';
import 'package:schoosch/data/class_model.dart';
import 'package:schoosch/widgets/class_list_tile.dart';
import 'package:schoosch/data/firestore.dart';

class ClassSelection extends StatelessWidget {
  const ClassSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Выбор класса'),
      ),
      body: SafeArea(
        child: StreamBuilder<List<ClassModel>>(
          stream: FS.instance.getClassesModel(),
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
