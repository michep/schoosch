import 'package:flutter/material.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/class_list_tile.dart';
import 'package:schoosch/widgets/utils.dart';

class ClassSelectionPage extends StatelessWidget {
  final InstitutionModel institution;

  const ClassSelectionPage(this.institution, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MAppBar('Выбор класса'),
      body: SafeArea(
        child: FutureBuilder<List<ClassModel>>(
          future: institution.classes,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Utils.progressIndicator();
            }
            return ListView(
              children: [
                ...snapshot.data!.map((doc) => ClassListTile(doc)),
              ],
            );
          },
        ),
      ),
    );
  }
}
