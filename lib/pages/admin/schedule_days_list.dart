import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/dayschedule_model.dart';
import 'package:schoosch/pages/admin/schedule_lessons_list.dart';
import 'package:schoosch/widgets/utils.dart';

class ScheduleDaysListPage extends StatefulWidget {
  final ClassModel aclass;

  const ScheduleDaysListPage(this.aclass, {Key? key}) : super(key: key);

  @override
  State<ScheduleDaysListPage> createState() => _VenueListPageState();
}

class _VenueListPageState extends State<ScheduleDaysListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.aclass.name}, расписание'),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: 7,
          itemBuilder: (BuildContext context, int day) {
            return FutureBuilder<List<StudentScheduleModel>>(
              future: widget.aclass.getSchedulesDay(day + 1, forceRefresh: true),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox.shrink();
                return ExpansionTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(Utils.dayName(day)),
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => newSchedule(day),
                  ),
                  children: [
                    ...snapshot.data!.map(
                      (schedule) => ListTile(
                        title: Text(schedule.formatPeriod),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => onTap(schedule),
                      ),
                    ),
                    // ElevatedButton(onPressed: () {}, child: const Text('Добавить')),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> onTap(StudentScheduleModel schedule) async {
    var res = await Get.to<DayScheduleModel>(
        () => ScheduleLessonsListPage(widget.aclass, schedule, '${schedule.aclass.name}, ${Utils.dayName(schedule.day - 1)}'),
        transition: Transition.rightToLeft);
    if (res is DayScheduleModel) {
      setState(() {});
    }
  }

  Future<void> newSchedule(int day) async {
    var nschedule = DayScheduleModel.empty(widget.aclass, day);
    nschedule.day = day;
    var res = await Get.to<DayScheduleModel>(
        () => ScheduleLessonsListPage(widget.aclass, nschedule, '${nschedule.aclass.name}, ${Utils.dayName(day)}'));
    if (res is DayScheduleModel) {
      setState(() {});
    }
  }
}
