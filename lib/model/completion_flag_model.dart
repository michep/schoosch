import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/model/homework_model.dart';
import 'package:schoosch/model/person_model.dart';

class CompletionFlagModel {
  late final String? id;
  late final String? completedById;
  late final String? confirmedById;
  late final DateTime? completedTime;
  late final DateTime? confirmedTime;
  late final Status? status;
  late PersonModel? _completer;
  bool completerLoaded = false;
  late PersonModel? _confirmer;
  bool confirmerLoaded = false;

  CompletionFlagModel.fromMap(this.id, Map<String, dynamic> map) {
    completedById = map['completed_by'] != null ? map['completed_by'] as String : null;
    confirmedById = map['confirmed_by'] != null ? map['confirmed_by'] as String : null;
    completedTime = map['completed_time'] != null ? DateTime.fromMillisecondsSinceEpoch((map['completed_time'] as Timestamp).millisecondsSinceEpoch) : null;
    confirmedTime = map['confirmed_time'] != null ? DateTime.fromMillisecondsSinceEpoch((map['confirmed_time'] as Timestamp).millisecondsSinceEpoch) : null;
    if (map['status'] != null) {
      if (map['status'].runtimeType == int) {
        status = stat(map['status'] as int);
      } else {
        status = stat((map['status'] as double).round());
      }
    } else {
      throw 'NEED PURPOSE IN CHAT $id';
    }
  }

  Status stat(int i) {
    switch (i) {
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

  Future<StudentModel> get student async {
    if (!completerLoaded) {
      _completer = await Get.find<FStore>().getPerson(completedById!);
      completerLoaded = true;
    }
    return _completer!.asStudent!;
  }

  Future<TeacherModel?> get teacher async {
    if (confirmedById != null && !confirmerLoaded) {
      _confirmer = await Get.find<FStore>().getPerson(confirmedById!);
      confirmerLoaded = true;
    }
    return _confirmer?.asTeacher;
  }

  Future<CompletionFlagModel?> refresh(HomeworkModel homework) async {
    var refr = await Get.find<FStore>().refreshCompletion(homework, this);
    // completedTime = refr!.completedTime;
    // confirmedById = refr.confirmedById;
    // completedById = refr.completedById;
    // confirmedTime = refr.confirmedTime;
    // status = refr.status;
    return refr;
  }
}

enum Status { decompleted, completed, confirmed }
