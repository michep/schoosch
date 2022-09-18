import 'dart:async';
import 'package:get/get.dart';
import 'package:isoweek/isoweek.dart' as isoweek;
import 'package:mongo_dart/mongo_dart.dart';
import 'package:mutex/mutex.dart';
import 'package:schoosch/controller/mongo_controller.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/dayschedule_model.dart';
import 'package:schoosch/model/mark_model.dart';

enum PersonType {
  none,
  student,
  parent,
  teacher,
  observer,
  admin,
}

extension PersonTypeExt on PersonType {
  static const _admin = 'admin';
  static const _teacher = 'teacher';
  static const _parent = 'parent';
  static const _student = 'student';
  static const _observer = 'observer';

  static PersonType _parse(String value) {
    switch (value) {
      case _admin:
        return PersonType.admin;
      case _teacher:
        return PersonType.teacher;
      case _parent:
        return PersonType.parent;
      case _student:
        return PersonType.student;
      case _observer:
        return PersonType.observer;
      default:
        return PersonType.none;
    }
  }

  String get _nameString {
    switch (this) {
      case PersonType.admin:
        return _admin;
      case PersonType.teacher:
        return _teacher;
      case PersonType.parent:
        return _parent;
      case PersonType.student:
        return _student;
      case PersonType.observer:
        return _observer;
      case PersonType.none:
        throw 'none as PersontType';
    }
  }
}

extension PersonTypeList on List<PersonType> {
  bool containsString(String value) {
    return contains(PersonTypeExt._parse(value));
  }

  List<String> toStringList() {
    List<String> res = [];
    forEach((e) => res.add(e._nameString));
    return res.toList();
  }
}

class PersonModel {
  late ObjectId? _id;
  late final String firstname;
  late final String? middlename;
  late final String lastname;
  late final String email;
  late List<PersonType> types = [];
  late final DateTime? birthday;
  late PersonType _currentType;
  ParentModel? _asParent;
  StudentModel? _asStudent;
  TeacherModel? _asTeacher;
  ObserverModel? _asObserver;
  PersonModel? up;

  ObjectId? get id => _id;

  PersonModel.fromMap(this._id, Map<String, dynamic> map, [bool recursive = true]) {
    firstname = map['firstname'] != null ? map['firstname'] as String : throw 'need firstname key in people $id';
    middlename = map['middlename'] != null ? map['middlename'] as String : null;
    lastname = map['lastname'] != null ? map['lastname'] as String : throw 'need lastname key in people $id';
    birthday = map['birthday'] != null ? map['birthday'] as DateTime : null;
    email = map['email'] != null ? map['email'] as String : throw 'need email key in people $id';
    map['type'] != null ? types.addAll((map['type'] as List<dynamic>).map((e) => PersonTypeExt._parse(e))) : throw 'need type key in people $id';
    if (recursive) {
      for (var t in types) {
        switch (t) {
          case PersonType.parent:
            _asParent = ParentModel.fromMap(id, map)..up = this;
            _currentType = t;
            break;
          case PersonType.student:
            _asStudent = StudentModel.fromMap(id, map)..up = this;
            _currentType = t;
            break;
          case PersonType.teacher:
            _asTeacher = TeacherModel.fromMap(id, map)..up = this;
            _currentType = t;
            break;
          case PersonType.observer:
            _asObserver = ObserverModel.fromMap(id, map)..up = this;
            _currentType = t;
            break;
          case PersonType.admin:
            _currentType = t;
            break;
          default:
            throw 'incorrect type in people $id';
        }
      }
    }
  }

  static PersonModel? get currentUser => Get.find<MStore>().currentUser;
  static StudentModel? get currentStudent => currentUser?._asStudent;
  static TeacherModel? get currentTeacher => currentUser?._asTeacher;
  static ParentModel? get currentParent => currentUser?._asParent;
  static ObserverModel? get currentObserver => currentUser?._asObserver;

  StudentModel? get asStudent => _asStudent;
  TeacherModel? get asTeacher => _asTeacher;
  ParentModel? get asParent => _asParent;
  ObserverModel? get asObserver => _asObserver;

  PersonType get currentType => _currentType;
  void setType(PersonType val) => _currentType = val;

  @override
  operator ==(other) {
    if (other is PersonModel) {
      return id == other.id;
    }
    return this == other;
  }

  @override
  int get hashCode => Object.hash(id, '');

  @override
  String toString() {
    return fullName;
  }

  String get fullName => middlename != null ? '$lastname $firstname $middlename' : '$lastname $firstname';
  String get abbreviatedName => middlename != null ? '$lastname ${firstname[0]}. ${middlename![0]}.' : '$lastname ${firstname[0]}.';

  Map<String, dynamic> toMap() {
    Map<String, dynamic> res = {};
    res['firstname'] = firstname;
    res['middlename'] = middlename;
    res['lastname'] = lastname;
    res['birthday'] = birthday;
    res['email'] = email;
    res['type'] = types.toStringList();
    return res;
  }

  Future<PersonModel> save() async {
    var id = await Get.find<MStore>().savePerson(this);
    _id ??= id;
    return this;
  }

  Future<bool> alreadyHasChat() async {
    return await Get.find<MStore>().checkChatExistence(this);
  }
}

class StudentModel extends PersonModel {
  ClassModel? _studentClass;
  ParentModel? parent;
  bool _studentClassLoaded = false;
  final Mutex _studentClassMutex = Mutex();
  final List<CurriculumModel> _curriculums = [];
  bool _curriculumsLoaded = false;
  final Mutex _curriculumsMutex = Mutex();

  StudentModel.empty()
      : super.fromMap(null, <String, dynamic>{
          'firstname': '',
          'middlename': '',
          'lastname': '',
          'email': '',
          'type': <String>[PersonType.student._nameString],
        });

