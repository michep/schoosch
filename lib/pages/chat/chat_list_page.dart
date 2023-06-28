import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/socket_controller.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => Get.find<SocketController>().send('тырыпыры'),
              child: Text('тырыпыры'),
            ),
            ElevatedButton(
              onPressed: Get.find<SocketController>().close,
              child: Text('CLOSE'),
            ),
          ],
        ),
      ),
    );
  }
}
