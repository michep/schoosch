import 'package:flutter/material.dart';
import 'package:schoosch/model/completion_flag_model.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/widgets/homework_complition_tile.dart';
import 'package:schoosch/widgets/utils.dart';

class StudentsTasksWithCompetionsView extends StatelessWidget {
  final DateTime _date;
  final Future<Map<String, HomeworkModel?>> Function(DateTime) _hwsFuture;

  const StudentsTasksWithCompetionsView(this._date, this._hwsFuture, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, HomeworkModel?>>(
      future: _hwsFuture(_date),
      builder: (context, snapHWs) {
        if (!snapHWs.hasData) return const SizedBox.shrink();
        var hws = snapHWs.data!;
        hws.remove('class');
        hws.removeWhere((key, value) => value == null);
        return ListView(
          children: [
            ...hws.values.map((e) {
              return FutureBuilder<List<CompletionFlagModel>>(
                future: e!.getAllCompletions(),
                builder: (context, snapcompl) {
                  if (!snapcompl.hasData) return SizedBox.shrink();
                  var compl = snapcompl.data!.isNotEmpty ? snapcompl.data![0] : null;
                  return HomeworkCompetionTile(e, compl);
                },
              );
            })
          ],
        );
      },
    );
  }
}
