import 'package:flutter/material.dart';
import 'package:schoosch/model/completion_flag_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/widgets/utils.dart';

class StudentHomeworkCompetionTile extends StatelessWidget {
  final HomeworkModel hw;
  final CompletionFlagModel? compl;

  const StudentHomeworkCompetionTile(this.hw, this.compl, {Key? key}) : super(key: key);

  @override
  Widget build(Object context) {
    Widget icon;
    Widget complTime;

    if (compl != null) {
      switch (compl!.status) {
        case Status.completed:
          icon = IconButton(
            icon: const Icon(Icons.circle_outlined),
            onPressed: () {},
          );
          break;
        case Status.confirmed:
          icon = IconButton(
            icon: const Icon(Icons.check_circle_outline),
            onPressed: () {},
          );
          break;
        default:
          icon = const SizedBox.shrink();
      }
      complTime = Text(Utils.formatDatetime(compl!.completedTime!, format: 'dd MMM'));
    } else {
      icon = const SizedBox.shrink();
      complTime = const SizedBox.shrink();
    }
    return ListTile(
      leading: complTime,
      title: FutureBuilder<StudentModel?>(
          future: hw.student,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox.shrink();
            return Text(snapshot.data?.fullName ?? '');
          }),
      subtitle: Text(hw.text),
      trailing: icon,
    );
  }
}
