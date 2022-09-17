import 'package:get/get.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:schoosch/controller/mongo_controller.dart';
import 'package:schoosch/model/completion_flag_model.dart';
import 'package:schoosch/model/person_model.dart';

class HomeworkModel {
  final ObjectId? id;
  late DateTime date;
  late String text;
  late ObjectId? studentId;
  late ObjectId classId;
  late ObjectId curriculumId;
  late ObjectId teacherId;

  HomeworkModel.fromMap(this.id, Map<String, dynamic> map) {
    text = map['text'] != null ? map['text'] as String : throw 'need text key in homework  $id';
    classId = map['class_id'] != null ? map['class_id'] as ObjectId : throw 'need class key in homework  $id';
    date = map['date'] != null ? map['date'] as DateTime : DateTime(2000);
    curriculumId = map['curriculum_id'] != null ? map['curriculum_id'] as ObjectId : throw 'need curriculum_id key in homework  $id';
    studentId = map['student_id'] != null ? map['student_id'] as ObjectId : null;
    teacherId = map['teacher_id'] != null ? map['teacher_id'] as ObjectId : throw 'need teacher_id key in homework  $id';
  }

  Future<StudentModel?> get student async => studentId != null ? (await Get.find<MStore>().getPerson(studentId!)).asStudent! : null;

  Future<CompletionFlagModel?> getCompletion(StudentModel student) async {
    return await Get.find<MStore>().getHomeworkCompletion(this, student);
  }

  Future<List<CompletionFlagModel>> getAllCompletions() async {
    return await Get.find<MStore>().getAllHomeworkCompletions(this);
  }

  Future<void> createCompletion(StudentModel student) async {
    return await Get.find<MStore>().createCompletion(this, student);
  }

  Future<void> deleteCompletion(StudentModel student) async {
    return await Get.find<MStore>().deleteCompletion(this, student);
  }

  Future<void> confirmCompletion(CompletionFlagModel completion, PersonModel person) async {
    return await Get.find<MStore>().confirmCompletion(this, completion, person);
  }

  Future<void> unconfirmCompletion(CompletionFlagModel completion, PersonModel person) async {
    return await Get.find<MStore>().unconfirmCompletion(this, completion, person);
  }

  // Future<void> completeCompletion(CompletionFlagModel c, TeacherModel teacher) async {
  //   return await Get.find<MStore>().completeCompletion(this, c, teacher);
  // }

  // Future<void> uncompleteCompletion(CompletionFlagModel c) async {
  //   return await Get.find<MStore>().uncompleteCompletion(this, c);
  // }

  // Future<void> confirmHomework() async {
  //   return await Get.find<MStore>().confirmHomework(this);
  // }

  // Future<void> change(String newText) async {
  //   return await Get.find<MStore>().updateHomework(this, newText);
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

  Future<ObjectId> save() {
    return Get.find<MStore>().saveHomework(this);
  }
}
