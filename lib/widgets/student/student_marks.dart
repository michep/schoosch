import 'package:flutter/material.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/mark_model.dart';
import 'package:schoosch/model/person_model.dart';

class StudentMarks extends StatefulWidget {
  final LessonModel _lesson;
  final DateTime _date;
  final StudentModel _student;
  const StudentMarks(this._lesson, this._date, this._student, {Key? key}) : super(key: key);

  @override
  State<StudentMarks> createState() => _StudentMarksState();
}

class _StudentMarksState extends State<StudentMarks> {
  late bool forceRefresh;

  @override
  void initState() {
    forceRefresh = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LessonMarkModel>?>(
      future: widget._lesson.lessonMarksForStudent(widget._student, widget._date, forceRefresh: forceRefresh),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        return RefreshIndicator(
          onRefresh: () async {
            setState(() {
              forceRefresh = true;
            });
          },
          child: snapshot.data!.isEmpty
              ? ListView(
                  children: const [
                    Center(
                      child: Text('Нет оценок'),
                    ),
                  ],
                )
              : ListView(
                  children: [
                    ...snapshot.data!.map(
                      (e) => ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.red,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            e.toString(),
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        title: Text(e.comment),
                        subtitle: FutureBuilder<PersonModel>(
                          future: e.teacher,
                          builder: ((context, snapshot) => snapshot.hasData ? Text(snapshot.data!.fullName) : const Text('')),
                        ),
                      ),
                    )
                  ],
                ),
        );
      },
    );
  }
}
