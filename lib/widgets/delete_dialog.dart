import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/mark_model.dart';

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({
    Key? key,
    this.hw,
    this.mark,
    required this.context,
  }) : super(key: key);

  final HomeworkModel? hw;
  final MarkModel? mark;
  final BuildContext context;

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
            hw != null ? hw!.text : mark!.mark.toString(),
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
          onPressed: () {
            Get.back<bool>(result: false);
          },
          child: const Text('Подтвердить'),
        ),
        ElevatedButton(
          onPressed: () async {
            hw != null
                ? hw!.delete().whenComplete(() {
                    Get.back<bool>(result: true);
                  })
                : mark!.delete().whenComplete(() {
                    Get.back<bool>(result: true);
                  });
          },
          child: const Text('Отмена'),
        ),
      ],
    );
  }
}
