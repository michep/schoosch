import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/mongo_controller.dart';
import 'package:schoosch/model/chat_model.dart';
import 'package:schoosch/pages/chat_page.dart';
import 'package:schoosch/pages/find_chat_page.dart';
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
      body: FutureBuilder<List<ChatModel>>(
        future: Get.find<MStore>().getUserChatRooms(),
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
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Get.to(
            () => const FindChat(),
          );
        },
      ),
    );
  }
}
