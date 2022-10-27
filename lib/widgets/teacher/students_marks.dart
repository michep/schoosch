import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/mark_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/teacher/mark_page.dart';

class StudentsMarksPage extends StatefulWidget {
  final LessonModel _lesson;
  final DateTime _date;
  final bool readOnly;

  const StudentsMarksPage(this._date, this._lesson, {Key? key, this.readOnly = false}) : super(key: key);

  @override
  State<StudentsMarksPage> createState() => _StudentsMarksPageState();
}

class _StudentsMarksPageState extends State<StudentsMarksPage> {
  bool forceRefresh = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder<Map<String, List<MarkModel>>>(
          future: widget._lesson.getAllMarks(widget._date, forceRefresh: forceRefresh),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox.shrink();
            forceRefresh = false;
            return RefreshIndicator(
              onRefresh: () async {
                forceRefresh = true;
                setState(() {});
              },
              child: snapshot.data!.isEmpty
                  ? ListView(
                      children: const [Center(child: Text('Вы еще не ставили оценок'))],
                    )
                  : ListView(
                      children: [
                        ...snapshot.data!.keys.map(
                          (e) => MarkListTile(
                            e,
                            widget._lesson,
                            widget._date,
                            snapshot.data![e]!,
                            deleteMark,
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
            child: FloatingActionButton(
              onPressed: addMark,
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> addMark() async {
    var res = await Get.to<bool>(
      () => MarkPage(
        widget._lesson,
        MarkModel.empty(
          PersonModel.currentUser!.id!,
          widget._lesson.curriculumId!,
          widget._lesson.order,
          widget._date,
        ),
        S.of(context).setMarkTitle,
      ),
    );
    if (res is bool) {
      setState(() {});
    }
  }

  void deleteMark(MarkModel mark) async {
    await mark.delete();
    setState(() {});
  }

  Future<void> editMark(MarkModel mark) async {
    var res = await Get.to<bool>(
      () => MarkPage(widget._lesson, mark, S.of(context).updateMarkTitle, editMode: true),
    );
    if (res is bool) {
      setState(() {});
    }
  }
}

class MarkListTile extends StatefulWidget {
  final String studentId;
  final LessonModel lesson;
  final DateTime date;
  final void Function(MarkModel) deleteFunc;
  final Future<void> Function(MarkModel) editFunc;
  final List<MarkModel> marks;
  final bool readOnly;

  const MarkListTile(this.studentId, this.lesson, this.date, this.marks, this.deleteFunc, this.editFunc, this.readOnly, {Key? key}) : super(key: key);

  @override
  State<MarkListTile> createState() => _MarkListTileState();
}

class _MarkListTileState extends State<MarkListTile> {
  StudentModel? student;

  @override
  void initState() {
    super.initState();
    InstitutionModel.currentInstitution.getPerson(widget.studentId).then((value) {
      if (mounted) {
        setState(() {
          student = value.asStudent;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (student == null) return const SizedBox.shrink();
    return ExpansionTile(
      title: Text(student!.fullName),
      subtitle: Text(marksString(widget.marks)),
      children: [
        ...widget.marks.map((e) => MarkTile(e, widget.deleteFunc, widget.editFunc, widget.readOnly, key: ValueKey(e.id))).toList(),
      ],
    );
  }

  String marksString(List<MarkModel?> marks) {
    List<String> ms = [];
    for (var m in marks) {
      ms.add(m!.toString());
    }
    return ms.join('; ');
  }
}

class MarkTile extends StatelessWidget {
  final MarkModel mark;
  final void Function(MarkModel) deleteFunc;
  final Future<void> Function(MarkModel) editFunc;
  final bool readOnly;

  const MarkTile(this.mark, this.deleteFunc, this.editFunc, this.readOnly, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        mark.comment,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      leading: Text(mark.toString()),
      subtitle: FutureBuilder<PersonModel>(
        future: mark.teacher,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox.shrink();
          return Text(snapshot.data!.fullName);
        },
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
