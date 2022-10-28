import 'package:flutter/material.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/student_homework.dart';

class StudentHomeworks extends StatefulWidget {
  final LessonModel _lesson;
  final DateTime _date;
  final StudentModel _student;
  const StudentHomeworks(this._lesson, this._date, this._student, {Key? key}) : super(key: key);

  @override
  State<StudentHomeworks> createState() => _StudentHomeworksState();
}

class _StudentHomeworksState extends State<StudentHomeworks> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, List<HomeworkModel>>>(
      future: widget._lesson.homeworkThisLessonForClassAndStudent(widget._student, widget._date, forceRefresh: false),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }
        if (snapshot.data!['student']!.isEmpty && snapshot.data!['class']!.isEmpty) {
          return const Center(
            child: Text('Нет домашнего задания на этот день! 🎉'),
          );
        }
        var stud = snapshot.data!['student'];
        var clas = snapshot.data!['class'];
        return ListView(
          shrinkWrap: true,
          children: [
            //TODO: now its list
            if (stud != null)
              StudentHomework(
                homework: stud,
                isClass: false,
                student: widget._student,
              ),
            //TODO: now its list too
            if (clas != null)
              StudentHomework(
                homework: clas,
                isClass: true,
                student: widget._student,
              ),
          ],
        );
      },
    );
  }
}
