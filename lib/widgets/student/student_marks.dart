import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/mark_model.dart';
import 'package:schoosch/model/person_model.dart';

class StudentMarks extends StatefulWidget {
  final LessonModel _lesson;
  final DateTime _date;
  final StudentModel _student;
  const StudentMarks(this._lesson, this._date, this._student, {super.key});

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
                              color: getBorderColor(e.toString()),
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            e.toString(),
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        title: Text(
                          e.comment != '' ? e.comment : 'Комментария нет.',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        // subtitle: FutureBuilder<PersonModel>(
                        //   future: e.teacher,
                        //   builder: ((context, snapshot) => snapshot.hasData ? Text(snapshot.data!.fullName) : const Text('')),
                        // ),
                        subtitle: Row(
                          children: [
                            if (e.type != null)
                              Tooltip(
                                message: e.type.name,
                                child: Chip(
                                  backgroundColor: Get.theme.colorScheme.primary,
                                  label: Text(
                                    e.type.label,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                            const SizedBox(
                              width: 10,
                            ),
                            FutureBuilder<PersonModel>(
                              future: e.teacher,
                              builder: ((context, snapshot) => snapshot.hasData ? Text(snapshot.data!.fullName) : const Text('')),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
        );
      },
    );
  }

  Color getBorderColor(String firstMark) {
    switch (firstMark) {
      case '5':
        return Colors.green;
      case '4':
        return Colors.lime;
      case '3':
        return Colors.yellow;
      case '2':
        return Colors.red;
      case '1':
        return Colors.red;
      default:
        return Colors.red;
    }
  }
}
