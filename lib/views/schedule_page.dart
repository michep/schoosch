import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/week_controller.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/day_schedule_model.dart';
import 'package:schoosch/widgets/class_scedule_tile.dart';
import 'package:schoosch/widgets/utils.dart';
import 'package:schoosch/widgets/week_selector.dart';

class SchedulePage extends StatelessWidget {
  final ClassModel _class;

  const SchedulePage(this._class, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const WeekSelector(),
          Expanded(
            child: FutureBuilder<List<DayScheduleModel>>(
              future: _class.schedule,
              builder: (context, schedules) {
                if (!schedules.hasData) {
                  return Utils.progressIndicator();
                }
                return SingleChildScrollView(
                  child: GetBuilder<CurrentWeek>(
                    builder: (controller) {
                      return Column(
                        children: [
                          ...schedules.data!.map((schedule) => ClassScheduleTile(schedule)),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
