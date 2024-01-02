import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/completion_flag_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/widgets/utils.dart';

class StudentHomeworkCompetionTile extends StatelessWidget {
  final HomeworkModel homework;
  final StudentModel student;
  final bool readOnly;
  final bool forceRefresh;
  final void Function(HomeworkModel, bool) editHomework;
  final void Function(HomeworkModel) delete;
  final void Function(HomeworkModel, CompletionFlagModel) toggleHomeworkCompletion;

  const StudentHomeworkCompetionTile({
    super.key,
    required this.homework,
    required this.student,
    required this.editHomework,
    required this.delete,
    required this.toggleHomeworkCompletion,
    required this.readOnly,
    this.forceRefresh = false,
  });

  @override
  Widget build(Object context) {
    Widget icon;
    Widget complTime;

    return FutureBuilder<CompletionFlagModel?>(
      future: homework.getStudentCompletion(student, forceRefresh: forceRefresh),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) return const SizedBox.shrink();
        var completion = snapshot.data;
        if (completion != null) {
          switch (completion.status) {
            case CompletionStatus.completed:
              icon = IconButton(
                icon: const Icon(Icons.circle_outlined),
                onPressed: () => toggleHomeworkCompletion(homework, completion),
              );
              break;
            case CompletionStatus.confirmed:
              icon = IconButton(
                icon: const Icon(Icons.check_circle_outline),
                onPressed: () => toggleHomeworkCompletion(homework, completion),
              );
              break;
            default:
              icon = const SizedBox.shrink();
          }
          complTime = Text(Utils.formatDatetime(completion.completedTime!, format: 'dd MMM'));
        } else {
          icon = const SizedBox.shrink();
          complTime = const SizedBox.shrink();
        }
        return ListTile(
          leading: complTime,
          title: Linkify(
            text: homework.text,
            onOpen: (link) => Utils.openLink(link.url),
            overflow: TextOverflow.ellipsis,
            maxLines: 10,
          ),
          subtitle: Text(
            '${Utils.formatDatetime(homework.date)} - ${Utils.formatDatetime(homework.todate!)}',
            style: TextStyle(
              color: Get.theme.colorScheme.onBackground.withOpacity(0.7),
              fontSize: 13,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              if (!readOnly)
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => editHomework(homework, true),
                ),
              if (!readOnly)
                IconButton(
                  onPressed: () => delete(homework),
                  icon: const Icon(
                    Icons.delete,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
