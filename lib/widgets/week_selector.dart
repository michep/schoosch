import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoosch/controller/fire_store_controller.dart';

class WeekSelector extends StatefulWidget {
  const WeekSelector({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WeekSelectorState();
}

class _WeekSelectorState extends State<WeekSelector> {
  String val = '';

  @override
  Widget build(BuildContext context) {
    final fs = Get.find<FStore>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          iconSize: 36,
          icon: const Icon(Icons.navigate_before),
          onPressed: () {
            changeCurrentWeek(-1);
          },
        ),
        const Text(
          'Неделя: ',
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
        ),
        Text('${DateFormat('dd MMM', 'ru').format(fs.currentWeek.start)} \u2014 ${DateFormat('dd MMM', 'ru').format(fs.currentWeek.end)}'),
        IconButton(
          iconSize: 36,
          icon: const Icon(Icons.navigate_next),
          onPressed: () {
            changeCurrentWeek(1);
          },
        ),
      ],
    );
  }

  void changeCurrentWeek(int n) {
    final fs = Get.find<FStore>();
    setState(() {
      fs.changeCurrentWeek(n);
    });
  }
}
