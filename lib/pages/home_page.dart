import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/week_controller.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/drawer.dart';
import 'package:schoosch/widgets/scheduleswitcher.dart';
import 'package:schoosch/widgets/student_schedule.dart';
import 'package:schoosch/widgets/utils.dart';
import 'package:schoosch/widgets/week_selector.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
                  return AnimatedSwipeScheduleSwitcher(
                    child: StudentScheduleWidget(classSnap.data!),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
