import 'package:flutter/material.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/widgets/class_list_tile.dart';
import 'package:schoosch/widgets/utils.dart';

class ClassSelection extends StatelessWidget {
  final ObserverModel _observer;

  const ClassSelection(this._observer, {super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<List<ClassModel>>(
        future: _observer.classes(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Utils.progressIndicator();
          }
          return ListView(
            children: [
              ...snapshot.data!.map((element) => ClassListTile(element)),
            ],
          );
        },
      ),
    );
  }
}
