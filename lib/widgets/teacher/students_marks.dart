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

  const StudentsMarksPage(this._date, this._lesson, {Key? key}) : super(key: key);

  @override
  State<StudentsMarksPage> createState() => _StudentsMarksPageState();
}

class _StudentsMarksPageState extends State<StudentsMarksPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder<Map<String, List<MarkModel>>>(
          future: widget._lesson.getAllMarks(widget._date),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox.shrink();
            return ListView(
              children: [
                ...snapshot.data!.keys.map(
                  (e) => MarkListTile(
                    e,
                    widget._lesson,
                    widget._date,
                    deleteMark,
                    editMark,
                    key: ValueKey(e),
                  ),
                )
              ].toList(),
            );
          },
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            onPressed: addMark,
            child: const Icon(Icons.add),
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

  void deleteMark(MarkModel mark) {
    mark.delete().then((value) => setState(() {}));
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

  const MarkListTile(this.studentId, this.lesson, this.date, this.deleteFunc, this.editFunc, {Key? key}) : super(key: key);

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
    return FutureBuilder<List<MarkModel>>(
      future: widget.lesson.marksForStudent(student!, widget.date, forceUpdate: true),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        return ExpansionTile(
          title: Text(student!.fullName),
          subtitle: Text(marksString(snapshot.data!)),
          children: [
            ...snapshot.data!.map((e) => MarkTile(e, widget.deleteFunc, widget.editFunc, key: ValueKey(e.id))).toList(),
          ],
        );
      },
    );
  }

  String marksString(List<MarkModel?> marks) {
    List<String> ms = [];
    for (var m in marks) {
      ms.add(m!.mark.toString());
    }
    return ms.join('; ');
  }
}

class MarkTile extends StatelessWidget {
  final MarkModel mark;
  final void Function(MarkModel) deleteFunc;
  final Future<void> Function(MarkModel) editFunc;

  const MarkTile(this.mark, this.deleteFunc, this.editFunc, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(mark.comment),
      leading: Text(mark.mark.toString()),
      subtitle: FutureBuilder<PersonModel>(
        future: mark.teacher,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox.shrink();
          return Text(snapshot.data!.fullName);
        },
      ),
      trailing: Row(
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
