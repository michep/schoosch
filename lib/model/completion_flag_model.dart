import 'package:cloud_firestore/cloud_firestore.dart';

class CompletionFlagModel {
  late final String? id;
  late final String? completedById;
  late final String? confirmedById;
  late final DateTime? completedTime;
  late final DateTime? confirmedTime;
  late final Status? status;

  CompletionFlagModel.fromMap(this.id, Map<String, dynamic> map) {
    completedById = map['completed_by'] != null ? map['completed_by'] as String : null;
    confirmedById = map['confirmed_by'] != null ? map['confirmed_by'] as String : null;
    completedTime = map['completed_time'] != null ? DateTime.fromMillisecondsSinceEpoch((map['completed_time'] as Timestamp).millisecondsSinceEpoch) : null;
    confirmedTime = map['confirmed_time'] != null ? DateTime.fromMillisecondsSinceEpoch((map['confirmed_time'] as Timestamp).millisecondsSinceEpoch) : null;
    if(map['status'] != null) {
      if(map['status'].runtimeType == int) {
        status = stat(map['status'] as int);
      } 
      else {
        status = stat((map['status'] as double).round());
      }
    } else {
      throw 'NEED PURPOSE IN CHAT $id';
    }
  }

  Status stat(int i) {
    switch(i) {
      case 0:
        return Status.decompleted;
      case 1:
        return Status.completed;
      case 2:
        return Status.confirmed;
      default:
        return Status.completed; 
    }
  }
}

enum Status {decompleted, completed, confirmed}