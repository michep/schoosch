import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/status_enum.dart';
import 'package:schoosch/model/studyperiod_model.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/modelstatus_field.dart';
import 'package:schoosch/widgets/studyperiod_type_field.dart';
import 'package:schoosch/widgets/utils.dart';

class StudyPeriodPage extends StatefulWidget {
  final StudyPeriodModel _period;
  final String _title;

  const StudyPeriodPage(this._period, this._title, {super.key});

  @override
  State<StudyPeriodPage> createState() => _StudyPeriodPageState();
}

class _StudyPeriodPageState extends State<StudyPeriodPage> {
  final TextEditingController _name = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late DateTime? _from;
  late DateTime? _till;
  late StudyPeriodType _periodType;
  late ModelStatus _status;

  @override
  void initState() {
    _name.value = TextEditingValue(text: widget._period.name);
    _from = widget._period.from;
    _till = widget._period.till;
    _periodType = widget._period.type;
    _status = widget._period.status;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var loc = S.of(context);
    return Scaffold(
      appBar: MAppBar(
        widget._title,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _delete(widget._period),
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
                    label: Text(loc.studyPeriodTitle),
                  ),
                  validator: (value) => Utils.validateTextNotEmpty(value, loc.errorNameEmpty),
                ),
                DateTimeField(
                  initialValue: _from,
                  format: DateFormat('dd MMM yyyy'),
                  onChanged: (DateTime? date) => _from = date,
                  decoration: InputDecoration(
                    label: Text(loc.fromTitle),
                  ),
                  validator: (value) => Utils.validateDateTimeNotEmpty(value, loc.errorScheduleFromDateEmpty),
                  onShowPicker: (context, currentValue) async {
                    final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    return date;
                  },
                ),
                DateTimeField(
                  initialValue: _till,
                  format: DateFormat('dd MMM yyyy'),
                  onChanged: (DateTime? date) => _till = date,
                  decoration: InputDecoration(
                    label: Text(loc.tillTitle),
                  ),
                  validator: (value) => Utils.validateDateTimeNotEmpty(value, loc.errorScheduleFromDateEmpty),
                  onShowPicker: (context, currentValue) async {
                    final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    return date;
                  },
                ),
                StudyPeriodTypeFormField(
                  periodType: _periodType,
                  onChanged: (v) {
                    if (v is StudyPeriodType) {
                      setState(() {
                        _periodType = v;
                      });
                    }
                  },
                ),
                ModelStatusFormField(
                  status: _status,
                  onChanged: (v) {
                    if (v is ModelStatus) {
                      setState(() {
                        _status = v;
                      });
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ElevatedButton(
                    child: Text(loc.saveChanges),
                    onPressed: () => _save(widget._period),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _save(StudyPeriodModel period) async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> map = {};
      map['name'] = _name.text;
      map['type'] = _periodType.nameString;
      map['status'] = _status.nameInt;
      map['from'] = _from!.toIso8601String();
      map['till'] = _till!.toIso8601String();

      var nperiod = StudyPeriodModel.fromMap(period.id, map);
      await nperiod.save();
      Get.back<StudyPeriodModel>(result: nperiod);
    }
  }

  Future<void> _delete(StudyPeriodModel period) async {
    // period.delete();
    Get.back<StudyPeriodModel>(result: period);
  }
}
