import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:schoosch/controller/mongo_controller.dart';
import 'package:schoosch/model/person_model.dart';

class CompletionFlagModel {
  late final ObjectId? id;
  late final ObjectId? completedById;
  late final ObjectId? confirmedById;
  late final DateTime? completedTime;
  late final DateTime? confirmedTime;
  late final Status? status;
  late PersonModel? _completer;
  bool completerLoaded = false;
  late PersonModel? _confirmer;
  bool confirmerLoaded = false;

  CompletionFlagModel.fromMap(this.id, Map<String, dynamic> map) {
    completedById = map['completedby_id'] != null ? map['completedby_id'] as ObjectId : null;
    confirmedById = map['confirmedby_id'] != null ? map['confirmedby_id'] as ObjectId : null;
    completedTime = map['completed_time'] != null ? map['completed_time'] as DateTime : null;
    confirmedTime = map['confirmed_time'] != null ? map['confirmed_time'] as DateTime : null;
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
      _completer = await Get.find<MStore>().getPerson(completedById!);
      completerLoaded = true;
    }
    return _completer!.asStudent!;
  }

  Future<TeacherModel?> get teacher async {
    if (confirmedById != null && !confirmerLoaded) {
      _confirmer = await Get.find<MStore>().getPerson(confirmedById!);
      confirmerLoaded = true;
    }
    return _confirmer?.asTeacher;
  }

  // Future<CompletionFlagModel?> refresh(HomeworkModel homework) async {
  //   var refr = await Get.find<FStore>().refreshCompletion(homework, this);
  //   completedTime = refr!.completedTime;
  //   confirmedById = refr.confirmedById;
  //   completedById = refr.completedById;
  //   confirmedTime = refr.confirmedTime;
  //   status = refr.status;
  //   return refr;
  // }

  // Map<String, dynamic> toMap() {
  //   return {
  //     'completed_by': completedById,
  //     'completed_time': completedTime,
  //     'confirmed_by': confirmedById,
  //     'confirmed_time': confirmedTime,
  //     'status': status,
  //   };
  // }

  // Future<String> save() async {
  //   Get.find<FStore>().saveCompletionFlag(this);
  // }
}

enum Status { decompleted, completed, confirmed }
