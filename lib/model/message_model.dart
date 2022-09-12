import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/firestore_controller.dart';

class MessageModel {
  late final String? id;
  late final String? message;
  late final String? sentById;
  late final DateTime? timeSent;

  MessageModel.fromMap(this.id, Map<String, dynamic> map) {
    message = map['message'] != null ? map['message'] as String : throw '';
    sentById = map['sent_by'] != null ? map['sent_by'] as String : throw '';
    timeSent = map['timestamp'] != null ? DateTime.fromMillisecondsSinceEpoch((map['timestamp'] as Timestamp).millisecondsSinceEpoch) : throw '';
  }

  bool get sentByMe => sentById! == Get.find<FStore>().currentUser!.id;
}
