import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/firestore_controller.dart';
import 'package:schoosch/model/completion_flag_model.dart';
import 'package:schoosch/model/person_model.dart';

class HomeworkModel {
  final String? id;
  late DateTime date;
  late String text;
  late String? studentId;
  late String classId;
  late String curriculumId;
  late String teacherId;

  HomeworkModel.fromMap(this.id, Map<String, dynamic> map) {
    text = map['text'] != null ? map['text'] as String : throw 'need text key in homework  $id';
    classId = map['class_id'] != null ? map['class_id'] as String : throw 'need class key in homework  $id';
    date = map['date'] != null ? DateTime.fromMillisecondsSinceEpoch((map['date'] as Timestamp).millisecondsSinceEpoch) : DateTime(2000);
    curriculumId = map['curriculum_id'] != null ? map['curriculum_id'] as String : throw 'need curriculum_id key in homework  $id';
    studentId = map['student_id'] != null ? map['student_id'] as String : null;
    teacherId = map['teacher_id'] != null ? map['teacher_id'] as String : throw 'need teacher_id key in homework  $id';
  }

  Future<StudentModel?> get student async => studentId != null ? (await Get.find<FStore>().getPerson(studentId!)).asStudent! : null;

  Future<CompletionFlagModel?> getCompletion(StudentModel student) async {
    return await Get.find<FStore>().getHomeworkCompletion(this, student);
  }

  Future<List<CompletionFlagModel>> getAllCompletions() async {
    return await Get.find<FStore>().getAllHomeworkCompletions(this);
  }

  Future<String> createCompletion(StudentModel student) async {
    return await Get.find<FStore>().createCompletion(this, student);
  }

  Future<void> deleteCompletion(StudentModel student) async {
    return await Get.find<FStore>().deleteCompletion(this, student);
  }

  Future<void> confirmCompletion(CompletionFlagModel completion, PersonModel person) async {
    return await Get.find<FStore>().confirmCompletion(this, completion, person);
  }

  Future<void> unconfirmCompletion(CompletionFlagModel completion, PersonModel person) async {
    return await Get.find<FStore>().unconfirmCompletion(this, completion, person);
  }

  // Future<void> completeCompletion(CompletionFlagModel c, TeacherModel teacher) async {
  //   return await Get.find<FStore>().completeCompletion(this, c, teacher);
  // }

  // Future<void> uncompleteCompletion(CompletionFlagModel c) async {
  //   return await Get.find<FStore>().uncompleteCompletion(this, c);
  // }

  // Future<void> confirmHomework() async {
  //   return await Get.find<FStore>().confirmHomework(this);
  // }

  // Future<void> change(String newText) async {
  //   return await Get.find<FStore>().updateHomework(this, newText);
  // }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'text': text,
      'class_id': classId,
      'student_id': studentId,
      'teacher_id': teacherId,
      'curriculum_id': curriculumId,
    };
  }

  Future<String> save() {
    return Get.find<FStore>().saveHomework(this);
  }
}
