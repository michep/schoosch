import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/model/mark_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:schoosch/widgets/appbar.dart';

class StudentLessonPage extends StatelessWidget {
  final StudentModel _student;
  final DateTime _date;
  final LessonModel _lesson;
  final CurriculumModel _curiculum;
  final VenueModel _venue;
  final LessontimeModel _time;

  const StudentLessonPage(this._student, this._lesson, this._curiculum, this._venue, this._time, this._date, {Key? key}) : super(key: key);

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
          FutureBuilder<List<HomeworkModel>?>(
              future: _lesson.homeworkForStudentAndClass(_student, _date), //TODO: разделить на перс и общ задания
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Text('');
                }
                if (snapshot.data!.isEmpty) {
                  return Card(
                    elevation: 3,
                    child: Center(
                      child: Container(
                        child: const Text(
                          'нет домашнего задания на этот день!',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int i) {
                    return Card(
                      elevation: 3,
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Д/З",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(snapshot.data![i].text),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
          FutureBuilder<List<MarkModel>?>(
            future: _lesson.marksForStudent(_student, _date),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Text('');
              }
              if (snapshot.data!.isEmpty) {
                return Center(
                  child: Container(
                    child: const Text('нет оценок в этот день'),
                    margin: const EdgeInsets.symmetric(vertical: 10),
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
                          child: Text(
                            snapshot.data![i].mark.toString(),
                            style: const TextStyle(fontSize: 20),
                          ),
                          decoration:
                              BoxDecoration(border: Border.all(color: Colors.red, width: 1.5), borderRadius: BorderRadius.circular(4)),
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
    );
  }
}
