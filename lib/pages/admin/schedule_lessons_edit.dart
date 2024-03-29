import 'dart:math';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:drag_and_drop_lists/drag_and_drop_list_interface.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/dayschedule_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/pages/admin/lesson_edit.dart';
import 'package:schoosch/pages/admin/schedule_lessonlist_tile.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/utils.dart';

class ScheduleLessonsPage extends StatefulWidget {
  final ClassModel _aclass;
  final ClassScheduleModel _schedule;
  final String _title;

  const ScheduleLessonsPage(this._aclass, this._schedule, this._title, {super.key});

  @override
  State<ScheduleLessonsPage> createState() => _VenuePageState();
}

class _VenuePageState extends State<ScheduleLessonsPage> {
  final _formKey = GlobalKey<FormState>();

  final Map<int, List<LessonModel>> _lessons = {};
  final List<LessonModel> _lessonsRemoved = [];
  late DateTime? _from;
  late DateTime? _till;

  @override
  void initState() {
    _from = widget._schedule.from;
    _till = widget._schedule.till;
    widget._schedule.classLessons(forceRefresh: true).then(
          (lessons) => setState(
            () {
              if (lessons.isEmpty) return;
              for (var lesson in lessons) {
                if (_lessons[lesson.order] == null) _lessons[lesson.order] = [];
                _lessons[lesson.order]!.add(lesson);
              }
              var idMax = _lessons.keys.reduce(max);
              for (var i = 1; i < idMax; i++) {
                if (_lessons[i] == null) _lessons[i] = [];
              }
            },
          ),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var loc = S.of(context);
    return Scaffold(
      appBar: MAppBar(
        widget._title,
        actions: [
          IconButton(onPressed: _duplicateSchedule, icon: const Icon(Icons.copy_all)),
          IconButton(onPressed: _newLesson, icon: const Icon(Icons.add)),
        ],
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
                  format: DateFormat('dd MMM yyyy'),
                  onChanged: (DateTime? date) => _from = date,
                  decoration: InputDecoration(
                    label: Text(loc.scheduleFromDate),
                  ),
                  validator: (value) => Utils.validateDateTimeNotEmpty(value, loc.errorScheduleFromDateEmpty),
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
                  format: DateFormat('dd MMM yyyy'),
                  initialValue: _till,
                  onChanged: (DateTime? date) => _till = date,
                  decoration: InputDecoration(
                    label: Text(loc.scheduleTillDate),
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
                  child: DragAndDropLists(
                    axis: Axis.vertical,
                    itemDragHandle: const DragHandle(
                      onLeft: true,
                      child: Icon(Icons.drag_handle),
                    ),
                    onItemReorder: _itemsReorder,
                    onListReorder: (i, j) {},
                    children: _generateListItems(),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: ElevatedButton(
                          child: Text(loc.saveChanges),
                          onPressed: () => _save(widget._schedule),
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

  List<DragAndDropListInterface> _generateListItems() {
    List<DragAndDropList> res = [];
    var keys = _lessons.keys.toList();
    keys.sort((a, b) => a.compareTo(b));
    for (var order in keys) {
      List<DragAndDropItem> items = [];
      for (var lessonidx = 0; lessonidx < _lessons[order]!.length; lessonidx++) {
        var lesson = _lessons[order]![lessonidx];
        if (lesson.type != LessonType.empty) {
          items.add(
            DragAndDropItem(
              child: ScheduleLessonListTile(lesson, _removeLesson, (less) => _updateLesson(order, lessonidx, less), key: ValueKey(lesson)),
            ),
          );
        }
      }
      res.add(
        DragAndDropList(
          header: _title(order),
          canDrag: false,
          children: items,
          contentsWhenEmpty: _noLessons,
        ),
      );
    }
    res.add(
      DragAndDropList(
        header: _title(res.length + 1),
        canDrag: false,
        children: [],
        contentsWhenEmpty: _noLessons,
      ),
    );
    return res;
  }

  Widget _title(int order) {
    return Padding(
      padding: order == 1 ? const EdgeInsets.only(top: 16) : const EdgeInsets.only(top: 0),
      child: Text(S.of(context).scheduleLessonOrder(order)),
    );
  }

  Widget get _noLessons {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: ListTile(
        title: Text(S.of(context).scheduleNoLesson),
      ),
    );
  }

  void _itemsReorder(int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      var item = _lessons[oldListIndex + 1]!.removeAt(oldItemIndex);
      if (_lessons[newListIndex + 1] == null) _lessons[newListIndex + 1] = [];
      _lessons[newListIndex + 1]!.insert(newItemIndex, item);
      var idx = _lessons.keys.reduce(max);
      while (_lessons[idx] != null && _lessons[idx]!.isEmpty) {
        _lessons.remove(idx);
        idx--;
      }
    });
  }

  Future<void> _duplicateSchedule() async {
    await _save(widget._schedule, duplicate: true);
  }

  Future<void> _newLesson() async {
    var nlesson = LessonModel.empty(widget._aclass, widget._schedule, _lessons.length + 1);
    var res = await Get.to<LessonModel>(() => LessonPage(nlesson, S.of(context).lesson));
    if (res is LessonModel) {
      setState(() {
        _lessons[_lessons.length + 1] = [];
        _lessons[_lessons.length]!.add(res);
      });
    }
  }

  void _updateLesson(int order, int lessonidx, LessonModel lesson) {
    setState(() {
      _lessons[order]![lessonidx] = lesson;
    });
  }

  void _removeLesson(LessonModel lesson) {
    _lessonsRemoved.add(lesson);
    setState(() {
      _lessons[lesson.order]!.remove(lesson);
      var idx = _lessons.keys.reduce(max);
      while (_lessons[idx] != null && _lessons[idx]!.isEmpty) {
        _lessons.remove(idx);
        idx--;
      }
    });
  }

  Future<void> _save(ClassScheduleModel schedule, {bool duplicate = false}) async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> map = {
        'day': schedule.day,
        'from': _from!.toIso8601String(),
        'till': _till?.toIso8601String(),
      };
      var nschedule = ClassScheduleModel.fromMap(widget._aclass, duplicate ? null : schedule.id, map);
      await nschedule.save();
      await _saveLessons(nschedule, duplicate: duplicate);
      await _deleteLessons();
      Get.back<ClassScheduleModel>(result: nschedule);
    }
  }

  Future<void> _saveLessons(ClassScheduleModel schedule, {bool duplicate = false}) async {
    for (var i = 0; i < _lessons.length; i++) {
      var lesss = _lessons[i + 1]!;
      for (var less in lesss) {
        less.order = i + 1;
        var map = less.toMap(withId: true);
        var nless = LessonModel.fromMap(widget._aclass, schedule, duplicate ? null : less.id, map);
        await nless.save();
      }
    }
  }

  Future<void> _deleteLessons() async {
    for (var l in _lessonsRemoved) {
      await l.delete();
    }
  }
}
