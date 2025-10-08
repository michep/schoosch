import 'package:schoosch/old/generated/l10n.dart';

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

  static PersonType parse(String value) {
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

  String get nameString {
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