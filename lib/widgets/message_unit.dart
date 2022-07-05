import 'package:flutter/material.dart';
import 'package:schoosch/model/message_model.dart';

class MessageUnit extends StatelessWidget {
  final MessageModel message;
  const MessageUnit({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(message.message!);
  }
}