  StudentModel.fromMap(ObjectId? id, Map<String, dynamic> map) : super.fromMap(id, map, false);

  Future<ClassModel?> get studentClass async {
    await _studentClassMutex.acquire();
    if (!_studentClassLoaded) {
      _studentClass = await Get.find<MStore>().getClassForStudent(this);
      _studentClassLoaded = true;
    }
    _studentClassMutex.release();
    return _studentClass!;
  }

  Future<List<CurriculumModel>> curriculums({bool forceRefresh = false}) async {
    await _curriculumsMutex.acquire();
    if (!_curriculumsLoaded || forceRefresh) {
      _curriculums.clear();
      _curriculums.addAll(await Get.find<MStore>().getStudentCurriculums(this));
      _curriculumsLoaded = true;
    }
    _curriculumsMutex.release();
    return _curriculums;
  }

  Future<List<MarkModel>> curriculumMarks(CurriculumModel cur) async {
    return Get.find<MStore>().getStudentCurriculumMarks(this, cur);
  }

  Future<List<MarkModel>> curriculumTeacherMarks(CurriculumModel cur, TeacherModel teacher) async {
    return Get.find<MStore>().getStudentCurriculumTeacherMarks(this, cur, teacher);
  }
}

class TeacherModel extends PersonModel {
  final Map<isoweek.Week, List<TeacherScheduleModel>> _schedule = {};
  final List<CurriculumModel> _curriculums = [];
  bool _curriculumsLoaded = false;
  final Mutex _curriculumsMutex = Mutex();

  TeacherModel.empty()
      : super.fromMap(null, <String, dynamic>{
          'firstname': '',
          'middlename': '',
          'lastname': '',
          'email': '',
          'type': <String>[PersonType.teacher._nameString],
        });

  TeacherModel.fromMap(ObjectId? id, Map<String, dynamic> map) : super.fromMap(id, map, false);

  Future<double> get averageRating async {
    return Get.find<MStore>().getAverageTeacherRating(this);
  }

  Future<void> createRating(PersonModel user, int rating, String comment) async {
    return Get.find<MStore>().saveTeacherRating(this, user, DateTime.now(), rating, comment);
  }

  Future<List<TeacherScheduleModel>> getSchedulesWeek(isoweek.Week week) async {
    return _schedule[week] ??= await Get.find<MStore>().getTeacherWeekSchedule(this, week);
  }

  Future<List<CurriculumModel>> curriculums({bool forceRefresh = false}) async {
    await _curriculumsMutex.acquire();
    if (!_curriculumsLoaded || forceRefresh) {
      _curriculums.clear();
      _curriculums.addAll(await Get.find<MStore>().getTeacherCurriculums(this));
      _curriculumsLoaded = true;
    }
    _curriculumsMutex.release();
    return _curriculums;
  }

  // Future<void> confirmCompletion(HomeworkModel hw, CompletionFlagModel completion) async {
  //   return await Get.find<MStore>().confirmCompletion(hw, completion);
  // }
}

class ParentModel extends PersonModel {
  final List<ObjectId> studentIds = [];
  final List<StudentModel> _students = [];
  bool _studentsLoaded = false;
  StudentModel? _selectedChild;

  ParentModel.empty()
      : super.fromMap(null, <String, dynamic>{
          'firstname': '',
          'middlename': '',
          'lastname': '',
          'email': '',
          'type': <String>[PersonType.parent._nameString],
          'student_ids': <String>[],
        });

  ParentModel.fromMap(ObjectId? id, Map<String, dynamic> map) : super.fromMap(id, map, false) {
    map['student_ids'] != null
        ? studentIds.addAll((map['student_ids'] as List<dynamic>).map((e) => e as ObjectId))
        : throw 'need student_ids key in people for parent $id';
  }

  Future<List<StudentModel>> children({forceRefresh = false}) async {
    if (!_studentsLoaded || forceRefresh) {
      _students.clear();
      var store = Get.find<MStore>();
      for (var id in studentIds) {
        var p = await store.getPerson(id);
        if (p.types.contains(PersonType.student)) {
          p.asStudent!.parent = this;
          _students.add(p.asStudent!);
        }
      }
      _studentsLoaded = true;
    }
    return _students;
  }

  Future<StudentModel> get currentChild async {
    return _selectedChild ??= (await children())[0];
  }

  void setChild(StudentModel val) => _selectedChild = val;

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> res = super.toMap();
    res['student_ids'] = studentIds;
    return res;
  }
}

class ObserverModel extends PersonModel {
  final List<ObjectId> classIds = [];
  final List<ClassModel> _classes = [];
  bool _classesLoaded = false;

  ObserverModel.empty()
      : super.fromMap(null, <String, dynamic>{
          'firstname': '',
          'middlename': '',
          'lastname': '',
          'email': '',
          'type': <String>[PersonType.observer._nameString],
        });

  ObserverModel.fromMap(ObjectId? id, Map<String, dynamic> map) : super.fromMap(id, map, false) {
    map['class_ids'] != null
        ? classIds.addAll((map['class_ids'] as List<dynamic>).map((e) => e as ObjectId))
        : throw 'need class_ids key in people for observer $id';
  }

  Future<List<ClassModel>> classes({forceRefresh = false}) async {
    if (!_classesLoaded || forceRefresh) {
      _classes.clear();
      var store = Get.find<MStore>();
      for (var id in classIds) {
        var cl = await store.getClass(id);
        _classes.add(cl);
        _classesLoaded = true;
      }
    }
    return _classes;
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> res = super.toMap();
    res['class_ids'] = classIds;
    return res;
  }
}
