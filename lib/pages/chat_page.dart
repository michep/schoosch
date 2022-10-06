// import 'package:flutter/material.dart';
// import 'package:schoosch/model/chat_model.dart';
// import 'package:schoosch/model/message_model.dart';
// import 'package:schoosch/widgets/message_input_field.dart';
// import 'package:schoosch/widgets/message_unit.dart';
// import 'package:schoosch/widgets/utils.dart';

// class ChatPage extends StatefulWidget {
//   final ChatModel chat;
//   const ChatPage({Key? key, required this.chat}) : super(key: key);

//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Column(
//         children: [
//           FutureBuilder<List<MessageModel>>(
//             future: widget.chat.getAllMessages(),
//             builder: (context, snapshot) {
//               if (!snapshot.hasData) {
//                 return Expanded(
//                   child: Center(
//                     child: Utils.progressIndicator(),
//                   ),
//                 );
//               }
//               if (snapshot.data!.isEmpty) {
//                 return const Expanded(
//                   child: Center(
//                     child: Text('нет сообщений.'),
//                   ),
//                 );
//               }
//               return Expanded(
//                 child: ListView.builder(
//                   reverse: true,
//                   itemBuilder: (context, index) {
//                     return MessageUnit(
//                       key: ValueKey(snapshot.data![index].id!),
//                       message: snapshot.data![index],
//                     );
//                   },
//                   itemCount: snapshot.data!.length,
//                 ),
//               );
//             },
//           ),
//           MesssageInputField(chat: widget.chat),
//         ],
//       ),
//     );
//   }
// }
