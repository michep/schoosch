import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/attachments_model.dart';
import 'package:schoosch/model/completion_flag_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/widgets/attachments.dart';
import 'package:schoosch/widgets/utils.dart';

class ClassHomeworkCompetionTile extends StatelessWidget {
  final HomeworkModel homework;
  final CompletionFlagModel completion;
  final void Function(HomeworkModel, CompletionFlagModel) toggleHomeworkCompletion;

  const ClassHomeworkCompetionTile({
    super.key,
    required this.homework,
    required this.completion,
    required this.toggleHomeworkCompletion,
  });

  @override
  Widget build(Object context) {
    Widget icon;
    Widget complTime;

    List<AttachmentModel> attachments = completion.getAttachments();

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
    complTime = Text(Utils.formatDatetime(completion.completedTime!, format: 'dd MMM'), style: TextStyle(fontSize: 12, color: Colors.white70),);
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Get.theme.primaryColor,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  complTime,
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: FutureBuilder<StudentModel>(
                      future: completion.student,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const SizedBox.shrink();
                        return Text(snapshot.data!.fullName, style: TextStyle(fontSize: 16,),);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  icon,
                ],
              ),
              
              if (attachments.isNotEmpty)
                const SizedBox(
                  height: 8,
                ),
              if (attachments.isNotEmpty) Text('Файлы с решением:'),
              if (attachments.isNotEmpty)
                const SizedBox(
                  height: 4,
                ),
              ...attachments.map((e) {
                return Attachment(
                  attachment: e,
                  readOnly: true,
                  isExpanded: true,
                  onDelete: (a) {},
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
