import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/daylessontime_model.dart';
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

  @override
  void initState() {
    _name.value = TextEditingValue(text: widget._dayLessontime.name);
    super.initState();
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
                    label: Text(loc.venueName),
                  ),
                  validator: (value) => Utils.validateTextNotEmpty(value, loc.errorNameEmpty),
                ),
                FutureBuilder(
                    future: widget._dayLessontime.lessontimes,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const SizedBox.shrink();
                      return ListView(
                        children: [...snapshot.data!],
                      );
                    }),
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

  Future<void> _save(DayLessontimeModel dayLessontime) async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> map = {};
      map['name'] = _name.text;

      var ndayLessontime = DayLessontimeModel.fromMap(dayLessontime.id, map);
      await ndayLessontime.save();
      Get.back<DayLessontimeModel>(result: ndayLessontime);
    }
  }

  Future<void> _delete(DayLessontimeModel dayLessontime) async {}
}
