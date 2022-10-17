import 'package:get/get.dart';
import 'package:schoosch/controller/proxy_controller.dart';
import 'package:schoosch/model/person_model.dart';

class CompletionFlagModel {
  late final String? id;
  late final String homeworkId;
  String? completedById;
  String? confirmedById;
  DateTime? completedTime;
  DateTime? confirmedTime;
  Status? status;
  late PersonModel? _completer;
  bool _completerLoaded = false;
  late PersonModel? _confirmer;
  bool _confirmerLoaded = false;

  CompletionFlagModel.fromMap(this.id, Map<String, dynamic> map) {
    confirmedById = map['homework_id'] != null ? map['homework_id'] as String : throw 'need homework_id key in completion $id';
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

    if (map.containsKey('completedby') && map['completedby'] is Map) {
      _completer = PersonModel.fromMap((map['completedby'] as Map<String, dynamic>)['_id'] as String, map['completedby'] as Map<String, dynamic>);
      _completerLoaded = true;
    }

    if (map.containsKey('confirmedby') && map['confirmedby'] is Map) {
      _confirmer = PersonModel.fromMap((map['confirmedby'] as Map<String, dynamic>)['_id'] as String, map['confirmedby'] as Map<String, dynamic>);
      _confirmerLoaded = true;
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
    if (!_completerLoaded) {
      _completer = await Get.find<ProxyStore>().getPerson(completedById!);
      _completerLoaded = true;
    }
    return _completer!.asStudent!;
  }

  Future<TeacherModel?> get teacher async {
    if (confirmedById != null && !_confirmerLoaded) {
      _confirmer = await Get.find<ProxyStore>().getPerson(confirmedById!);
      _confirmerLoaded = true;
    }
    return _confirmer?.asTeacher;
  }

  Future<void> delete() async {
    return await Get.find<ProxyStore>().deleteCompletion(this);
  }

  Future<void> confirm(PersonModel person) async {
    return await Get.find<ProxyStore>().confirmCompletion(this, person);
  }

  Future<void> unconfirm(PersonModel person) async {
    return await Get.find<ProxyStore>().unconfirmCompletion(this, person);
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

  Map<String, dynamic> toMap({bool withId = false}) {
    var data = <String, dynamic>{
      'completedby_id': completedById,
      'completed_time': completedTime?.toIso8601String(),
      'confirmedby_id': confirmedById,
      'confirmed_time': confirmedTime?.toIso8601String(),
      'status': status,
    };
    if (withId) data['_id'] = id;
    return data;
  }

  // Future<String> save() async {
  //   Get.find<MStore>().saveCompletionFlag(this);
  // }
}

enum Status { decompleted, completed, confirmed }
