import 'package:flutter/material.dart';
import 'package:schoosch/model/completion_flag_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/widgets/utils.dart';

class ClassHomeworkCompetionTile extends StatelessWidget {
  final HomeworkModel homework;
  final CompletionFlagModel completion;
  final void Function(HomeworkModel, CompletionFlagModel) toggleHomeworkCompletion;

  const ClassHomeworkCompetionTile({
    Key? key,
    required this.homework,
    required this.completion,
    required this.toggleHomeworkCompletion,
  }) : super(key: key);

  @override
  Widget build(Object context) {
    Widget icon;
    Widget complTime;

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
    return ListTile(
      leading: complTime,
      title: FutureBuilder<StudentModel>(
          future: completion.student,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox.shrink();
            return Text(snapshot.data!.fullName);
          }),
      trailing: icon,
    );
  }
}
