import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/dayschedule_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/pages/admin/lesson_edit.dart';
import 'package:schoosch/pages/admin/schedule_lessonlist_tile.dart';
import 'package:schoosch/widgets/utils.dart';

class ScheduleLessonsListPage extends StatefulWidget {
  final ClassModel aclass;
  final DayScheduleModel schedule;
  final String title;

  const ScheduleLessonsListPage(this.aclass, this.schedule, this.title, {Key? key}) : super(key: key);

  @override
  State<ScheduleLessonsListPage> createState() => _VenuePageState();
}

class _VenuePageState extends State<ScheduleLessonsListPage> {
  final _formKey = GlobalKey<FormState>();

  final List<LessonModel> _lessons = [];
  final List<LessonModel> _lessonsRemoved = [];
  late DateTime? _from;
  late DateTime? _till;

  @override
  void initState() {
    _from = widget.schedule.from;
    _till = widget.schedule.till;
    widget.schedule.allLessons(forceRefresh: true).then((value) => setState(() => _lessons.addAll(value)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [IconButton(onPressed: newLesson, icon: const Icon(Icons.add))],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                DateTimeField(
                  initialValue: _from,
                  format: DateFormat('dd MMM yyyy', 'ru'),
                  onChanged: (DateTime? date) => _from = date,
                  decoration: const InputDecoration(
                    label: Text('Начало действия расписания'),
                  ),
                  validator: (value) => Utils.validateDateTimeNotEmpty(value, 'Дата начала действия должна быть выбрана'),
                  onShowPicker: (context, currentValue) async {
                    final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    return date;
                  },
                ),
                DateTimeField(
                  format: DateFormat('dd MMM yyyy', 'ru'),
                  initialValue: _till,
                  onChanged: (DateTime? date) => _till = date,
                  decoration: const InputDecoration(
                    label: Text('Окончание действия'),
                  ),
                  onShowPicker: (context, currentValue) async {
                    final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    return date;
                  },
                ),
                Expanded(
                  child: Scrollbar(
                    isAlwaysShown: true,
                    child: ReorderableListView(
                      buildDefaultDragHandles: false,
                      children: [
                        ..._lessons.map((e) => ScheduleLessonListTile(_lessons.indexOf(e), e, removeLesson, key: ValueKey(e))),
                      ],
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          var item = _lessons.removeAt(oldIndex);
                          _lessons.insert(newIndex, item);
                        });
                      },
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: ElevatedButton(
                          child: const Text('Сохранить изменения'),
                          onPressed: () => save(widget.schedule),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> newLesson() async {
    var nlesson = LessonModel.empty(widget.aclass, widget.schedule, _lessons.length + 1);
    var res = await Get.to<LessonModel>(() => LessonPage(nlesson, 'Урок'));
    if (res is LessonModel) {
      setState(() {
        _lessons.add(res);
      });
    }
  }

  void removeLesson(LessonModel lesson) {
    _lessonsRemoved.add(lesson);
    setState(() {
      _lessons.remove(lesson);
    });
  }

  Future<void> save(DayScheduleModel schedule) async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> map = {
        'day': schedule.day,
        'from': Timestamp.fromDate(_from!),
        'till': _till != null ? Timestamp.fromDate(_till!) : null,
      };
      var nschedule = DayScheduleModel.fromMap(widget.aclass, schedule.id, map);
      await nschedule.save();
      await saveLessons(nschedule);
      await deleteLessons();
      Get.back<DayScheduleModel>(result: nschedule);
    }
  }

  Future<void> saveLessons(DayScheduleModel schedule) async {
    for (var i = 0; i < _lessons.length; i++) {
      var less = _lessons[i];
      less.order = i + 1;
      var map = _lessons[i].toMap();
      var nless = LessonModel.fromMap(widget.aclass, schedule, less.id, map);
      await nless.save();
    }
  }

  Future<void> deleteLessons() async {
    for (var l in _lessonsRemoved) {
      await l.delete();
    }
  }

  Future<void> delete(StudentScheduleModel schedule) async {}
}
