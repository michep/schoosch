import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  final void Function(HomeworkModel) delete;

  const StudentHomeworkTile({
    super.key,
    required this.homeworks,
    required this.toggleHomeworkCompletion,
    required this.editHomework,
    required this.delete,
    required this.readOnly,
    this.forceRefresh = false,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<StudentModel?>(
      future: homeworks[0].student,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done || !snapshot.hasData) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child:  ExpansionTile(
              key: PageStorageKey(snapshot.data!.id),
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(snapshot.data!.fullName),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(12),
                side: BorderSide(color: Get.theme.primaryColor)
              ),
              children: [
                ...homeworks.map(
                  (hw) => StudentHomeworkCompetionTile(
                    homework: hw,
                    student: snapshot.data!,
                    editHomework: editHomework,
                    delete: delete,
                    toggleHomeworkCompletion: toggleHomeworkCompletion,
                    readOnly: readOnly,
                    forceRefresh: forceRefresh,
                  ),
                ),
              ],
            ),
        );
      },
    );
  }
}
