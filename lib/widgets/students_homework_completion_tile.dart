import 'package:flutter/material.dart';
import 'package:schoosch/model/completion_flag_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/widgets/utils.dart';

class StudentHomeworkCompetionTile extends StatefulWidget {
  final HomeworkModel hw;
  final CompletionFlagModel? compl;

  const StudentHomeworkCompetionTile(this.hw, this.compl, {Key? key}) : super(key: key);

  @override
  State<StudentHomeworkCompetionTile> createState() => _StudentHomeworkCompetionTileState();
}

class _StudentHomeworkCompetionTileState extends State<StudentHomeworkCompetionTile> {
  String studentFullName = '';

  @override
  void initState() {
    super.initState();
    widget.hw.student.then((value) {
      setState(() {
        studentFullName = value?.fullName ?? '';
      });
    });
  }

  @override
  Widget build(Object context) {
    Widget icon;
    Widget complTime;

    if (widget.compl != null) {
      switch (widget.compl!.status) {
        case Status.completed:
          icon = const Icon(Icons.check);
          break;
        case Status.confirmed:
          icon = const Icon(Icons.check_circle_outline);
          break;
        default:
          icon = const SizedBox.shrink();
      }
      complTime = Text(Utils.formatDatetime(widget.compl!.completedTime!, format: 'dd MMM'));
    } else {
      icon = const SizedBox.shrink();
      complTime = const SizedBox.shrink();
    }
    return ListTile(
      leading: complTime,
      title: Text(studentFullName),
      subtitle: Text(widget.hw.text),
      trailing: icon,
    );
  }
}
