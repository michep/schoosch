import 'package:flutter/material.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/student_homework.dart';

class HomeworksForStudentPage extends StatefulWidget {
  final LessonModel _lesson;
  final DateTime _date;
  final StudentModel _student;
  const HomeworksForStudentPage(this._lesson, this._date, this._student, {Key? key}) : super(key: key);

  @override
  State<HomeworksForStudentPage> createState() => _HomeworksForStudentPageState();
}

class _HomeworksForStudentPageState extends State<HomeworksForStudentPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, HomeworkModel?>?>(
      future: widget._lesson.homeworkThisLessonForClassAndStudent(widget._student, widget._date, forceRefresh: false),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }
        if (snapshot.data!['student'] == null && snapshot.data!['class'] == null) {
          return const Center(
            child: Text('Нет домашнего задания на этот день! 🎉'),
          );
        }
        var stud = snapshot.data!['student'];
        var clas = snapshot.data!['class'];
        return ListView(
          shrinkWrap: true,
          children: [
            if (stud != null)
              HomeworkCard(
                homework: stud,
                isClass: false,
                student: widget._student,
              ),
            if (clas != null)
              HomeworkCard(
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
