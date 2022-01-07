import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/daylessontime_model.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/widgets/utils.dart';

class DayLessontimeListPage extends StatefulWidget {
  final InstitutionModel _institution;
  final bool selectionMode;

  const DayLessontimeListPage(this._institution, {this.selectionMode = false, Key? key}) : super(key: key);

  @override
  State<DayLessontimeListPage> createState() => _DayLessontimeListPageState();
}

class _DayLessontimeListPageState extends State<DayLessontimeListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Раписания времени уроков'),
        actions: widget.selectionMode ? [] : [IconButton(onPressed: _newDayLessontime, icon: const Icon(Icons.add))],
      ),
      body: SafeArea(
        child: FutureBuilder<List<DayLessontimeModel>>(
            future: widget._institution.daylessontimes,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Utils.progressIndicator();
              var sorted = snapshot.data!;
              sorted.sort((a, b) => a.name.compareTo(b.name));
              return Scrollbar(
                isAlwaysShown: true,
                child: ListView(
                  children: [
                    ...sorted.map(
                      (v) => ListTile(
                        onTap: () => _onTap(v),
                        title: Text(v.name),
                        leading: widget.selectionMode ? const Icon(Icons.chevron_left) : null,
                        trailing: widget.selectionMode ? null : const Icon(Icons.chevron_right),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  Future<void> _onTap(DayLessontimeModel dayLessontime) async {
    if (widget.selectionMode) {
      return Get.back<DayLessontimeModel>(result: dayLessontime);
    } else {
      setState(() {});
    }
  }

  Future<void> _newDayLessontime() async {}
}
