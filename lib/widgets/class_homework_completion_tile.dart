import 'package:flutter/material.dart';
import 'package:schoosch/model/completion_flag_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/widgets/utils.dart';

class ClassHomeworkCompetionTile extends StatefulWidget {
  final HomeworkModel hw;
  final CompletionFlagModel compl;

  const ClassHomeworkCompetionTile(this.hw, this.compl, {Key? key}) : super(key: key);

  @override
  State<ClassHomeworkCompetionTile> createState() => _ClassHomeworkCompetionTileState();
}

class _ClassHomeworkCompetionTileState extends State<ClassHomeworkCompetionTile> {
  String studentFullName = '';

  @override
  void initState() {
    super.initState();
    widget.compl.student.then((value) {
      setState(() {
        studentFullName = value.fullName;
      });
    });
  }

  @override
  Widget build(Object context) {
    Widget icon;
    Widget complTime;

    switch (widget.compl.status) {
      case Status.completed:
        icon = const Icon(Icons.circle_outlined);
        break;
      case Status.confirmed:
        icon = const Icon(Icons.check_circle_outline);
        break;
      default:
        icon = const SizedBox.shrink();
    }
    complTime = Text(Utils.formatDatetime(widget.compl.completedTime!, format: 'dd MMM'));
    return ListTile(
      leading: complTime,
      title: Text(studentFullName),
      trailing: icon,
    );
  }
}
