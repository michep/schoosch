import 'dart:async';
import 'package:get/get.dart';
import 'package:isoweek/isoweek.dart' as isoweek;
import 'package:schoosch/controller/proxy_controller.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/dayschedule_model.dart';
import 'package:schoosch/model/mark_model.dart';
import 'package:schoosch/model/studyperiod_model.dart';
import 'package:schoosch/widgets/utils.dart';

enum PersonType {
  none,
  student,
  parent,
  teacher,
  observer,
  admin;

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

  String localizedName(S S) {
    switch (this) {
      case PersonType.admin:
        return S.roleAdmin;
      case PersonType.teacher:
        return S.roleTeacher;
      case PersonType.parent:
        return S.roleParent;
      case PersonType.student:
        return S.roleStudent;
      case PersonType.observer:
        return S.roleObserver;
      case PersonType.none:
        throw 'none as PersontType';
    }
  }
}

class PersonModel {
  late String? _id;
  late final String firstname;
  late final String? middlename;
  late final String lastname;
  late final String email;
  late List<PersonType> types = [];
  late final DateTime? birthday;
  late final bool viewByDays;
  late PersonType _currentType;
  ParentModel? _asParent;
  StudentModel? _asStudent;
  TeacherModel? _asTeacher;
  ObserverModel? _asObserver;
  PersonModel? up;

  String? get id => _id;

  PersonModel.fromMap(this._id, Map<String, dynamic> map, [bool recursive = true]) {
    firstname = map['firstname'] != null ? map['firstname'] as String : throw 'need firstname key in people $id';
    middlename = map['middlename'] != null ? map['middlename'] as String : null;
    lastname = map['lastname'] != null ? map['lastname'] as String : throw 'need lastname key in people $id';
    birthday = map['birthday'] != null ? DateTime.tryParse(map['birthday']) : null;
    email = map['email'] != null ? map['email'] as String : throw 'need email key in people $id';
    viewByDays = map['viewbydays'] != null ? map['viewbydays'] as bool : false;
    map['type'] != null ? types.addAll((map['type'] as List).map((e) => PersonType._parse(e))) : throw 'need type key in people $id';
    if (recursive) {
      if (types.contains(PersonType.admin)) {
        _currentType = PersonType.admin;
      }
      if (types.contains(PersonType.observer)) {
        _asObserver = ObserverModel.fromMap(id, map)..up = this;
        _currentType = PersonType.observer;
      }
      if (types.contains(PersonType.parent)) {
        _asParent = ParentModel.fromMap(id, map)..up = this;
        _currentType = PersonType.parent;
      }
      if (types.contains(PersonType.teacher)) {
        _asTeacher = TeacherModel.fromMap(id, map)..up = this;
        _currentType = PersonType.teacher;
      }
      if (types.contains(PersonType.student)) {
        _asStudent = StudentModel.fromMap(id, map)..up = this;
        _currentType = PersonType.student;
      }
    }
  }

  static PersonModel? get currentUser => Get.find<ProxyStore>().currentUser;
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

  Map<String, dynamic> toMap({bool withId = false}) {
    Map<String, dynamic> res = {};
    if (withId) res['_id'] = id;
    res['firstname'] = firstname;
    res['middlename'] = middlename;
    res['lastname'] = lastname;
    res['birthday'] = birthday?.toIso8601String();
    res['email'] = email;
    res['type'] = types.toStringList();
    if (asObserver != null) res.addAll(asObserver!.toMap());
    if (asParent != null) res.addAll(asParent!.toMap());
    return res;
  }

  Future<PersonModel> save() async {
    var id = await Get.find<ProxyStore>().savePerson(this);
    _id ??= id;
    return this;
  }

  // Future<bool> alreadyHasChat() async {
  //   return await Get.find<MStore>().checkChatExistence(this);
  // }
}

class StudentModel extends PersonModel {
  ClassModel? _studentClass;
  ParentModel? parent;
  final Map<String, List<CurriculumModel>> _curriculums = {};

  StudentModel.empty()
    : super.fromMap(null, <String, dynamic>{
        'firstname': '',
        'middlename': '',
        'lastname': '',
        'email': '',
        'type': <String>[PersonType.student._nameString],
      });

  StudentModel.fromMap(String? id, Map<String, dynamic> map) : super.fromMap(id, map, false);

  Future<ClassModel> get studentClass async {
    _studentClass ??= await Get.find<ProxyStore>().getClassByStudent(this);
    return _studentClass!;
  }

  Future<List<CurriculumModel>> curriculums(StudyPeriodModel period, {bool forceRefresh = false}) async {
    if (forceRefresh || !_curriculums.containsKey(period.id!)) {
      _curriculums[period.id!] = await Get.find<ProxyStore>().getStudentCurriculums(this, period);
    }
    return _curriculums[period.id!]!;
  }

