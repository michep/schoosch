import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/data/class_model.dart';
import 'package:schoosch/views/class_schedule.dart';

class ClassListTile extends StatelessWidget {
  final ClassModel _class;

  const ClassListTile(this._class, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        _class.name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: const SizedBox(
        height: 10,
      ),
      onTap: () => Get.to(() => ClassSchedule(_class)),
    );
  }
}
