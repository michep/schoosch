import 'package:get/get.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/model/message_model.dart';
import 'package:schoosch/model/person_model.dart';

class ChatModel {
  late final String? id;
  late final List<PersonModel>? users;

  ChatModel.fromMap(this.id, this.users);

  Stream<List<MessageModel>> getAllMessages() {
    return Get.find<FStore>().getChatroomMessages(this);
  }

  Future<void> addMessage(Map<String, dynamic> map) async {
    Get.find<FStore>().addMessage(this, map);
  }

  PersonModel get other => users!
      .where(
        (element) => element.id != Get.find<FStore>().currentUser!.id,
      )
      .toList()[0];
}