  Future<Map<CurriculumModel, List<LessonMarkModel>>> getLessonMarksByCurriculums(List<CurriculumModel> curriculums, StudyPeriodModel period) async {
    Map<CurriculumModel, List<LessonMarkModel>> res = {};
    var marks = await Get.find<ProxyStore>().getStudentLessonMarksByCurriculums(this, curriculums, period);
    var splitted = Utils.splitLessonMarksByCurriculum(marks);
    for (var currid in splitted.keys) {
      res[await splitted[currid]![0].curriculum] = splitted[currid]!;
    }
    return res;
  }

  Future<Map<CurriculumModel, List<PeriodMarkModel?>>> getAllPeriodsMarks(
    List<CurriculumModel> curriculums,
    List<StudyPeriodModel> periods,
  ) async {
    Map<CurriculumModel, List<PeriodMarkModel?>> res = {};
    var marks = await Get.find<ProxyStore>().getStudentAllPerioddMarks(this, curriculums);
    var splitted = Utils.splitPeriodMarksListByCurriculum(marks);
    for (var currid in splitted.keys) {
      var curr = await splitted[currid]![0].curriculum;
      List<PeriodMarkModel?> vals = [];
      for (StudyPeriodModel per in periods) {
        PeriodMarkModel permark = splitted[currid]!.firstWhere(
          (element) => element.periodId == per.id,
          orElse: () => PeriodMarkModel.empty(
            '',
            _id!,
            per.id!,
          ),
        );
        if (permark.mark != 0) {
          vals.add(permark);
        } else {
          vals.add(null);
        }
      }
      res[curr] = vals;
    }
    return res;
  }
}

class TeacherModel extends PersonModel {
  final Map<isoweek.Week, List<TeacherScheduleModel>> _weekTeccherSchedules = {};
  final List<CurriculumModel> _curriculums = [];
  bool _curriculumsLoaded = false;

  TeacherModel.empty()
    : super.fromMap(null, <String, dynamic>{
        'firstname': '',
        'middlename': '',
        'lastname': '',
        'email': '',
        'type': <String>[PersonType.teacher._nameString],
      });

  TeacherModel.fromMap(String? id, Map<String, dynamic> map) : super.fromMap(id, map, false);

  Future<double> get averageRating async {
    return Get.find<ProxyStore>().getAverageTeacherRating(this);
  }

  Future<void> createRating(PersonModel user, int rating, String comment) async {
    return Get.find<ProxyStore>().saveTeacherRating(this, user, DateTime.now(), rating, comment);
  }

  Future<List<TeacherScheduleModel>> getSchedulesWeek(isoweek.Week week, {forceRefresh = false}) async {
    if (_weekTeccherSchedules[week] == null || forceRefresh) {
      _weekTeccherSchedules[week] = await Get.find<ProxyStore>().getTeacherWeekSchedule(this, week);
    }

    return _weekTeccherSchedules[week]!;
  }

  Future<List<CurriculumModel>> curriculums({bool forceRefresh = false}) async {
    if (!_curriculumsLoaded || forceRefresh) {
      _curriculums.clear();
      _curriculums.addAll(await Get.find<ProxyStore>().getTeacherCurriculums(this));
      _curriculumsLoaded = true;
    }
    return _curriculums;
  }
}

class ParentModel extends PersonModel {
  final List<String> studentIds = [];
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

  ParentModel.fromMap(String? id, Map<String, dynamic> map) : super.fromMap(id, map, false) {
    map['student_ids'] != null
        ? studentIds.addAll((map['student_ids'] as List).map<String>((e) => e as String))
        : throw 'need student_ids key in people for parent $id';
  }

  Future<List<StudentModel>> children({bool forceRefresh = false}) async {
    if (!_studentsLoaded || forceRefresh) {
      _students.clear();
      for (var id in studentIds) {
        var p = await Get.find<ProxyStore>().getPerson(id);
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
  Map<String, dynamic> toMap({bool withId = false}) {
    Map<String, dynamic> res = super.toMap(withId: withId);
    res['student_ids'] = studentIds;
    return res;
  }
}

class ObserverModel extends PersonModel {
  final List<String> classIds = [];
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

  ObserverModel.fromMap(String? id, Map<String, dynamic> map) : super.fromMap(id, map, false) {
    map['class_ids'] != null
        ? classIds.addAll((map['class_ids'] as List).map<String>((e) => e as String))
        : throw 'need class_ids key in people for observer $id';
  }

  Future<List<ClassModel>> classes({bool forceRefresh = false}) async {
    if (!_classesLoaded || forceRefresh) {
      _classes.clear();
      _classes.addAll(await Get.find<ProxyStore>().getClassesByIds(classIds));
      _classesLoaded = true;
    }
    return _classes;
  }

  @override
  Map<String, dynamic> toMap({bool withId = false}) {
    Map<String, dynamic> res = super.toMap(withId: withId);
    res['class_ids'] = classIds;
    return res;
  }
}

extension PersonTypeList on List<PersonType> {
  bool containsString(String value) {
    return contains(PersonType._parse(value));
  }

  List<String> toStringList() {
    List<String> res = [];
    forEach((e) => res.add(e._nameString));
    return res.toList();
  }
}
