import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/widgets/observer/curriculum_selection.dart';
import 'package:schoosch/widgets/observer/observer_schedule_switcher.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/drawer.dart';

class ObserverPage extends StatefulWidget {
  final ClassModel _class;

  const ObserverPage(this._class, {super.key});

  @override
  State<ObserverPage> createState() => _ObserverPageState();
}

class _ObserverPageState extends State<ObserverPage> with SingleTickerProviderStateMixin {
  int current = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    _pages = [
      ObserverSchedule(widget._class),
      CurriculumSelection(widget._class),
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
        S.of(context).observedClassTitle(widget._class.name),
        showProfile: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _pages[current],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Get.theme.colorScheme.primary,
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
        child: GNav(
          onTabChange: (i) => setState(() {
            current = i;
          }),
          gap: 8,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          color: Get.theme.colorScheme.onSurface.withValues(alpha: 0.5),
          activeColor: Get.theme.colorScheme.onSurface,
          tabActiveBorder: Border.all(
            color: Get.theme.colorScheme.onSurface,
          ),
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          tabs: [
            GButton(
              icon: Icons.schema_rounded,
              text: S.of(context).tabScheduleHomeworksTitle,
            ),
            GButton(
              icon: Icons.school_rounded,
              text: S.of(context).tabStudentsPerformance,
            ),
          ],
        ),
      ),
    );
  }
}
