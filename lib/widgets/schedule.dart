import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/week_controller.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/day_schedule_model.dart';
import 'package:schoosch/widgets/class_scedule_tile.dart';
import 'package:schoosch/controller/utils.dart';

class ScheduleWidget extends StatelessWidget {
  ScheduleWidget(this._class, {Key? key}) : super(key: key);

  final ClassModel _class;
  final cw = Get.find<CurrentWeek>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DayScheduleModel>>(
      future: _class.schedule,
      builder: (context, schedules) {
        if (!schedules.hasData) {
          return Utils.progressIndicator();
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              ...schedules.data!.map((schedule) => ClassScheduleTile(schedule)),
            ],
          ),
        );
      },
    );
  }
}
