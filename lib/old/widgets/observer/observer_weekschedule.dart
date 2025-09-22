import 'package:flutter/material.dart';
import 'package:isoweek/isoweek.dart';
import 'package:schoosch/old/generated/l10n.dart';
import 'package:schoosch/old/model/class_model.dart';
import 'package:schoosch/old/model/dayschedule_model.dart';
import 'package:schoosch/old/widgets/observer/observer_dayschedule_tile.dart';
import 'package:schoosch/old/widgets/utils.dart';

class ObserverScheduleWidget extends StatefulWidget {
  final ClassModel _class;
  final Week _week;
  const ObserverScheduleWidget(this._class, this._week, {super.key});

  @override
  State<ObserverScheduleWidget> createState() => _ObserverScheduleWidgetState();
}

class _ObserverScheduleWidgetState extends State<ObserverScheduleWidget> {
  bool forceRefresh = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ClassScheduleModel>>(
      future: widget._class.getClassSchedulesWeek(widget._week, forceRefresh: forceRefresh),
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
            setState(() {
              forceRefresh = true;
            });
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              ...schedules.data!.map(
                (schedule) => ObserverDayScheduleTile(
                  schedule,
                  widget._week.day(schedule.day - 1),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
