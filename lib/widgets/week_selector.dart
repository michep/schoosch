import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isoweek/isoweek.dart';
import 'package:schoosch/controller/week_controller.dart';
import 'package:schoosch/widgets/utils.dart';

class WeekSelector extends StatelessWidget {
  WeekSelector({Key? key}) : super(key: key);

  final cw = Get.find<CurrentWeek>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          iconSize: 24,
          icon: const Icon(Icons.today),
          onPressed: cw.changeToCurrentWeek,
        ),
        const Spacer(),
        const Text(
          'Неделя: ',
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
        ),
        Obx(() => Text(_formatWeek(cw.currentWeek))),
        IconButton(
          iconSize: 36,
          icon: const Icon(Icons.navigate_before),
          onPressed: cw.previous,
        ),
        IconButton(
          iconSize: 36,
          icon: const Icon(Icons.navigate_next),
          onPressed: cw.next,
        ),
      ],
    );
  }

  String _formatWeek(Week week) {
    return Utils.formatPeriod(week.day(0), week.day(7).subtract(const Duration(seconds: 1)), format: 'dd MMM');
  }
}
