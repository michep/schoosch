import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoosch/data/fire_store.dart';
import 'package:schoosch/data/yearweek_model.dart';

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
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_left_rounded),
            onPressed: () {},
          ),
          const Text(
            'Неделя: ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          FutureBuilder<List<YearweekModel>>(
              future: fs.getYearweekModel(DateTime.now()),
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? Text(
                        '${DateFormat('dd MMM yy').format(snapshot.data![0].start!)} \u2014 ${DateFormat('dd MMM yy').format(snapshot.data![0].end!)}')
                    : const Center(
                        child: CircularProgressIndicator(),
                      );
              }),
          IconButton(
            icon: const Icon(Icons.arrow_right),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
