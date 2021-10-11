import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/data/class_model.dart';
import 'package:schoosch/data/datasource_interface.dart';
import 'package:schoosch/data/schedule_model.dart';
import 'package:schoosch/widgets/class_scedule_tile.dart';
import 'package:schoosch/widgets/week_selector.dart';

class ClassSchedule extends StatelessWidget {
  final ClassModel _class;
  const ClassSchedule(this._class, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fs = Get.find<SchooschDatasource>();
    return Scaffold(
      appBar: AppBar(
        title: Text(_class.name),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const WeekSelector(),
            Expanded(
              child: FutureBuilder<List<ScheduleModel>>(
                  future: fs.getSchedulesWithLessonsModel(_class.id),
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? SingleChildScrollView(
                            child: Column(
                              children: [
                                ...snapshot.data!.map((schedule) => ClassScheduleTile(schedule)),
                              ],
                            ),
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
