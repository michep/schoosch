import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoosch/controller/week_controller.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:schoosch/widgets/appbar.dart';
import '../widgets/addstudentmarksheet.dart';
import '../widgets/addhomeworksheet.dart';

class TeacherLessonPage extends StatelessWidget {
  final DateTime _date;
  final LessonModel _lesson;
  final CurriculumModel _curiculum;
  final VenueModel _venue;
  final LessontimeModel _time;
  final PersonModel _teacher;

  const TeacherLessonPage(
      this._lesson, this._curiculum, this._venue, this._time, this._date, this._teacher,
      {Key? key})
      : super(key: key);

  Future<void> activateBottomSheet(BuildContext context, StudentModel student, TeacherModel teacher, int lessonorder, CurriculumModel curriculum, DateTime date) async {
    return await showModalBottomSheet(context: context, builder: (a) {
      return AddMarkSheet(student, teacher, lessonorder, curriculum, date);
    });
  }

  Future<void> activateBottomSheet2(BuildContext context, TeacherModel teacher, CurriculumModel curriculum, DateTime date, StudentModel? student,) async {
    return await showModalBottomSheet(context: context, builder: (a) {
      return AddHomeworkSheet(teacher, curriculum, date, student);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MAppBar("Урок"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(fullLessonInfo(context)),
          const SizedBox(
            height: 10,
          ),
          Text(
            _curiculum.name,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(DateFormat('d MMMM, EEEE', 'ru').format(_date).capitalizeFirst!),
          const SizedBox(
            height: 5,
          ),
          Text(_lesson.order.toString() + ' урок'),
          const SizedBox(
            height: 5,
          ),
          Text(_time.format(context)),
          const SizedBox(
            height: 5,
          ),
          Text(_venue.name),
          const SizedBox(
            height: 5,
          ),
          FutureBuilder<List<StudentModel>>(
            future: _lesson.aclass.students,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Text('');
              }
              if (snapshot.data!.isEmpty) {
                return Text("нет учеников");
              }
              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ExpansionTile(
                      title: Text(
                        "УЧЕНИКИ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.grey[700],
                        ),
                      ),
                      children: [
                        ...snapshot.data!.map(
                          (e) => Card(
                            elevation: 0.5,
                            child: ListTile(
                              title: Text(
                                e.fullName,
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      activateBottomSheet2(context, _teacher.asTeacher!, _curiculum, _date, e);
                                    },
                                    icon: Icon(Icons.checklist_rounded),
                                    iconSize: 25,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      activateBottomSheet(context, e, _teacher.asTeacher!, _lesson.order, _curiculum, _date);
                                    },
                                    iconSize: 25,
                                    icon: Icon(Icons.auto_stories_outlined),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
              // return ListView.builder(
              //   itemCount: snapshot.data!.length,
              //   itemBuilder: (context, i) {
              //     return Card(
              //       child: ListTile(
              //         title: Text(
              //           snapshot.data![i].fullName,
              //           style: TextStyle(
              //             fontWeight: FontWeight.bold,
              //             fontSize: 20,
              //             color: Colors.grey[700],
              //           ),
              //         ),
              //         trailing: Row(
              //           mainAxisSize: MainAxisSize.min,
              //           children: [
              //             IconButton(
              //               onPressed: () {},
              //               icon: Icon(Icons.checklist_rounded),
              //               iconSize: 25,
              //             ),
              //             IconButton(
              //               onPressed: () {},
              //               iconSize: 25,
              //               icon: Icon(Icons.auto_stories_outlined),
              //             )
              //           ],
              //         ),
              //       ),
              //     );
              //   },
              // );
            },
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                activateBottomSheet2(context, _teacher.asTeacher!, _curiculum, _date, null);
              },
              icon: Icon(Icons.calculate_outlined),
              label: Text("add DZ"),
            ),
          ),
        ],
      ),
    );
  }

  String fullLessonInfo(BuildContext context) {
    return DateFormat('d MMMM, EEEE', 'ru').format(_date).capitalizeFirst! +
        ', ' +
        _lesson.order.toString() +
        ' урок, ' +
        _time.format(context);
  }
}
