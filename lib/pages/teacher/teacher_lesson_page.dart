import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoosch/model/completion_flag_model.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/teacher_student_tile.dart';
import 'package:schoosch/widgets/utils.dart';
import '../../widgets/addhomeworksheet.dart';

class TeacherLessonPage extends StatelessWidget {
  final DateTime _date;
  final LessonModel _lesson;
  final CurriculumModel _curiculum;
  final VenueModel _venue;
  final LessontimeModel _time;
  final TeacherModel _teacher;

  const TeacherLessonPage(this._lesson, this._curiculum, this._venue, this._time, this._date, this._teacher, {Key? key}) : super(key: key);

  // Future<void> activateBottomSheet(
  //     BuildContext context,
  //     StudentModel student,
  //     TeacherModel teacher,
  //     int lessonorder,
  //     CurriculumModel curriculum,
  //     DateTime date) async {
  //   return await showModalBottomSheet(
  //       context: context,
  //       builder: (a) {
  //         return AddMarkSheet(student, teacher, lessonorder, curriculum, date);
  //       });
  // }

  Future<void> createClassHomework(
    BuildContext context,
    TeacherModel teacher,
    CurriculumModel curriculum,
    DateTime date,
    StudentModel? student,
  ) async {
    return await showModalBottomSheet(
        context: context,
        builder: (a) {
          return AddHomeworkSheet(teacher, curriculum, date, student);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MAppBar("Урок"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(fullLessonInfo(context)),
              const SizedBox(
                height: 10,
              ),
              Text(
                _curiculum.aliasOrName,
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(DateFormat('d MMMM, EEEE', 'ru').format(_date).capitalizeFirst!),
              const SizedBox(
                height: 5,
              ),
              Text('${_lesson.order} урок'),
              const SizedBox(
                height: 5,
              ),
              Text(_time.formatPeriod()),
              const SizedBox(
                height: 5,
              ),
              Text(_venue.name),
              const SizedBox(
                height: 5,
              ),
              FutureBuilder<List<StudentModel>>(
                future: _lesson.aclass.students(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Text('');
                  }
                  if (snapshot.data!.isEmpty) {
                    return const Text("нет учеников");
                  }
                  return SizedBox(
                    child: ExpansionTile(
                      title: const Text(
                        "Ученики",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      children: [
                        ...snapshot.data!.map(
                          (student) => TeacherStudentTile(_date, _lesson, _curiculum, _teacher, student),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('заданное ДЗ:'),
                  FutureBuilder<Map<String, HomeworkModel?>>(
                    future: _lesson.homeworkForEveryone(_date),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Card(
                            elevation: 3,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 15.0),
                              child: Center(child: Text("нет домашнего задания")),
                            ));
                      }
                      // return List.generate(
                      //   snapshot.data!.length,
                      //   (index) => FutureBuilder<List<CompletionFlagModel>>(
                      //     future: cmpltn!.getAllCompletions(),
                      //     builder: (context, completionsnapshot) {
                      //       if (!completionsnapshot.hasData) {
                      //         return Center(
                      //           child: Utils.progressIndicator(),
                      //         );
                      //       }
                      //       if (completionsnapshot.data!.isEmpty) {
                      //         return ExpansionTile(
                      //           title: Text(cmpltn.text),
                      //           children: const [Text('нет активных выполнений')],
                      //         );
                      //       }
                      //       return ExpansionTile(
                      //         title: Text(cmpltn.text),
                      //         children: [
                      //           ...completionsnapshot.data!.map(
                      //             (e) => CompletionListTile(completion: e, homework: cmpltn),
                      //           ),
                      //         ],
                      //       );
                      //     },
                      //   ),
                      // );

                      return Column(
                        children: [
                          ...snapshot.data!.values.map(
                            (e) {
                              if (e != null) {
                                return FutureBuilder<List<CompletionFlagModel>>(
                                  future: e.getAllCompletions(),
                                  builder: (context, completionsnapshot) {
                                    if (!completionsnapshot.hasData) {
                                      return Center(
                                        child: Utils.progressIndicator(),
                                      );
                                    }
                                    if (completionsnapshot.data!.isEmpty) {
                                      return ExpansionTile(
                                        title: Text(e.text),
                                        children: const [Text('нет активных выполнений')],
                                      );
                                    }
                                    return ExpansionTile(
                                      title: Text(e.text),
                                      children: [
                                        ...completionsnapshot.data!.map(
                                          (c) => CompletionListTile(completion: c, homework: e),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                        ],
                      );

                      // return FutureBuilder<List<CompletionFlagModel>>(
                      //   future: snapshot.data!.getAllCompletions(),
                      //   builder: (context, completionsnapshot) {
                      //     if (!completionsnapshot.hasData) {
                      //       return Center(
                      //         child: Utils.progressIndicator(),
                      //       );
                      //     }
                      //     if (completionsnapshot.data!.isEmpty) {
                      //       return ExpansionTile(
                      //         title: Text(snapshot.data!.text),
                      //         children: const [Text('нет активных выполнений')],
                      //       );
                      //     }
                      //     return ExpansionTile(
                      //       title: Text(snapshot.data!.text),
                      //       children: [
                      //         ...completionsnapshot.data!.map(
                      //           (e) => CompletionListTile(completion: e, homework: snapshot.data!),
                      //         ),
                      //       ],
                      //     );
                      //   },
                      // );
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    createClassHomework(context, _teacher, _curiculum, _date, null);
                  },
                  icon: const Icon(Icons.calculate_outlined),
                  label: const Text("задать ДЗ классу"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CompletionListTile extends StatefulWidget {
  CompletionFlagModel completion;
  final HomeworkModel homework;
  CompletionListTile({Key? key, required this.completion, required this.homework}) : super(key: key);

  @override
  State<CompletionListTile> createState() => _CompletionListTileState();
}

class _CompletionListTileState extends State<CompletionListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: FutureBuilder<StudentModel>(
          future: widget.completion.student,
          builder: (context, usnapshot) {
            if (!usnapshot.hasData) {
              return const Text('нет информации');
            }
            return Text(usnapshot.data!.fullName);
          }),
      subtitle: Text(
        DateFormat('HH:mm, MMM dd').format(widget.completion.completedTime!),
      ),
      trailing: widget.completion.status! == Status.confirmed ? const Icon(Icons.check) : null,
      onTap: () {
        onTap().whenComplete(() {
          setState(() {});
        });
      },
      tileColor: widget.completion.status == Status.completed
          ? const Color.fromARGB(153, 76, 175, 79)
          : widget.completion.status == Status.confirmed
              ? Colors.green
              : null,
    );
  }

  Future<void> onTap() => showModalBottomSheet(
      context: context,
      builder: (context) {
        return ElevatedButton.icon(
          onPressed: () async {
            widget.completion.status == Status.confirmed
                ? widget.homework.unconfirmCompletion(widget.completion)
                : widget.homework.confirmCompletion(widget.completion);
            widget.completion = (await widget.completion.refresh(widget.homework))!;
            Navigator.pop(context);
          },
          label: Text(widget.completion.status == Status.confirmed ? 'отметить как не проверенное' : 'отметить как проверенное'),
          icon: Icon(widget.completion.status == Status.confirmed ? Icons.close : Icons.check),
        );
      });
}
