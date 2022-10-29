import 'package:flutter/material.dart';
import 'package:schoosch/model/completion_flag_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/widgets/teacher/student_homework_completion_tile.dart';

class StudentHomeworkTile extends StatelessWidget {
  final bool readOnly;
  final bool forceRefresh;
  final List<HomeworkModel> homeworks;
  final void Function(HomeworkModel, CompletionFlagModel) toggleHomeworkCompletion;
  final void Function(HomeworkModel, bool) editHomework;

  const StudentHomeworkTile({
    Key? key,
    required this.homeworks,
    required this.toggleHomeworkCompletion,
    required this.editHomework,
    required this.readOnly,
    this.forceRefresh = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<StudentModel?>(
      future: homeworks[0].student,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done || !snapshot.hasData) return const SizedBox.shrink();
        return ExpansionTile(
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(snapshot.data!.fullName),
          children: [
            ...homeworks
                .map((hw) => StudentHomeworkCompetionTile(
                      homework: hw,
                      student: snapshot.data!,
                      editHomework: editHomework,
                      toggleHomeworkCompletion: toggleHomeworkCompletion,
                      readOnly: readOnly,
                      forceRefresh: forceRefresh,
                    ))
                .toList(),
          ],
        );
      },
    );
  }
}
