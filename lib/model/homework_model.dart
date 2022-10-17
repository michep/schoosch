import 'package:get/get.dart';
import 'package:schoosch/controller/proxy_controller.dart';
import 'package:schoosch/model/completion_flag_model.dart';
import 'package:schoosch/model/person_model.dart';

class HomeworkModel {
  final String? id;
  late DateTime date;
  late DateTime? todate;
  late String text;
  late String? studentId;
  late String classId;
  late String curriculumId;
  late String teacherId;
  final List<CompletionFlagModel> _completions = [];
  bool _completionsLoaded = false;
  // final Mutex _completionsMutex = Mutex();

  HomeworkModel.fromMap(this.id, Map<String, dynamic> map) {
    text = map['text'] != null ? map['text'] as String : throw 'need text key in homework  $id';
    classId = map['class_id'] != null ? map['class_id'] as String : throw 'need class key in homework  $id';
    date = map['date'] != null ? DateTime.tryParse(map['date'])! : throw 'need date key in homework $id';
    todate = map['till'] != null ? DateTime.tryParse(map['till'])! : null;
    curriculumId = map['curriculum_id'] != null ? map['curriculum_id'] as String : throw 'need curriculum_id key in homework  $id';
    studentId = map['student_id'] != null ? map['student_id'] as String : null;
    teacherId = map['teacher_id'] != null ? map['teacher_id'] as String : throw 'need teacher_id key in homework  $id';

    if (map.containsKey('completion') && map['completion'] is List) {
      var s = (map['completion'] as List).map<CompletionFlagModel>((e) {
        var data = e as Map<String, dynamic>;
        return CompletionFlagModel.fromMap(data['_id'], data);
      }).toList();
      _completions.addAll(s);
      _completionsLoaded = true;
    }
  }

  Future<StudentModel?> get student async => studentId != null ? (await Get.find<ProxyStore>().getPerson(studentId!)).asStudent! : null;

  Future<CompletionFlagModel?> getCompletion(StudentModel student, {forceRefresh = false}) async {
    if (!_completionsLoaded || forceRefresh) {
      await getAllCompletions(forceRefresh: forceRefresh);
    }
    var compl = _completions.where((c) => c.completedById == student.id).toList();
    return compl.isEmpty ? null : compl.first;
  }

  Future<List<CompletionFlagModel>> getAllCompletions({forceRefresh = false}) async {
    if (!_completionsLoaded || forceRefresh) {
      _completions.clear();
      _completions.addAll(await Get.find<ProxyStore>().getAllHomeworkCompletions(this));
      _completionsLoaded = true;
    }
    return _completions;
  }

  Future<void> createCompletion(StudentModel student) async {
    return await Get.find<ProxyStore>().createCompletion(this, student);
  }

  // Future<void> deleteCompletion(CompletionFlagModel completion, StudentModel student) async {
  //   return await Get.find<ProxyStore>().deleteCompletion(this, completion, student);
  // }

  // Future<void> confirmCompletion(CompletionFlagModel completion, PersonModel person) async {
  //   return await Get.find<ProxyStore>().confirmCompletion(this, completion, person);
  // }

  // Future<void> unconfirmCompletion(CompletionFlagModel completion, PersonModel person) async {
  //   return await Get.find<ProxyStore>().unconfirmCompletion(this, completion, person);
  // }

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
      '_id': id,
      'date': date.toIso8601String(),
      'todate': todate?.toIso8601String(),
      'text': text,
      'class_id': classId,
      'student_id': studentId,
      'teacher_id': teacherId,
      'curriculum_id': curriculumId,
    };
  }

  Future<String> save() {
    return Get.find<ProxyStore>().saveHomework(this);
  }
}
