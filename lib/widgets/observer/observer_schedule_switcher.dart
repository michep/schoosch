import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isoweek/isoweek.dart';
import 'package:schoosch/controller/week_controller.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/widgets/observer/observer_weekschedule.dart';
import 'package:schoosch/widgets/week_selector.dart';

class ObserverSchedule extends StatefulWidget {
  final ClassModel _class;

  const ObserverSchedule(this._class, {Key? key}) : super(key: key);

  @override
  State<ObserverSchedule> createState() => _ObserverScheduleState();
}

class _ObserverScheduleState extends State<ObserverSchedule> {
  final _cw = Get.find<CurrentWeek>();
  final bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        WeekSelector(key: ValueKey(Get.find<CurrentWeek>().currentWeek.weekNumber)),
        Expanded(
          child: PageStorage(
            bucket: bucket,
            child: PageView.custom(
              controller: _cw.pageController,
              onPageChanged: _cw.setIdx,
              childrenDelegate: SliverChildBuilderDelegate(
                (context, idx) {
                  return ObserverScheduleWidget(
                    widget._class,
                    Week(year: idx ~/ 100, weekNumber: idx % 100),
                    key: ValueKey(idx),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
