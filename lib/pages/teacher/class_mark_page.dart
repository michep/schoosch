import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/mark_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/widgets/appbar.dart';
// import 'package:schoosch/widgets/mark_type_field.dart';

class ClassMarkPage extends StatefulWidget {
  final String title;
  final LessonModel lesson;

  const ClassMarkPage(this.lesson, this.title, {Key? key}) : super(key: key);

  @override
  State<ClassMarkPage> createState() => _ClassMarkPageState();
}

class _ClassMarkPageState extends State<ClassMarkPage> {
  @override
  void initState() {
    //
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var loc = S.of(context);
    return Scaffold(
      appBar: MAppBar(widget.title),
      body: SafeArea(
        child: Table(
          children: [],
        ),
      ),
    );
  }

  void save() async {}
}
