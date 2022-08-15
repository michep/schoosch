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
          return const SizedBox.shrink();
        }
        // return ListView.builder(
        //   itemCount: snapshot.data!.length,
        //   itemBuilder: (BuildContext context, int i) {
        //     return Card(
        //       elevation: 3,
        //       child: ListTile(
        //         leading: Container(
        //           padding: const EdgeInsets.all(6),
        //           decoration: BoxDecoration(
        //             border: Border.all(
        //               color: Colors.red,
        //               width: 1.5,
        //             ),
        //             borderRadius: BorderRadius.circular(4),
        //           ),
        //           child: Text(
        //             snapshot.data![i].mark.toString(),
        //             style: const TextStyle(fontSize: 20),
        //           ),
        //         ),
        //         title: Text(snapshot.data![i].comment),
        //       ),
        //     );
        //   },
        // );
        return ListView(
          children: [
            ...snapshot.data!.map(
              (e) => Card(
                elevation: 3,
                child: ListTile(
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
                      e.mark.toString(),
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  title: Text(e.comment),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
