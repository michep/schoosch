import 'package:get/get.dart';
import 'package:schoosch/controller/proxy_controller.dart';
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
    completedById = map['completedby_id'] != null ? map['completedby_id'] as String : null;
    confirmedById = map['confirmedby_id'] != null ? map['confirmedby_id'] as String : null;
    completedTime = map['completed_time'] != null ? DateTime.tryParse(map['completed_time']) : null;
    confirmedTime = map['confirmed_time'] != null ? DateTime.tryParse(map['confirmed_time']) : null;
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
      _completer = await Get.find<ProxyStore>().getPerson(completedById!);
      completerLoaded = true;
    }
    return _completer!.asStudent!;
  }

  Future<TeacherModel?> get teacher async {
    if (confirmedById != null && !confirmerLoaded) {
      _confirmer = await Get.find<ProxyStore>().getPerson(confirmedById!);
      confirmerLoaded = true;
    }
    return _confirmer?.asTeacher;
  }

  // Future<CompletionFlagModel?> refresh(HomeworkModel homework) async {
  //   var refr = await Get.find<MStore>().refreshCompletion(homework, this);
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
  //   Get.find<MStore>().saveCompletionFlag(this);
  // }
}

enum Status { decompleted, completed, confirmed }
