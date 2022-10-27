import 'package:flutter/material.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/mark_model.dart';
import 'package:schoosch/model/person_model.dart';

class MarksForStudentPage extends StatefulWidget {
  final LessonModel _lesson;
  final DateTime _date;
  final StudentModel _student;
  const MarksForStudentPage(this._lesson, this._date, this._student, {Key? key}) : super(key: key);

  @override
  State<MarksForStudentPage> createState() => _MarksForStudentPageState();
}

class _MarksForStudentPageState extends State<MarksForStudentPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MarkModel>?>(
      future: widget._lesson.marksForStudent(widget._student, widget._date),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Text('');
        }
        if (snapshot.data!.isEmpty) {
          // return const SizedBox.shrink(child: Text('Нет оценок.'),);
          return const Center(
            child: Text('Нет оценок.'),
          );
        }
        return ListView(
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
        );
      },
    );
  }
}
