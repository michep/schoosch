import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/completion_flag_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/pages/teacher/homework_page.dart';
import 'package:schoosch/widgets/teacher/class_homework_completion_tile.dart';
import 'package:schoosch/widgets/utils.dart';

class ClassTaskWithCompetionsPage extends StatelessWidget {
  final DateTime _date;
  final LessonModel _lesson;
  final Future<HomeworkModel?> Function(DateTime) _hwFuture;
  final bool readOnly;

  const ClassTaskWithCompetionsPage(this._date, this._lesson, this._hwFuture, {Key? key, this.readOnly = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder<HomeworkModel?>(
          future: _hwFuture(_date),
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
                    const Text('Задание всему классу:'),
                    ListTile(
                      onTap: () => editClassHomework(hw),
                      leading: Text(Utils.formatDatetime(hw.date, format: 'dd MMM')),
                      title: Text(hw.text),
                    ),
                    const Text('Выполнение:'),
                    Expanded(
                      child: ListView(
                        children: [
                          ...snapCompl.data!.map((compl) => ClassHomeworkCompetionTile(hw, compl)),
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
          visible: !readOnly,
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

  void addClassHomework() {
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

  void editClassHomework(HomeworkModel hw) {
    Get.to(() => HomeworkPage(_lesson, hw));
  }
}
