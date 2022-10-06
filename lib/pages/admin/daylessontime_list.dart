import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/daylessontime_model.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/pages/admin/daylessontime_edit.dart';
import 'package:schoosch/widgets/utils.dart';

class DayLessontimeListPage extends StatefulWidget {
  final InstitutionModel _institution;
  final bool selectionMode;

  const DayLessontimeListPage(this._institution, {this.selectionMode = false, Key? key}) : super(key: key);

  @override
  State<DayLessontimeListPage> createState() => _DayLessontimeListPageState();
}

class _DayLessontimeListPageState extends State<DayLessontimeListPage> {
  final TextEditingController _name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var loc = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).dayLessontimeList),
        actions: widget.selectionMode ? [] : [IconButton(onPressed: _newDayLessontime, icon: const Icon(Icons.add))],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Card(
              child: ExpansionTile(
                title: _inSearch ? Text(loc.search, style: const TextStyle(fontStyle: FontStyle.italic)) : Text(loc.search),
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    onChanged: (_) => setState(() {}),
                    controller: _name,
                    decoration: InputDecoration(
                      label: Text(loc.name),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() {
                          _name.value = TextEditingValue.empty;
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<DayLessontimeModel>>(
                  future: widget._institution.daylessontimes,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Utils.progressIndicator();
                    var sorted = snapshot.data!;
                    sorted.sort((a, b) => a.name.compareTo(b.name));
                    return ListView(
                      children: [
                        ...sorted.where(_filter).map(
                              (v) => ListTile(
                                onTap: () => _onTap(v),
                                title: Text(v.name),
                                leading: widget.selectionMode ? const Icon(Icons.chevron_left) : null,
                                trailing: widget.selectionMode ? null : const Icon(Icons.chevron_right),
                              ),
                            ),
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  bool _filter(DayLessontimeModel daylessontime) {
    return daylessontime.name.toUpperCase().contains(_name.text.toUpperCase());
  }

  bool get _inSearch {
    return _name.text.isNotEmpty;
  }

  Future<void> _onTap(DayLessontimeModel dayLessontime) async {
    if (widget.selectionMode) {
      return Get.back<DayLessontimeModel>(result: dayLessontime);
    } else {
      var res = await Get.to<DayLessontimeModel>(() => DayLessontimePage(dayLessontime, dayLessontime.name), transition: Transition.rightToLeft);
      if (res is DayLessontimeModel) {
        setState(() {});
      }
    }
  }

  Future<void> _newDayLessontime() async {
    ///TODO:
  }
}
