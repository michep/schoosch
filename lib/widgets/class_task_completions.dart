import 'package:flutter/material.dart';
import 'package:schoosch/model/completion_flag_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/widgets/homework_complition_tile.dart';
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
                ListTile(
                  leading: Text(Utils.formatDatetime(hw.date, format: 'dd MMM')),
                  title: Text(hw.text),
                ),
                Text('Выполнение:'),
                Expanded(
                  child: ListView(
                    children: [
                      ...snapCompl.data!.map((compl) => HomeworkCompetionTile(hw, compl)),
                    ],
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
