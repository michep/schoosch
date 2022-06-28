import 'package:flutter/material.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/class_list_tile.dart';
import 'package:schoosch/widgets/utils.dart';

class ObserverClassSelectionPage extends StatelessWidget {
  final ObserverModel _observer;

  const ObserverClassSelectionPage(this._observer, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MAppBar(
        'Выбор класса',
        showProfile: true,
      ),
      body: SafeArea(
        child: FutureBuilder<List<ClassModel>>(
          future: _observer.classes(),
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
