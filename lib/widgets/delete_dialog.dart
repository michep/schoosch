import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/mark_model.dart';

class DeleteDialog extends StatelessWidget {
  final HomeworkModel? hw;
  final MarkModel? mark;
  final BuildContext context;

  //TODO: make a bottom sheet
  const DeleteDialog({
    super.key,
    this.hw,
    this.mark,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Точно хотите удалить?'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(hw != null ? 'Домашнее задание:' : 'Оценку:'),
          Text(
            hw != null ? hw!.text : mark!.toString(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text('Для:'),
          Text(hw != null
              ? hw!.studentId != null
                  ? 'ученика'
                  : 'всего класса'
              : mark!.studentId),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: hw != null
              ? () async {
                  await hw!.delete();
                  Get.back<bool>(result: true);
                }
              : () async {
                  await mark!.delete();
                  Get.back<bool>(result: true);
                },
          child: const Text('Подтвердить'),
        ),
        ElevatedButton(
          onPressed: () {
            Get.back<bool>(result: false);
          },
          child: const Text('Отмена'),
        ),
      ],
    );
  }
}
