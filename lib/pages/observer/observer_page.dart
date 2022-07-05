import 'package:flutter/material.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/pages/class_subject_page.dart';
import 'package:schoosch/pages/observer/observer_schedule_page.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/drawer.dart';
// import 'package:schoosch/widgets/week_selector.dart';

class ObserverPage extends StatefulWidget {
  final ClassModel _class;

  const ObserverPage(this._class, {Key? key}) : super(key: key);

  @override
  State<ObserverPage> createState() => _ObserverPageState();
}

class _ObserverPageState extends State<ObserverPage> with SingleTickerProviderStateMixin {
  late TabController tabcont;
  int currenSelection = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    tabcont = TabController(length: 2, vsync: this);
    _pages = [
      Expanded(child: ObserverSchedule(widget._class),),
      Expanded(child: SubjectList(widget._class),),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(
        child: MDrawer(),
      ),
      appBar: MAppBar(
        'Обзор класса ${widget._class.name}',
        showProfile: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 60,
              child: TabBar(
                controller: tabcont,
                onTap: (i) {
                  setState(() {
                    currenSelection = i;
                  });
                },
                tabs: const [
                  Tab(
                    text: 'расписание/ДЗ',
                  ),
                  Tab(
                    text: 'успеваемость',
                  )
                ],
              ),
            ),
            // WeekSelector(
            //   key: ValueKey(Get.find<CurrentWeek>().currentWeek.weekNumber),
            // ),
            _pages[currenSelection],
          ],
        ),
      ),
    );
  }
}
