import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoosch/controller/day_controller.dart';

class DaySelector extends StatelessWidget {
  DaySelector({Key? key}) : super(key: key);

  final cd = Get.find<CurrentDay>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          iconSize: 24,
          icon: const Icon(Icons.today),
          onPressed: cd.changeToCurrentDay,
        ),
        const Spacer(),
        Obx(() => Text(DateFormat('EEE, dd.MM.y').format(cd.currentDay))),
        IconButton(
          iconSize: 36,
          icon: const Icon(Icons.navigate_before),
          onPressed: cd.previous,
        ),
        IconButton(
          iconSize: 36,
          icon: const Icon(Icons.navigate_next),
          onPressed: cd.next,
        ),
      ],
    );
  }
}