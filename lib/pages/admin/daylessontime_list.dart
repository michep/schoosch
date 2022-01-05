import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/daylessontime_model.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/widgets/utils.dart';

class DayLessontimeListPage extends StatefulWidget {
  final InstitutionModel institution;
  final bool selectionMode;

  const DayLessontimeListPage(this.institution, {this.selectionMode = false, Key? key}) : super(key: key);

  @override
  State<DayLessontimeListPage> createState() => _DayLessontimeListPageState();
}

class _DayLessontimeListPageState extends State<DayLessontimeListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Раписания времени уроков'),
        actions: widget.selectionMode ? [] : [IconButton(onPressed: newDayLessontime, icon: const Icon(Icons.add))],
      ),
      body: SafeArea(
        child: FutureBuilder<List<DayLessontimeModel>>(
            future: widget.institution.daylessontimes,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Utils.progressIndicator();
              var sorted = snapshot.data!;
              sorted.sort((a, b) => a.name.compareTo(b.name));
              return ListView(
                children: [
                  ...sorted.map(
                    (v) => ListTile(
                      onTap: () => onTap(v),
                      title: Text(v.name),
                      leading: widget.selectionMode ? const Icon(Icons.chevron_left) : null,
                      trailing: widget.selectionMode ? null : const Icon(Icons.chevron_right),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }

  Future<void> onTap(DayLessontimeModel dayLessontime) async {
    if (widget.selectionMode) {
      return Get.back<DayLessontimeModel>(result: dayLessontime);
    } else {
      // var res = await Get.to<DayLessontimeModel>(() => DayLessontimePage(dayLessontime));
      // if (res is DayLessontimeModel) {
      setState(() {});
      // }
    }
  }

  Future<void> newDayLessontime() async {
    //   var ndaylt = DayLessontimeModel.empty();
    //   var res = await Get.to<DayLessontimeModel>(() => DayLessontimePage(ndaylt));
    //   if (res is DayLessontimeModel) {
    //     setState(() {});
    //   }
  }
}
