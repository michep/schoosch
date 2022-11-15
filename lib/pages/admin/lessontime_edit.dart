import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/utils.dart';

class LessonTimePage extends StatefulWidget {
  final LessontimeModel _lessontime;

  const LessonTimePage(this._lessontime, {Key? key}) : super(key: key);

  @override
  State<LessonTimePage> createState() => _LessonTimePageState();
}

class _LessonTimePageState extends State<LessonTimePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fromCont = TextEditingController();
  final TextEditingController _tillCont = TextEditingController();

  @override
  void initState() {
    _fromCont.value = TextEditingValue(text: Utils.formatTimeOfDay(widget._lessontime.from));
    _tillCont.value = TextEditingValue(text: Utils.formatTimeOfDay(widget._lessontime.till));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var loc = S.of(context);
    return Scaffold(
      appBar: MAppBar(widget._lessontime.order.toString()),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                TextFormField(
                  readOnly: true,
                  controller: _fromCont,
                  decoration: InputDecoration(
                    label: Text(loc.fromTitle),
                  ),
                  // validator: (value) => Utils.validaTimeNotEmptyeAndValid(value, loc.errorFromEmptyOrInvalid),
                  onTap: () async {
                    var s = _fromCont.text.split(':');
                    final time = await showTimePicker(
                      context: context,
                      initialTime: s.length == 2 ? TimeOfDay(hour: int.parse(s[0]), minute: int.parse(s[1])) : const TimeOfDay(hour: 0, minute: 0),
                    );
                    if (time != null) {
                      setState(() {
                        widget._lessontime.from = time;
                        _fromCont.text = Utils.formatTimeOfDay(time);
                      });
                    }
                  },
                ),
                TextFormField(
                  readOnly: true,
                  controller: _tillCont,
                  decoration: InputDecoration(
                    label: Text(loc.tillTitle),
                  ),
                  // validator: (value) => Utils.validaTimeNotEmptyeAndValid(value, loc.errorTillEmptyOrInvalid),
                  onTap: () async {
                    var s = _tillCont.text.split(':');
                    final time = await showTimePicker(
                      context: context,
                      initialTime: s.length == 2 ? TimeOfDay(hour: int.parse(s[0]), minute: int.parse(s[1])) : const TimeOfDay(hour: 0, minute: 0),
                    );
                    if (time != null) {
                      setState(() {
                        widget._lessontime.till = time;
                        _tillCont.text = Utils.formatTimeOfDay(time);
                      });
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ElevatedButton(
                    child: Text(loc.saveChanges),
                    onPressed: () => _save(widget._lessontime),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _save(LessontimeModel lessontime) async {
    if (_formKey.currentState!.validate()) {
      Get.back<LessontimeModel>(result: lessontime);
    }
  }
}
