import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isoweek/isoweek.dart';
import 'package:schoosch/controller/week_controller.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/dayschedule_model.dart';
import 'package:schoosch/widgets/observer/observer_day_tile.dart';
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
  final bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        WeekSelector(key: ValueKey(Get.find<CurrentWeek>().currentWeek.weekNumber)),
        Expanded(
          child: observerScheduleWidget(),
        ),
      ],
    );
  }

  Widget observerScheduleWidget() {
    return PageStorage(
      bucket: bucket,
      child: PageView.custom(
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
                  return Center(
                    child: Text(
                      S.of(context).noWeekSchedule,
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                }
                forceRefresh = false;
                return RefreshIndicator(
                  onRefresh: () async {
                    forceRefresh = true;
                    setState(() {});
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ...schedules.data!.map(
                          (schedule) => ObserverDayTile(
                            schedule,
                            Week(year: idx ~/ 100, weekNumber: idx % 100).day(schedule.day - 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
