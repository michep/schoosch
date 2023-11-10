import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/message_model.dart';

class MessageUnit extends StatelessWidget {
  final MessageModel message;
  const MessageUnit({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.82,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: message.sentByMe ? const Radius.circular(12) : const Radius.circular(0),
            topRight: message.sentByMe ? const Radius.circular(0) : const Radius.circular(12),
            bottomLeft: const Radius.circular(12),
            bottomRight: const Radius.circular(12),
          ),
          color: Get.theme.colorScheme.primary,
        ),
        child: Text(message.message!),
      ),
    );
  }
}
