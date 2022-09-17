import 'package:mongo_dart/mongo_dart.dart';
import 'package:schoosch/model/person_model.dart';

class MessageModel {
  late final ObjectId? id;
  late final String? message;
  late final ObjectId? sentById;
  late final DateTime? timeSent;

  MessageModel.fromMap(this.id, Map<String, dynamic> map) {
    message = map['message'] != null ? map['message'] as String : throw '';
    sentById = map['sentby_id'] != null ? map['sentby_id'] as ObjectId : throw '';
    timeSent = map['timestamp'] != null ? map['timestamp'] as DateTime : throw '';
  }

  bool get sentByMe => sentById! == PersonModel.currentUser!.id;
}
