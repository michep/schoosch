import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/mark_model.dart';
import 'package:schoosch/model/person_model.dart';

import '../pages/admin/people_list.dart';

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
              children: [...snapshot.data!.keys.map((e) => MarkListTile(e, widget._lesson, widget._date))].toList(),
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
    var stud = await Get.to(() => PeopleListPage(widget._lesson.aclass.students, selectionMode: true, type: 'student'));
    if (stud is PersonModel) {
      var curr = await widget._lesson.curriculum;
      var mrk = MarkModel.fromMap(
        null,
        {
          'teacher_id': PersonModel.currentTeacher!.id,
          'student_id': stud.id,
          'date': Timestamp.fromDate(widget._date),
          'curriculum_id': curr!.id,
          'lesson_order': widget._lesson.order,
          'type': 'regular',
          'comment': 'comment1',
          'mark': 4,
        },
      );
      await mrk.save();
      setState(() {});
    }
  }

  Future<void> deleteMark() async {}
}

class MarkListTile extends StatefulWidget {
  final String studentId;
  final LessonModel lesson;
  final DateTime date;

  const MarkListTile(this.studentId, this.lesson, this.date, {Key? key}) : super(key: key);

  @override
  State<MarkListTile> createState() => _MarkListTileState();
}

class _MarkListTileState extends State<MarkListTile> {
  StudentModel? student;

  @override
  void initState() {
    super.initState();
    InstitutionModel.currentInstitution.getPerson(widget.studentId).then((value) {
      setState(() {
        student = value.asStudent;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (student == null) return const SizedBox.shrink();
    return FutureBuilder<String>(
      future: widget.lesson.marksForStudentAsString(student!, widget.date),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        return ListTile(
          title: Text(student!.fullName),
          trailing: Text(snapshot.data!),
        );
      },
    );
  }
}
