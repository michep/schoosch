import 'package:get/get.dart';
import 'package:schoosch/controller/proxy_controller.dart';
import 'package:schoosch/model/class_model.dart';
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

  StudentModel? _student;
  TeacherModel? _teacher;
  ClassModel? _aclass;

  HomeworkModel.fromMap(this.id, Map<String, dynamic> map) {
    text = map['text'] != null ? map['text'] as String : throw 'need text key in homework  $id';
    classId = map['class_id'] != null ? map['class_id'] as String : throw 'need class key in homework  $id';
    date = map['date'] != null ? DateTime.tryParse(map['date'])! : throw 'need date key in homework $id';
    todate = map['todate'] != null ? DateTime.tryParse(map['todate'])! : null;
    curriculumId = map['curriculum_id'] != null ? map['curriculum_id'] as String : throw 'need curriculum_id key in homework  $id';
    studentId = map['student_id'] != null ? map['student_id'] as String : null;
    teacherId = map['teacher_id'] != null ? map['teacher_id'] as String : throw 'need teacher_id key in homework  $id';

    if (map.containsKey('student') && map['student'] is Map) {
      _student = StudentModel.fromMap((map['student'] as Map<String, dynamic>)['_id'] as String, map['student'] as Map<String, dynamic>);
    }

    if (map.containsKey('teacher') && map['teacher'] is Map) {
      _teacher = TeacherModel.fromMap((map['teacher'] as Map<String, dynamic>)['_id'] as String, map['teacher'] as Map<String, dynamic>);
    }

    if (map.containsKey('class') && map['class'] is Map) {
      _aclass = ClassModel.fromMap((map['class'] as Map<String, dynamic>)['_id'] as String, map['class'] as Map<String, dynamic>);
    }

    if (map.containsKey('completion') && map['completion'] is List) {
      var s = (map['completion'] as List).map<CompletionFlagModel>((e) {
        var data = e as Map<String, dynamic>;
        return CompletionFlagModel.fromMap(data['_id'], data);
      }).toList();
      _completions.addAll(s);
      _completionsLoaded = true;
    }
  }

  Future<StudentModel?> get student async {
    if (studentId == null) return null;
    _student ??= (await Get.find<ProxyStore>().getPerson(studentId!)).asStudent;
    return _student!;
  }

  Future<TeacherModel> get teacher async {
    _teacher ??= (await Get.find<ProxyStore>().getPerson(teacherId)).asTeacher;
    return _teacher!;
  }

  Future<ClassModel> get aclass async {
    _aclass ??= (await Get.find<ProxyStore>().getClass(classId));
    return _aclass!;
  }

  Future<CompletionFlagModel?> getStudentCompletion(StudentModel student, {bool forceRefresh = false}) async {
    if (!_completionsLoaded || forceRefresh) {
      await getAllCompletions(forceRefresh: forceRefresh);
    }
    var compl = _completions.where((c) => c.completedById == student.id).toList();
    return compl.isEmpty ? null : compl.first;
  }

  Future<List<CompletionFlagModel>> getAllCompletions({bool forceRefresh = false}) async {
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

  Future<void> delete() async {
    await Get.find<ProxyStore>().deleteHomework(this);
  }
}
