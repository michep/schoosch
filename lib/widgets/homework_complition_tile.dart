import 'package:flutter/material.dart';
import 'package:schoosch/model/completion_flag_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/widgets/utils.dart';

class HomeworkCompetionTile extends StatefulWidget {
  final HomeworkModel hw;
  final CompletionFlagModel? compl;

  const HomeworkCompetionTile(this.hw, this.compl, {Key? key}) : super(key: key);

  @override
  State<HomeworkCompetionTile> createState() => _HomeworkCompetionTileState();
}

class _HomeworkCompetionTileState extends State<HomeworkCompetionTile> {
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
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: complTime,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(studentFullName),
              Text(widget.hw.text),
            ],
          ),
        ),
        // widget.compl != null
        //     ? Expanded(
        //         child: FutureBuilder<StudentModel>(
        //           future: widget.compl!.student,
        //           builder: (context, snapStud) {
        //             if (!snapStud.hasData) return const SizedBox.shrink();
        //             return Text(snapStud.data!.fullName);
        //           },
        //         ),
        //       )
        //     : const SizedBox.shrink(),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: icon,
        ),
      ],
    );
  }
}
