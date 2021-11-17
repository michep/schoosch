import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/week_controller.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/widgets/schedule.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/drawer.dart';
import 'package:schoosch/widgets/utils.dart';
import 'package:schoosch/widgets/week_selector.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final cw = Get.find<CurrentWeek>();

  @override
  Widget build(BuildContext context) {
    var _store = Get.find<FStore>();
    return Scaffold(
      drawer: const Drawer(
        child: MDrawer(),
      ),
      appBar: const MAppBar(
        'Schoosch / Скуш',
        showProfile: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            WeekSelector(key: ValueKey(Get.find<CurrentWeek>().currentWeek.id)),
            Expanded(
              child: FutureBuilder<ClassModel>(
                future: _store.getCurrentUserClassModel(),
                builder: (context, classSnap) {
                  if (!classSnap.hasData) {
                    return Utils.progressIndicator();
                  }
                  return Obx(() => slideSwitcher(classSnap));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget slideSwitcher(AsyncSnapshot<ClassModel> classSnap) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      reverseDuration: const Duration(seconds: 0),
      switchInCurve: Curves.easeIn,
      layoutBuilder: layoutBuilder,
      transitionBuilder: transitionBuilder,
      child: dismissibleSchedule(classSnap),
    );
  }

  Widget dismissibleSchedule(AsyncSnapshot<ClassModel> classSnap) {
    return Dismissible(
      confirmDismiss: onDismissed,
      key: ValueKey(cw.currentWeek.id),
      resizeDuration: const Duration(seconds: 0),
      child: ScheduleWidget(classSnap.data!),
    );
  }

  Widget layoutBuilder(Widget? currentChild, List<Widget> previousChildren) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        ...previousChildren,
        if (currentChild != null) currentChild,
      ],
    );
  }

  Widget transitionBuilder(Widget child, Animation<double> animation) {
    return SlideTransition(
      position: cw.lastChange == 1
          ? Tween<Offset>(begin: const Offset(1, 0), end: const Offset(0, 0)).animate(animation)
          : Tween<Offset>(begin: const Offset(-1, 0), end: const Offset(0, 0)).animate(animation),
      child: child,
    );
  }

  Future<bool> onDismissed(DismissDirection dir) async {
    switch (dir) {
      case DismissDirection.endToStart:
        return cw.changeCurrentWeek(1);
      case DismissDirection.startToEnd:
        return cw.changeCurrentWeek(-1);
      default:
        return false;
    }
  }
}
