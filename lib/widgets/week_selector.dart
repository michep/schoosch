import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoosch/controller/week_controller.dart';

class WeekSelector extends StatelessWidget {
  WeekSelector({Key? key}) : super(key: key);

  final cw = Get.find<CurrentWeek>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CurrentWeek>(
      builder: (controller) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              iconSize: 36,
              icon: const Icon(Icons.navigate_before),
              onPressed: () {
                cw.changeCurrentWeek(-1);
              },
            ),
            const Text(
              'Неделя: ',
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
            ),
            Text(
                '${DateFormat('dd MMM', 'ru').format(cw.currentWeek.start)} \u2014 ${DateFormat('dd MMM', 'ru').format(cw.currentWeek.end)}'),
            IconButton(
              iconSize: 36,
              icon: const Icon(Icons.navigate_next),
              onPressed: () {
                cw.changeCurrentWeek(1);
              },
            ),
          ],
        );
      },
    );
  }
}
