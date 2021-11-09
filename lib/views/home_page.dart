import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/views/schedule_page.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/drawer.dart';
import 'package:schoosch/widgets/utils.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = Get.find<FStore>();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: const Drawer(
          child: MDrawer(),
        ),
        appBar: const MAppBar(
          'Schoosch / Скуш',
          showProfile: true,
          tabs: [
            Tab(
              text: 'Раписание',
              icon: Icon(Icons.calendar_today),
            ),
            Tab(
              text: 'Задания',
              icon: Icon(Icons.task_alt),
            ),
          ],
        ),
        body: TabBarView(
          // physics: NeverScrollableScrollPhysics(),
          children: [
            FutureBuilder<ClassModel>(
              future: data.getCurrentUserClassModel(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Utils.progressIndicator();
                }
                return SchedulePage(snapshot.data!);
              },
            ),
            Container(),
          ],
        ),
      ),
    );
  }
}
