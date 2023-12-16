import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/mark_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/teacher/class_mark_page.dart';
import 'package:schoosch/pages/teacher/student_mark_page.dart';
import 'package:schoosch/widgets/delete_bottomscheet.dart';
import 'package:schoosch/widgets/delete_dialog.dart';
import 'package:schoosch/widgets/fab_menu.dart';

class StudentsMarksPage extends StatefulWidget {
  final LessonModel _lesson;
  final DateTime _date;
  final bool readOnly;

  const StudentsMarksPage(this._date, this._lesson, {super.key, this.readOnly = false});

  @override
  State<StudentsMarksPage> createState() => _StudentsMarksPageState();
}

class _StudentsMarksPageState extends State<StudentsMarksPage> {
  bool forceRefresh = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder<Map<String, List<LessonMarkModel>>>(
          future: widget._lesson.getAllLessonMarks(widget._date, forceRefresh: forceRefresh),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox.shrink();
            forceRefresh = false;
            return RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  forceRefresh = true;
                });
              },
              child: snapshot.data!.isEmpty
                  ? ListView(
                      children: const [
                        Center(child: Text('Вы еще не ставили оценок')),
                      ],
                    )
                  : ListView(
                      key: const PageStorageKey('marks'),
                      children: [
                        ...snapshot.data!.keys.map(
                          (e) => MarkListTile(
                            e,
                            widget._lesson,
                            widget._date,
                            snapshot.data![e]!,
                            deleteMarkWithSheet,
                            editMark,
                            widget.readOnly,
                            key: ValueKey(e),
                          ),
                        )
                      ].toList(),
                    ),
            );
          },
        ),
        Visibility(
          visible: !widget.readOnly,
          child: Align(
            alignment: Alignment.bottomRight,
            child: FABMenu(
              children: [
                FABmenuchild(
                  icon: Icons.groups_rounded,
                  onPressed: addClassMark,
                  title: 'Классу',
                ),
                FABmenuchild(
                  icon: Icons.person_rounded,
                  onPressed: addStudentMark,
                  title: 'Ученику',
                ),
              ],
              colorClosed: Get.theme.colorScheme.secondary,
              colorOpen: Get.theme.colorScheme.background,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> addStudentMark() async {
    var res = await Get.to<bool>(
      () => StudentMarkPage(
        widget._lesson,
        LessonMarkModel.empty(
          PersonModel.currentUser!.id!,
          widget._lesson.curriculumId!,
          widget._lesson.order,
          widget._date,
        ),
        AppLocalizations.of(context)!.setMarkTitle,
      ),
    );
    if (res is bool) {
      setState(() {
        forceRefresh = true;
      });
    }
  }

  Future<void> addClassMark() async {
    var res = await Get.to<bool>(
      () => ClassMarkPage(
        widget._lesson,
        'Оценки классу',
        widget._date,
        LessonMarkModel.empty(
          PersonModel.currentUser!.id!,
          widget._lesson.curriculumId!,
          widget._lesson.order,
          widget._date,
        ),
      ),
    );
    if (res is bool) {
      setState(() {
        forceRefresh = true;
      });
    }
  }

  void deleteMark(LessonMarkModel mark) async {
    var res = await Get.dialog<bool>(DeleteDialog(
      context: context,
      mark: mark,
    ));
    if (res is bool && res) {
      setState(() {
        forceRefresh = true;
      });
    }
  }

  void deleteMarkWithSheet(LessonMarkModel mark) async {
    var person = await mark.student;
    var res = await Get.bottomSheet<bool>(
      DeleteBottomSheet(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Оценку:'),
            Text(
              mark.mark.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                // fontSize: 18,
              ),
            ),
            const Text('Для:'),
            Text(
              person.fullName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                // fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
    if (res is bool && res) {
      mark.delete().whenComplete(
            () => setState(
              () {
                forceRefresh = true;
              },
            ),
          );
    }
  }

  Future<void> editMark(LessonMarkModel mark) async {
    var res = await Get.to<bool>(
      () => StudentMarkPage(widget._lesson, mark, AppLocalizations.of(context)!.updateMarkTitle, editMode: true),
    );
    if (res is bool) {
      setState(() {
        forceRefresh = true;
      });
    }
  }
}

class MarkListTile extends StatefulWidget {
  final String studentId;
  final LessonModel lesson;
  final DateTime date;
  final void Function(LessonMarkModel) deleteFunc;
  final Future<void> Function(LessonMarkModel) editFunc;
  final List<LessonMarkModel> marks;
  final bool readOnly;

  const MarkListTile(this.studentId, this.lesson, this.date, this.marks, this.deleteFunc, this.editFunc, this.readOnly, {super.key});

  @override
  State<MarkListTile> createState() => _MarkListTileState();
}

class _MarkListTileState extends State<MarkListTile> {
  StudentModel? student;

  @override
  void initState() {
    super.initState();
    if (widget.marks.isNotEmpty) {
      widget.marks[0].student.then((value) {
        if (mounted) {
          setState(() {
            student = value;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (student == null) return const SizedBox.shrink();
    return ExpansionTile(
      key: PageStorageKey(student!.id),
      title: Text(student!.fullName),
      subtitle: Text(marksString(widget.marks)),
      children: [
        ...widget.marks.map((e) => MarkTile(e, widget.deleteFunc, widget.editFunc, widget.readOnly, key: ValueKey(e.id))),
      ],
    );
  }

  String marksString(List<LessonMarkModel?> marks) {
    List<String> ms = [];
    for (var m in marks) {
      ms.add(m!.toString());
    }
    return ms.join('; ');
  }
}

class MarkTile extends StatelessWidget {
  final LessonMarkModel mark;
  final void Function(LessonMarkModel) deleteFunc;
  final Future<void> Function(LessonMarkModel) editFunc;
  final bool readOnly;

  const MarkTile(this.mark, this.deleteFunc, this.editFunc, this.readOnly, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        mark.comment != '' ? mark.comment : 'Комментария нет.',
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      leading: Text(mark.toString()),
      subtitle: Row(
        children: [
          if (mark.type != null)
            Chip(
              backgroundColor: Get.theme.colorScheme.primary,
              label: Text(
                mark.type.label,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          const SizedBox(
            width: 10,
          ),
          FutureBuilder<PersonModel>(
            future: mark.teacher,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox.shrink();
              return Text(snapshot.data!.fullName);
            },
          ),
        ],
      ),
      trailing: readOnly
          ? null
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => editFunc(mark),
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () => deleteFunc(mark),
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
    );
  }
}
