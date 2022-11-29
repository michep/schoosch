import "package:flutter/material.dart";
import 'package:get/get.dart';

class DeleteBottomSheet extends StatelessWidget {
  // final MarkModel mark;
  final bool canDelete;
  final Widget child;
  
  const DeleteBottomSheet({
    Key? key,
    required this.child,
    this.canDelete = true,
  }) : super(key: key);

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
            child,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // await mark.delete();
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 10,),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                          onPressed: () {
                            Get.back<bool>(result: false);
                          },
                          child: const Text('Назад'),
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