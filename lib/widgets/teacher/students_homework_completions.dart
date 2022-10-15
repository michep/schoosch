import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/completion_flag_model.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/teacher/homework_page.dart';
import 'package:schoosch/widgets/teacher/students_homework_completion_tile.dart';

class StudentsTasksWithCompetionsPage extends StatefulWidget {
  final DateTime _date;
  final CurriculumModel _curriculum;
  final TeacherModel? _teacher;
  final LessonModel _lesson;
  final Future<Map<String, List<HomeworkModel?>>> Function(DateTime, bool) _hwsFuture;

  final bool readOnly;

  const StudentsTasksWithCompetionsPage(this._teacher, this._curriculum, this._date, this._lesson, this._hwsFuture, {Key? key, this.readOnly = false})
      : super(key: key);

  @override
  State<StudentsTasksWithCompetionsPage> createState() => _StudentsTasksWithCompetionsPageState();
}

class _StudentsTasksWithCompetionsPageState extends State<StudentsTasksWithCompetionsPage> {
  @override
  Widget build(BuildContext context) {
    List<String> studentsIdsWithHW = [];
    Map<String, dynamic> hws = {};
    return FutureBuilder<Map<String, List<HomeworkModel?>>>(
      future: widget._hwsFuture(widget._date, true),
      builder: (context, snapHWs) {
        if (snapHWs.connectionState == ConnectionState.done) {
          hws.clear();
          hws.addAll(snapHWs.data!);
          hws.remove('class');
          hws.removeWhere((key, value) => value == null);
          studentsIdsWithHW = hws.keys.toList();
        }
        return Stack(
          children: [
            snapHWs.hasData
                ? ListView(
                    children: [
                      ...hws.values.map((e) {
                        return FutureBuilder<List<CompletionFlagModel>>(
                          future: e!.getAllCompletions(),
                          builder: (context, snapcompl) {
                            if (!snapcompl.hasData) return const SizedBox.shrink();
                            var compl = snapcompl.data!.isNotEmpty ? snapcompl.data![0] : null;
                            return StudentHomeworkCompetionTile(
                                e, widget._lesson, compl, (hws) => editStudentHomework(hws, studentsIdsWithHW), toggleHomeworkCompletion,
                                readOnly: widget.readOnly);
                          },
                        );
                      })
                    ],
                  )
                : const SizedBox.shrink(),
            Visibility(
              visible: !widget.readOnly,
              child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  onPressed: () => addStudentHomework(hws.keys.toList()),
                  child: const Icon(Icons.add),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  void addStudentHomework(List<String> studentIDs) async {
    var res = await Get.to<bool>(
      () => HomeworkPage(
        widget._lesson,
        HomeworkModel.fromMap(
          null,
          {
            'class_id': widget._lesson.aclass.id,
            'date': widget._date,
            'text': '',
            'teacher_id': widget._teacher!.id,
            'curriculum_id': widget._curriculum.id,
          },
        ),
        studentIDs,
        personalHomework: true,
      ),
    );
    if (res is bool && res == true) {
      setState(() {});
    }
  }

  void editStudentHomework(HomeworkModel hw, List<String> studentIDs) async {
    studentIDs.remove(hw.studentId!);
    var res = await Get.to(() => HomeworkPage(widget._lesson, hw, studentIDs, personalHomework: true));
    if (res is bool && res == true) {
      setState(() {});
    }
  }

  void toggleHomeworkCompletion(HomeworkModel hw, CompletionFlagModel completion) async {
    switch (completion.status) {
      case Status.completed:
        await completion.confirm(PersonModel.currentUser!);
        break;
      case Status.confirmed:
        await completion.unconfirm(PersonModel.currentUser!);
        break;
      default:
    }
    setState(() {});
  }
}
