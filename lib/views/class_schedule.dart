import 'package:flutter/material.dart';
import 'package:schoosch/data/class_model.dart';
import 'package:schoosch/data/schedule_model.dart';
import 'package:schoosch/widgets/class_scedule_tile.dart';
import 'package:schoosch/data/firestore.dart';

class ClassSchedule extends StatelessWidget {
  final ClassModel _class;
  const ClassSchedule(this._class, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_class.name),
      ),
      body: SafeArea(
        child: StreamBuilder<List<ScheduleModel>>(
            stream: FS.instance.getClassSchedulesModel(_class.id),
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? ListView(
                      children: snapshot.data!.map((schedule) => ClassScheduleTile(_class.id, schedule)).toList(),
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    );
            }),
      ),
    );
  }
}
