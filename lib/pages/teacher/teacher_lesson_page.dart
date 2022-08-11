import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/completion_flag_model.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:schoosch/widgets/appbar.dart';
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

  Future<void> createClassHomework(
    BuildContext context,
    TeacherModel teacher,
    CurriculumModel curriculum,
    DateTime date,
    ClassModel aclass,
  ) async {
    return await showModalBottomSheet(
      context: context,
      builder: (a) {
        return AddHomeworkSheet(
          teacher: teacher,
          curriculum: curriculum,
          date: date,
          aclass: aclass,
          student: null,
          isEdit: false,
        );
      },
    );
  }

  Future<void> updateHomework(BuildContext context, HomeworkModel homework) async {
    return await showModalBottomSheet(
      context: context,
      builder: (a) {
        return AddHomeworkSheet(
          isEdit: true,
          homework: homework,
        );
      },
    );
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
                  return const SizedBox(
                    child: ExpansionTile(
                      title: Text(
                        "Ученики",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      children: [
                        // ...snapshot.data!.map(
                        //   (student) => TeacherStudentTile(_date, _lesson, _curiculum, _teacher, student),
                        // ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              const Align(
                alignment: Alignment.center,
                child: Text('ДЗ на следущий урок'),
              ),
              FutureBuilder<HomeworkModel?>(
                  future: _lesson.homeworkNextLessonForClass(_date),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox();
                    }
                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text('вы еще не задали дз.'),
                      );
                    }
                    return Card(
                      child: ListTile(
                        title: Text(snapshot.data!.text),
                        trailing: IconButton(
                          onPressed: () async {
                            updateHomework(context, snapshot.data!);
                          },
                          icon: const Icon(Icons.edit_outlined),
                        ),
                      ),
                    );
                  }),
              const SizedBox(
                height: 10,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('ДЗ на сегодня'),
                  FutureBuilder<Map<String, dynamic>>(
                    future: _lesson.homeworkThisLessonForClassAndAllStudents(_date),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Card(
                          elevation: 3,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 15.0),
                            child: Center(child: Text("нет домашнего задания")),
                          ),
                        );
                      }
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
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: FutureBuilder<HomeworkModel?>(
                  future: _lesson.homeworkNextLessonForClass(_date),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: Utils.progressIndicator());
                    }
                    return ElevatedButton.icon(
                      onPressed: !snapshot.hasData
                          ? () {
                              createClassHomework(context, _teacher, _curiculum, _date, _lesson.aclass);
                            }
                          : null,
                      icon: const Icon(Icons.calculate_outlined),
                      label: Text(snapshot.hasData ? "Вы уже задали задание." : "задать ДЗ классу"),
                    );
                  },
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
            Get.back();
          },
          label: Text(widget.completion.status == Status.confirmed ? 'отметить как не проверенное' : 'отметить как проверенное'),
          icon: Icon(widget.completion.status == Status.confirmed ? Icons.close : Icons.check),
        );
      });
}
