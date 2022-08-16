import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/model/completion_flag_model.dart';
import 'package:schoosch/model/person_model.dart';

class HomeworkModel {
  final String? id;
  late final String text;
  late final String? _studentId;
  late final List<String> usersChecked;
  late final String classId;
  // late final String _curriculumId;
  // late final String _teacherId;
  late final DateTime date;

  HomeworkModel.fromMap(this.id, Map<String, dynamic> map) {
    text = map['text'] != null ? map['text'] as String : throw 'need text key in homework  $id';
    classId = map['class_id'] != null ? map['class_id'] as String : throw 'need class key in homework  $id';
    date = map['date'] != null ? DateTime.fromMillisecondsSinceEpoch((map['date'] as Timestamp).millisecondsSinceEpoch) : DateTime(2000);
    // _curriculumId = map['curriculum_id'] != null ? map['curriculum_id'] as String : throw 'need curriculum_id key in homework  $_id';
    _studentId = map['student_id'] != null ? map['student_id'] as String : null;
    usersChecked = map['checked_users'] != null ? (map['checked_users'] as List<dynamic>).map((e) => e.toString()).toList() : [];

    // _teacherId = map['teacher_id'] != null ? map['teacher_id'] as String : throw 'need teacher_id key in homework  $_id';
  }

  String? get studentId => _studentId;
  Future<StudentModel?> get student async => _studentId != null ? (await Get.find<FStore>().getPerson(_studentId!)).asStudent! : null;

  // bool get isChecked => usersChecked.contains(Get.find<FStore>().currentUser!.id);

  // Future<void> updateHomeworkCheck() async {
  //   return await Get.find<FStore>().updateHomeworkChecked(this);
  // }

  Future<CompletionFlagModel?> getCompletion(StudentModel student) async {
    return await Get.find<FStore>().getHomeworkCompletion(this, student);
  }

  // Future<CompletionFlagModel?> hasMeCompletion() async {
  //   return await Get.find<FStore>().hasMyCompletion(this);
  // }

  Future<void> createCompletion() async {
    return await Get.find<FStore>().createCompletion(this);
  }

  Future<void> completeCompletion(CompletionFlagModel c) async {
    return await Get.find<FStore>().completeCompletion(this, c);
  }

  Future<void> uncompleteCompletion(CompletionFlagModel c) async {
    return await Get.find<FStore>().uncompleteCompletion(this, c);
  }

  Future<List<CompletionFlagModel>> getAllCompletions() async {
    return await Get.find<FStore>().getAllHomeworkCompletions(this);
  }

  Future<void> confirmCompletion(CompletionFlagModel completion) async {
    return await Get.find<FStore>().confirmCompletion(this, completion);
  }

  Future<void> unconfirmCompletion(CompletionFlagModel completion) async {
    return await Get.find<FStore>().unconfirmCompletion(this, completion);
  }

  Future<void> confirmHomework() async {
    return await Get.find<FStore>().confirmHomework(this);
  }

  Future<void> change(String newText) async {
    return await Get.find<FStore>().updateHomework(this, newText);
  }
}
