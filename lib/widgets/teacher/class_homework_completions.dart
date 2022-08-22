import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/completion_flag_model.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/teacher/homework_page.dart';
import 'package:schoosch/widgets/teacher/class_homework_completion_tile.dart';
import 'package:schoosch/widgets/utils.dart';

class ClassTaskWithCompetionsPage extends StatefulWidget {
  final DateTime _date;
  final LessonModel _lesson;
  final CurriculumModel _curriculum;
  final TeacherModel _teacher;
  final Future<HomeworkModel?> Function(DateTime, bool) _hwFuture;
  final bool readOnly;

  const ClassTaskWithCompetionsPage(this._teacher, this._curriculum, this._date, this._lesson, this._hwFuture, {Key? key, this.readOnly = false})
      : super(key: key);

  @override
  State<ClassTaskWithCompetionsPage> createState() => _ClassTaskWithCompetionsPageState();
}

class _ClassTaskWithCompetionsPageState extends State<ClassTaskWithCompetionsPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder<HomeworkModel?>(
          future: widget._hwFuture(widget._date, true),
          builder: (context, snapHW) {
            if (!snapHW.hasData) return const SizedBox.shrink();
            var hw = snapHW.data!;
            return FutureBuilder<List<CompletionFlagModel>>(
              future: hw.getAllCompletions(),
              builder: (context, snapCompl) {
                if (!snapCompl.hasData) return const SizedBox.shrink();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(S.of(context).classHomeworkTitle),
                    ListTile(
                      // onTap: () => editClassHomework(hw),
                      leading: Text(Utils.formatDatetime(hw.date, format: 'dd MMM')),
                      title: Text(
                        hw.text,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      trailing: widget.readOnly
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => editClassHomework(hw),
                            ),
                    ),
                    Text(S.of(context).classHomeworkCompletionsTitle),
                    Expanded(
                      child: ListView(
                        children: [
                          ...snapCompl.data!.map((compl) => ClassHomeworkCompetionTile(hw, compl, toggleHomeworkCompletion)),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
        Visibility(
          visible: !widget.readOnly,
          child: Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: addClassHomework,
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ],
    );
  }

  void addClassHomework() async {
    var res = await Get.to<bool>(
      () => HomeworkPage(
        widget._lesson,
        HomeworkModel.fromMap(
          null,
          {
            'class_id': widget._lesson.aclass.id,
            'date': Timestamp.fromDate(widget._date),
            'text': '',
            'teacher_id': widget._teacher.id,
            'curriculum_id': widget._curriculum.id,
          },
        ),
        personalHomework: false,
      ),
    );
    if (res is bool && res == true) {
      setState(() {});
    }
  }

  void editClassHomework(HomeworkModel hw) async {
    var res = await Get.to(() => HomeworkPage(widget._lesson, hw, personalHomework: false));
    if (res is bool && res == true) {
      setState(() {});
    }
  }

  void toggleHomeworkCompletion(HomeworkModel hw, CompletionFlagModel completion) async {
    switch (completion.status) {
      case Status.completed:
        await hw.confirmCompletion(completion, PersonModel.currentUser!);
        break;
      case Status.confirmed:
        await hw.unconfirmCompletion(completion, PersonModel.currentUser!);
        break;
      default:
    }
    setState(() {});
  }
}
