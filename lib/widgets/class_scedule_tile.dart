import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:schoosch/data/schedule_model.dart';
import 'package:schoosch/data/weekday_model.dart';
import 'package:schoosch/widgets/lesson_list_tile.dart';
import 'package:schoosch/data/firestore.dart';

class ClassScheduleTile extends StatelessWidget {
  final ScheduleModel _scedule;

  const ClassScheduleTile(this._scedule, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      maintainState: true,
      title: StreamBuilder<WeekdaysModel>(
        stream: FS.instance.getWeekdayNameModel(_scedule.day),
        builder: (context, weekday) {
          return weekday.hasData
              ? Text(
                  weekday.data!.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              : Container();
        },
      ),
      children: [..._scedule.lessons.map((_les) => LessonListTile(_les))],
    );
  }
}
