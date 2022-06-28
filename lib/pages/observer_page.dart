import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/week_controller.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/drawer.dart';
import 'package:schoosch/widgets/week_selector.dart';

class ObserverPage extends StatelessWidget {
  final ClassModel _class;

  const ObserverPage(this._class, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(
        child: MDrawer(),
      ),
      appBar: MAppBar(
        'Обзор класса ${_class.name}',
        showProfile: true,
      ),
      body: SafeArea(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          WeekSelector(key: ValueKey(Get.find<CurrentWeek>().currentWeek.weekNumber)),
        ]),
      ),
    );
  }
}
