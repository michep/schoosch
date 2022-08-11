import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/absence_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/admin/people_list.dart';

class StudentsAbsencePage extends StatefulWidget {
  final LessonModel _lesson;
  final DateTime _date;

  const StudentsAbsencePage(this._date, this._lesson, {Key? key}) : super(key: key);

  @override
  State<StudentsAbsencePage> createState() => _StudentsAbsencePageState();
}

class _StudentsAbsencePageState extends State<StudentsAbsencePage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder<List<AbsenceModel>>(
          future: widget._lesson.getAllAbsences(widget._date),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox.shrink();
            return ListView(
              children: [...snapshot.data!.map((absence) => AbsenceListTile(absence, deleteAbsence)).toList()],
            );
          },
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            onPressed: addAbsence,
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  Future<void> addAbsence() async {
    var stud = await Get.to(() => PeopleListPage(widget._lesson.aclass.students, selectionMode: true, type: 'student'));
    if (stud is PersonModel) {
      var abs = AbsenceModel.fromMap(null, {'lesson_order': widget._lesson.order, 'person_id': stud.id, 'date': Timestamp.fromDate(widget._date)});
      widget._lesson.createAbsence(abs).then((value) => setState(() {}));
    }
  }

  Future<void> deleteAbsence(AbsenceModel absence) async {
    absence.delete(widget._lesson).then((value) => setState(() {}));
  }
}

class AbsenceListTile extends StatelessWidget {
  final AbsenceModel absence;
  final Future<void> Function(AbsenceModel) deleteAbsenceFunc;

  const AbsenceListTile(this.absence, this.deleteAbsenceFunc, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<StudentModel>(
      future: absence.student,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        return ListTile(
          title: Text(snapshot.data!.fullName),
          trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () => deleteAbsenceFunc(absence)),
        );
      },
    );
  }
}
