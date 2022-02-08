import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/teacher_student_tile.dart';
import '../widgets/addstudentmarksheet.dart';
import '../widgets/addhomeworksheet.dart';

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
      body: Column(
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
            future: _lesson.aclass.students(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Text('');
              }
              if (snapshot.data!.isEmpty) {
                return const Text("нет учеников");
              }
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
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
          Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('YOUR D/Z'),
                FutureBuilder<HomeworkModel?>(
                  future: _lesson.homeworkForClass(_date),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Text("нет домашнего задания");
                    }
                    return Text(snapshot.data!.text);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                createClassHomework(
                    context, _teacher, _curiculum, _date, null);
              },
              icon: const Icon(Icons.calculate_outlined),
              label: const Text("add DZ"),
            ),
          ),
        ],
      ),
    );
  }
}
