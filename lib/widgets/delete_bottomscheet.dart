import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/mark_model.dart';
import 'package:schoosch/model/person_model.dart';

class DeleteBottomSheet extends StatelessWidget {
  // final MarkModel mark;
  final dynamic item;
  final StudentModel? person;
  final bool canDelete;
  const DeleteBottomSheet({
    Key? key,
    required this.person,
    required this.item,
    this.canDelete = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String text = '';
    if(item is MarkModel) {
      text = (item as MarkModel).mark.toString();
    } else if(item is HomeworkModel) {
      text = (item as HomeworkModel).text;
    }
    return BottomSheet(
      onClosing: () {},
      builder: (context) => Padding(
        padding: const EdgeInsets.only(
          top: 20,
          right: 20,
          left: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: canDelete ? [
            const Text(
              'Точно хотите удалить?',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text('Оценку:'),
            Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const Text('Для:'),
            Text(
              person != null ? person!.fullName : 'Класса',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // await mark.delete();
                      if(item is MarkModel) {
                        await (item as MarkModel).delete();
                      } else if(item is HomeworkModel) {
                        await (item as HomeworkModel).delete();
                      }
                      Get.back<bool>(result: true);
                    },
                    child: const Text('Подтвердить'),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.back<bool>(result: false);
                    },
                    child: const Text('Отмена'),
                  ),
                ],
              ),
            ),
          ] : [
            const Text(
              'Невозможно удалить.',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            // const Text('Оценку:'),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 10,),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                          onPressed: () {
                            Get.back<bool>(result: false);
                          },
                          child: const Text('Отмена'),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}