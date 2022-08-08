import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoosch/model/completion_flag_model.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/mark_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:schoosch/widgets/appbar.dart';

class StudentLessonPage extends StatefulWidget {
  final StudentModel _student;
  final DateTime _date;
  final LessonModel _lesson;
  final CurriculumModel _curiculum;
  final VenueModel _venue;
  final LessontimeModel _time;

  const StudentLessonPage(this._student, this._lesson, this._curiculum, this._venue, this._time, this._date, {Key? key}) : super(key: key);

  @override
  State<StudentLessonPage> createState() => _StudentLessonPageState();
}

class _StudentLessonPageState extends State<StudentLessonPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MAppBar("Урок"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(fullLessonInfo(context)),
            const SizedBox(
              height: 10,
            ),
            Text(
              '${widget._curiculum.aliasOrName} ${widget._lesson.type == LessonType.replacment ? '(замена)' : ''}',
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(DateFormat('d MMMM, EEEE', 'ru').format(widget._date).capitalizeFirst!),
            const SizedBox(
              height: 5,
            ),
            Text('${widget._lesson.order} урок'),
            const SizedBox(
              height: 5,
            ),
            Text(widget._time.formatPeriod()),
            const SizedBox(
              height: 5,
            ),
            Text(widget._venue.name),
            const SizedBox(
              height: 5,
            ),
            FutureBuilder<Map<String, HomeworkModel?>?>(
                future: widget._lesson.homeworkThisLessonForClassAndStudent(widget._student, widget._date, forceRefresh: false),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Text('');
                  }
                  if (snapshot.data!['student'] == null && snapshot.data!['class'] == null) {
                    return Card(
                      elevation: 3,
                      child: Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          child: const Text(
                            'нет домашнего задания на этот день!',
                            // style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
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
                }),
            FutureBuilder<List<MarkModel>?>(
              future: widget._lesson.marksForStudent(widget._student, widget._date),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Text('');
                }
                if (snapshot.data!.isEmpty) {
                  return Card(
                    elevation: 3,
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        child: const Text('нет оценок в этот день'),
                      ),
                    ),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int i) {
                      return Card(
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
                              snapshot.data![i].mark.toString(),
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          title: Text(snapshot.data![i].comment),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget homeworkCard({required HomeworkModel homework}) {
  //   bool checked = homework.usersChecked.contains(Get.find<FStore>().currentUser!.id);
  //   return Card(
  //     elevation: 3,
  //     child: Container(
  //       margin: const EdgeInsets.all(8),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           const Text(
  //             "Д/З",
  //             style: TextStyle(fontWeight: FontWeight.bold),
  //           ),
  //           ListTile(
  //             title: Text(homework.text),
  //             trailing: null,
  //             onTap: () async {
  //               homework.updateHomeworkCheck().whenComplete(() {
  //                 setState(() {});
  //               });
  //             },
  //             textColor: checked ? Colors.green : Colors.white,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

class HomeworkCard extends StatefulWidget {
  final HomeworkModel homework;
  final bool isClass;
  final StudentModel student;
  const HomeworkCard({Key? key, required this.homework, required this.isClass, required this.student}) : super(key: key);

  @override
  State<HomeworkCard> createState() => _HomeworkCardState();
}

class _HomeworkCardState extends State<HomeworkCard> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CompletionFlagModel?>(
      future: widget.homework.getCompletion(widget.student),
      builder: (context, snapshot) {
        bool isChecked = false;
        bool isConfirmed = false;
        if (snapshot.hasData) {
          if (snapshot.data!.status == Status.completed) {
            isChecked = true;
          } else if (snapshot.data!.status == Status.confirmed) {
            isConfirmed = true;
          }
        }
        return Card(
          elevation: 3,
          child: Container(
            margin: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isClass ? "Д/З класса" : "Д/З личное",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                ListTile(
                  title: Text(widget.homework.text),
                  trailing: isConfirmed ? const Icon(Icons.check) : null,
                  onTap: () async {
                    var completion = await widget.homework.getCompletion(widget.student);
                    onTap(completion).whenComplete(() {
                      setState(() {});
                    });
                  },
                  tileColor: isChecked
                      ? const Color.fromARGB(153, 76, 175, 79)
                      : isConfirmed
                          ? Colors.green
                          : null,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> onTap(CompletionFlagModel? c) => showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: ElevatedButton.icon(
            onPressed: () {
              c == null
                  ? widget.homework.createCompletion()
                  : c.status == Status.completed
                      ? widget.homework.uncompleteCompletion(c)
                      : widget.homework.completeCompletion(c);
              Navigator.pop(context);
            },
            label: Text(c == null
                ? 'сообщить о выполнении'
                : c.status == Status.completed
                    ? 'отметить как невыполненное'
                    : 'отметить как выполненное'),
            icon: Icon(c == null
                ? Icons.add
                : c.status == Status.completed
                    ? Icons.close
                    : Icons.check),
          ),
        );
      });
}
