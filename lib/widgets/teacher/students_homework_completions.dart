import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/completion_flag_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/pages/teacher/homework_page.dart';
import 'package:schoosch/widgets/teacher/students_homework_completion_tile.dart';

class StudentsTasksWithCompetionsPage extends StatelessWidget {
  final DateTime _date;
  final LessonModel _lesson;
  final Future<Map<String, HomeworkModel?>> Function(DateTime) _hwsFuture;
  final bool readOnly;

  const StudentsTasksWithCompetionsPage(this._date, this._lesson, this._hwsFuture, {Key? key, this.readOnly = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder<Map<String, HomeworkModel?>>(
          future: _hwsFuture(_date),
          builder: (context, snapHWs) {
            if (!snapHWs.hasData) return const SizedBox.shrink();
            var hws = snapHWs.data!;
            hws.remove('class');
            hws.removeWhere((key, value) => value == null);
            return ListView(
              children: [
                ...hws.values.map((e) {
                  return FutureBuilder<List<CompletionFlagModel>>(
                    future: e!.getAllCompletions(),
                    builder: (context, snapcompl) {
                      if (!snapcompl.hasData) return const SizedBox.shrink();
                      var compl = snapcompl.data!.isNotEmpty ? snapcompl.data![0] : null;
                      return StudentHomeworkCompetionTile(e, compl);
                    },
                  );
                })
              ],
            );
          },
        ),
        Visibility(
          visible: !readOnly,
          child: Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: addStudentHomework,
              child: const Icon(Icons.add),
            ),
          ),
        )
      ],
    );
  }

  void addStudentHomework() {
    Get.to<bool>(
      () => HomeworkPage(
        _lesson,
        HomeworkModel.fromMap(
          null,
          {
            'class_id': _lesson.aclass.id,
            'date': Timestamp.fromDate(_date),
            'text': '',
          },
        ),
      ),
    );
  }

  void editStudentHomework(HomeworkModel hw) {
    Get.to(() => HomeworkPage(_lesson, hw));
  }
}
