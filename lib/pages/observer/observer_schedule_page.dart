import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isoweek/isoweek.dart';
import 'package:schoosch/controller/week_controller.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/dayschedule_model.dart';
import 'package:schoosch/widgets/observer/observer_day_tile.dart';
// import 'package:schoosch/widgets/student/student_dayschedule_tile.dart';
import 'package:schoosch/widgets/utils.dart';
import 'package:schoosch/widgets/week_selector.dart';

class ObserverSchedule extends StatefulWidget {
  final ClassModel _class;
  const ObserverSchedule(this._class, {Key? key}) : super(key: key);

  @override
  State<ObserverSchedule> createState() => _ObserverScheduleState();
}

class _ObserverScheduleState extends State<ObserverSchedule> {
  final _cw = Get.find<CurrentWeek>();
  bool forceRefresh = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            WeekSelector(key: ValueKey(Get.find<CurrentWeek>().currentWeek.weekNumber)),
            Expanded(
              child: observerScheduleWidget(),
            ),
          ],
        ),
      ),
    );
  }

  Widget observerScheduleWidget() {
    return PageView.custom(
      controller: _cw.pageController,
      onPageChanged: _cw.setIdx,
      childrenDelegate: SliverChildBuilderDelegate(
        (context, idx) {
          return FutureBuilder<List<ClassScheduleModel>>(
            future: widget._class.getClassSchedulesWeek(Week(year: idx ~/ 100, weekNumber: idx % 100), forceRefresh: forceRefresh),
            builder: (context, schedules) {
              if (!schedules.hasData) {
                return Utils.progressIndicator();
              }
              if (schedules.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'нет расписания на эту неделю',
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }
              forceRefresh = false;
              return RefreshIndicator(
                onRefresh: () async {
                  forceRefresh = true;
                  setState(() {});
                },
                child: ListView(
                  children: [
                    ...schedules.data!.map(
                      (schedule) => ObserverDayTile(
                        schedule,
                        Week(year: idx ~/ 100, weekNumber: idx % 100).day(schedule.day - 1),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
