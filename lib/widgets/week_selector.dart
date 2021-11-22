import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoosch/controller/week_controller.dart';

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
          onPressed: () => cw.changeToCurrentWeek(),
        ),
        const Spacer(),
        const Text(
          'Неделя: ',
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
        ),
        Obx(
          () => Text(
              '${DateFormat('dd MMM', 'ru').format(cw.currentWeek.day(0))} \u2014 ${DateFormat('dd MMM', 'ru').format(cw.currentWeek.day(7))}'),
        ),
        IconButton(
          iconSize: 36,
          icon: const Icon(Icons.navigate_before),
          onPressed: () => cw.changeCurrentWeek(-1),
        ),
        IconButton(
          iconSize: 36,
          icon: const Icon(Icons.navigate_next),
          onPressed: () => cw.changeCurrentWeek(1),
        ),
      ],
    );
  }
}
