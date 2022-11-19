import 'package:flutter/material.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/widgets/student/student_homework_tile.dart';

class StudentHomeworks extends StatefulWidget {
  final LessonModel _lesson;
  final DateTime _date;
  final StudentModel _student;
  const StudentHomeworks(this._lesson, this._date, this._student, {Key? key}) : super(key: key);

  @override
  State<StudentHomeworks> createState() => _StudentHomeworksState();
}

class _StudentHomeworksState extends State<StudentHomeworks> {
  late bool forceRefresh;

  @override
  void initState() {
    forceRefresh = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, List<HomeworkModel>>>(
      future: widget._lesson.homeworkThisLessonForClassAndStudent(widget._student, widget._date, forceRefresh: forceRefresh),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        var stud = snapshot.data!['student']!;
        var clas = snapshot.data!['class']!;
        forceRefresh = false;
        return RefreshIndicator(
          onRefresh: () async {
            setState(() {
              forceRefresh = true;
            });
          },
          child: (stud.isEmpty && clas.isEmpty)
              ? ListView(
                children: const [
                  Center(child: Text('Нет домашнего задания на этот день! 🎉')),
                ],
              )
              : ListView(
                  children: [
                    if (stud.isNotEmpty)
                      StudentHomeworkTile(
                        homework: stud,
                        isClass: false,
                        student: widget._student,
                        refresh: refresh,
                      ),
                    if (clas.isNotEmpty)
                      StudentHomeworkTile(
                        homework: clas,
                        isClass: true,
                        student: widget._student,
                        refresh: refresh,
                      ),
                  ],
                ),
        );
      },
    );
  }

  void refresh() {
    setState(() {
      forceRefresh = true;
    });
  }
}
