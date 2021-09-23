import 'package:flutter/material.dart';
import 'package:schoosch/data/class_model.dart';
import 'package:schoosch/views/class_schedule.dart';

class ClassListTile extends StatelessWidget {
  final ClassModel _class;

  const ClassListTile(this._class, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_class.name),
      trailing: const SizedBox(
        height: 10,
      ),
      onTap: _onTap(context, _class),
    );
  }

  void Function() _onTap(BuildContext context, ClassModel cla) {
    return () {
      Navigator.of(context).push(MaterialPageRoute(builder: ClassSchedule(cla).build));
    };
  }
}
