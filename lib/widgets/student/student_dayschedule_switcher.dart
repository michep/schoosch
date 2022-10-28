import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/week_controller.dart';
import 'package:schoosch/model/person_model.dart';

class StudentScheduleSwitcher extends StatefulWidget {
  final StudentModel _student;
  const StudentScheduleSwitcher(this._student, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => StudentScheduleSwitcherState();
}

class StudentScheduleSwitcherState extends State<StudentScheduleSwitcher> {
  final _cw = Get.find<CurrentWeek>();

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder(future: widget._class.get, builder: (context, snapshot) {},)
    return Container();
  }
}