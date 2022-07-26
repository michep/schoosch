import 'package:flutter/material.dart';
import 'package:schoosch/model/completion_flag_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/widgets/utils.dart';

class ClassTaskWithCompetionsView extends StatelessWidget {
  final DateTime _date;
  final Future<HomeworkModel?> Function(DateTime) _hwFuture;

  const ClassTaskWithCompetionsView(this._date, this._hwFuture, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HomeworkModel?>(
      future: _hwFuture(_date),
      builder: (context, snapHW) {
        if (!snapHW.hasData) return const SizedBox.shrink();
        var hw = snapHW.data!;
        return FutureBuilder<List<CompletionFlagModel>>(
          future: hw.getAllCompletions(),
          builder: (context, snapCompl) {
            if (!snapCompl.hasData) return const SizedBox.shrink();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Задание всему классу:'),
                Text(hw.text),
                Text('Выполнение:'),
                Expanded(
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ...snapCompl.data!.map((compl) => ClassTaskCompetionTile(hw, compl)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class ClassTaskCompetionTile extends StatelessWidget {
  final HomeworkModel hw;
  final CompletionFlagModel compl;

  const ClassTaskCompetionTile(this.hw, this.compl, {Key? key}) : super(key: key);
  @override
  Widget build(Object context) {
    Widget icon;
    switch (compl.status) {
      case Status.completed:
        icon = const Icon(Icons.check);
        break;
      case Status.confirmed:
        icon = const Icon(Icons.check_circle_outline);
        break;
      default:
        icon = const SizedBox.shrink();
    }
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Text(Utils.formatDatetime(hw.date, format: 'dd MMM')),
        ),
        Expanded(
          child: FutureBuilder<StudentModel>(
            future: compl.student,
            builder: (context, snapStud) {
              if (!snapStud.hasData) return const SizedBox.shrink();
              return Text(snapStud.data!.fullName);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: icon,
        ),
      ],
    );
  }
}
