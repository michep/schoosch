import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/absence_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/admin/people_list.dart';

class StudentsAbsencePage extends StatefulWidget {
  final LessonModel _lesson;
  final DateTime _date;
  final bool readOnly;

  const StudentsAbsencePage(this._date, this._lesson, {Key? key, this.readOnly = false}) : super(key: key);

  @override
  State<StudentsAbsencePage> createState() => _StudentsAbsencePageState();
}

class _StudentsAbsencePageState extends State<StudentsAbsencePage> {
  bool forceRefresh = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder<List<AbsenceModel>>(
          future: widget._lesson.getAllAbsences(widget._date, forceRefresh: forceRefresh),
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
                      children: const [Center(child: Text('На этом уроке нет отсутствующих'))],
                    )
                  : ListView(
                      key: const PageStorageKey('absence'),
                      children: [
                        ...snapshot.data!
                            .map((absence) => AbsenceListTile(
                                  absence,
                                  deleteAbsence,
                                  widget.readOnly,
                                ))
                            .toList()
                      ],
                    ),
            );
          },
        ),
        Visibility(
          visible: !widget.readOnly,
          child: Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: addAbsence,
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> addAbsence() async {
    var stud = await Get.to(
      () => PeopleListPage(
        widget._lesson.aclass.students,
        selectionMode: true,
        type: 'student',
        title: S.of(context).classStudentsTitle,
      ),
      transition: Transition.rightToLeft,
    );
    if (stud is PersonModel) {
      var abs = AbsenceModel.fromMap(null, {
        'lesson_order': widget._lesson.order,
        'person_id': stud.id,
        'date': widget._date.toIso8601String(),
      });
      widget._lesson.createAbsence(abs).then((value) => setState(() {
        forceRefresh = true;
      }));
    }
  }

  Future<void> deleteAbsence(AbsenceModel absence) async {
    absence.delete(widget._lesson).then((value) => setState(() {
      forceRefresh = true;
    }));
  }
}

class AbsenceListTile extends StatelessWidget {
  final AbsenceModel absence;
  final Future<void> Function(AbsenceModel) deleteAbsenceFunc;
  final bool readOnly;

  const AbsenceListTile(this.absence, this.deleteAbsenceFunc, this.readOnly, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<StudentModel>(
      future: absence.student,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        return ListTile(
          title: Text(snapshot.data!.fullName),
          trailing: readOnly ? null : IconButton(icon: const Icon(Icons.delete), onPressed: () => deleteAbsenceFunc(absence)),
        );
      },
    );
  }
}
