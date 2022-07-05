import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/model/chat_model.dart';
import 'package:schoosch/pages/chat_page.dart';
import 'package:schoosch/widgets/utils.dart';

class AllChatsPage extends StatefulWidget {
  const AllChatsPage({Key? key}) : super(key: key);

  @override
  State<AllChatsPage> createState() => _AllChatsPageState();
}

class _AllChatsPageState extends State<AllChatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('чаты'),
      ),
      body: StreamBuilder<List<ChatModel>>(
        stream: Get.find<FStore>().getUserChatRooms(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Utils.progressIndicator(),
            );
          }
          if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text('нет активных чатов'),
            );
          }
          return ListView.builder(
            itemBuilder: (context, index) {
              var item = snapshot.data![index];
              return ListTile(
                title: Text(item.other.fullName),
                onTap: () {
                  Get.to(
                    () => ChatPage(chat: item),
                  );
                },
              );
            },
            itemCount: snapshot.data!.length,
          );
        },
      ),
    );
  }
}
