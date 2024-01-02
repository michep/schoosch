import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/main.dart';

class DisconnectedPage extends StatelessWidget {
  const DisconnectedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          //TODO: add a gif or an image
          const Text('Кажется, отсутствует подключение к сети.'),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
            onPressed: () {
              Get.off(
                () => const SchooschApp(),
              );
            },
            child: const Text('перезагрузить'),
          ),
        ],
      ),
    );
  }
}
