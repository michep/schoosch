import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schoosch/model/mark_model.dart';

class TableMarkCell extends StatelessWidget {
  final LessonMarkModel lessonmark;

  const TableMarkCell({
    required this.lessonmark,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 120.0,
      height: 60.0,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.black54),
      margin: const EdgeInsets.all(4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateFormat.Md().format(lessonmark.date),
            style: const TextStyle(fontSize: 12),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                lessonmark.mark.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 4),
              Text('(x${lessonmark.type.weight.toStringAsFixed(1)})'),
            ],
          ),
        ],
      ),
    );
  }
}
