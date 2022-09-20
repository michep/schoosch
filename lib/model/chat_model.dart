import 'package:get/get.dart';
import 'package:schoosch/controller/mongo_controller.dart';
import 'package:schoosch/model/message_model.dart';
import 'package:schoosch/model/person_model.dart';

class ChatModel {
  late final String? id;
  late final List<PersonModel>? users;

  ChatModel.fromMap(this.id, this.users);

  Future<List<MessageModel>> getAllMessages() {
    return Get.find<MStore>().getChatroomMessages(this);
  }

  Future<void> addMessage(Map<String, dynamic> map) async {
    Get.find<MStore>().addMessage(this, map);
  }

  PersonModel get other => users!
      .where(
        (element) => element.id != Get.find<MStore>().currentUser!.id,
      )
      .toList()[0];
}
