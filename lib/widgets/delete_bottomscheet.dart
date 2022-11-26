import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:schoosch/model/mark_model.dart';
import 'package:schoosch/model/person_model.dart';

class DeleteBottomSheet extends StatelessWidget {
  final MarkModel mark;
  const DeleteBottomSheet({
    Key? key,
    required this.person,
    required this.mark,
  }) : super(key: key);

  final StudentModel person;

  @override
  Widget build(BuildContext context) {
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
          children: [
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
              mark.mark.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const Text('Для:'),
            Text(
              person.fullName,
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
                      await mark.delete();
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
          ],
        ),
      ),
    );
  }
}