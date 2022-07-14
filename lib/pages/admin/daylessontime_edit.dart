import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/daylessontime_model.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/pages/admin/lessontime_tile.dart';
import 'package:schoosch/widgets/utils.dart';

class DayLessontimePage extends StatefulWidget {
  final DayLessontimeModel _dayLessontime;
  final String _title;

  const DayLessontimePage(this._dayLessontime, this._title, {Key? key}) : super(key: key);

  @override
  State<DayLessontimePage> createState() => _DayLessontimePageState();
}

class _DayLessontimePageState extends State<DayLessontimePage> {
  final TextEditingController _name = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final List<LessontimeModel> _lessontimes = [];
  final List<LessontimeModel> _removed = [];

  @override
  void initState() {
    _name.value = TextEditingValue(text: widget._dayLessontime.name);
    super.initState();
    widget._dayLessontime.lessontimes.then((value) {
      setState(() {
        _lessontimes.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var loc = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._title),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _delete(widget._dayLessontime),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                TextFormField(
                  controller: _name,
                  decoration: InputDecoration(
                    label: Text(loc.dayLessonTimeName),
                  ),
                  validator: (value) => Utils.validateTextNotEmpty(value, loc.errorNameEmpty),
                ),
                Column(
                  children: [
                    ..._lessontimes.map((e) {
                      return LessonTimeTile(e, e.order == _lessontimes.length, _deleteLast);
                    }),
                  ],
                ),
                IconButton(onPressed: _add, icon: const Icon(Icons.add)),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ElevatedButton(
                    child: Text(loc.saveChanges),
                    onPressed: () => _save(widget._dayLessontime),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _deleteLast() {
    if (_lessontimes.isNotEmpty) {
      setState(() {
        _removed.add(_lessontimes.removeLast());
      });
    }
  }

  void _add() {
    setState(() {
      _lessontimes.add(LessontimeModel.fromMap((_lessontimes.length + 1).toString(), <String, dynamic>{
        'from': '00:00',
        'till': '00:00',
      }));
    });
  }

  Future<void> _save(DayLessontimeModel dayLessontime) async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> map = {};
      map['name'] = _name.text;

      var ndayLessontime = DayLessontimeModel.fromMap(dayLessontime.id, map);
      await ndayLessontime.save();
      await _saveTimes();
      Get.back<DayLessontimeModel>(result: ndayLessontime);
    }
  }

  Future<void> _saveTimes() async {
    for (var t in _removed) {
      t.delete(widget._dayLessontime);
    }
    for (var t in _lessontimes) {
      t.save(widget._dayLessontime);
    }
  }

  Future<void> _delete(DayLessontimeModel dayLessontime) async {}
}
