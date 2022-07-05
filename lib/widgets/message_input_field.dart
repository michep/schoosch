import 'package:flutter/material.dart';
import 'package:schoosch/model/chat_model.dart';
import 'package:schoosch/widgets/utils.dart';

class MesssageInputField extends StatefulWidget {
  final ChatModel chat;
  const MesssageInputField({
    Key? key,
    required this.chat,
  }) : super(key: key);

  @override
  State<MesssageInputField> createState() => _MesssageInputFieldState();
}

class _MesssageInputFieldState extends State<MesssageInputField> {
  TextEditingController messagecont = TextEditingController();
  bool isSending = false;

  Future<void> sendMessage() async {
    await widget.chat.addMessage({
      'message': messagecont.text,
    });
    messagecont.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: const BoxDecoration(color: Colors.black),
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: messagecont,
                decoration: const InputDecoration(
                  hintText: 'сообщение...',
                  border: InputBorder.none,
                ),
                maxLines: 3,
                minLines: 1,
              ),
            ),
            isSending
                ? Utils.progressIndicator()
                : IconButton(
                    onPressed: () async {
                      if (messagecont.text.isNotEmpty) {
                        setState(() {
                          isSending = true;
                        });
                        await sendMessage().whenComplete(() {
                          setState(() {
                            isSending = false;
                          });
                        });
                      }
                    },
                    icon: const Icon(Icons.send),
                  ),
          ],
        ),
      ),
    );
  }
}
