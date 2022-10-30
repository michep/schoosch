import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:schoosch/model/completion_flag_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/widgets/teacher/class_homework_completion_tile.dart';
import 'package:schoosch/widgets/utils.dart';

class ClassHomeworkTile extends StatelessWidget {
  final bool readOnly;
  final bool forceRefresh;
  final HomeworkModel homework;
  final void Function(HomeworkModel, CompletionFlagModel) toggleHomeworkCompletion;
  final void Function(HomeworkModel, bool) editHomework;

  const ClassHomeworkTile({
    Key? key,
    required this.homework,
    required this.toggleHomeworkCompletion,
    required this.editHomework,
    required this.readOnly,
    this.forceRefresh = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CompletionFlagModel>>(
      future: homework.getAllCompletions(forceRefresh: forceRefresh),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) return const SizedBox.shrink();
        return ExpansionTile(
          iconColor: ListTileTheme.of(context).iconColor,
          textColor: ListTileTheme.of(context).textColor,
          controlAffinity: ListTileControlAffinity.leading,
          // leading: Text(
          //   Utils.formatDatetime(
          //     homework.date,
          //     format: 'dd MMM',
          //   ),
          // ),
          title: Linkify(
            text: homework.text,
            onOpen: (link) => Utils.openLink(link.url),
            overflow: TextOverflow.ellipsis,
            maxLines: 10,
          ),
          subtitle: Text(
            '${Utils.formatDatetime(homework.date)} - ${Utils.formatDatetime(homework.todate!)}',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
              fontSize: 13,
            ),
          ),
          trailing: readOnly
              ? null
              : IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => editHomework(homework, false),
                ),
          children: [
            ...snapshot.data!.map(
              (compl) => ClassHomeworkCompetionTile(
                homework: homework,
                completion: compl,
                toggleHomeworkCompletion: toggleHomeworkCompletion,
              ),
            ),
          ],
        );
      },
    );
  }
}
