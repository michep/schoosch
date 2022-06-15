// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Schoosch is school schedule app`
  String get appTiile {
    return Intl.message(
      'Schoosch is school schedule app',
      name: 'appTiile',
      desc: '',
      args: [],
    );
  }

  /// `Schoosch`
  String get appBarTitle {
    return Intl.message(
      'Schoosch',
      name: 'appBarTitle',
      desc: '',
      args: [],
    );
  }

  /// `Save changes`
  String get saveChanges {
    return Intl.message(
      'Save changes',
      name: 'saveChanges',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Edit Institution`
  String get editInstitution {
    return Intl.message(
      'Edit Institution',
      name: 'editInstitution',
      desc: '',
      args: [],
    );
  }

  /// `Student Classes Schedules Info`
  String get weekSchedule {
    return Intl.message(
      'Student Classes Schedules Info',
      name: 'weekSchedule',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get className {
    return Intl.message(
      'Name',
      name: 'className',
      desc: '',
      args: [],
    );
  }

  /// `Grade`
  String get classGrade {
    return Intl.message(
      'Grade',
      name: 'classGrade',
      desc: '',
      args: [],
    );
  }

  /// `Teacher`
  String get classMaster {
    return Intl.message(
      'Teacher',
      name: 'classMaster',
      desc: '',
      args: [],
    );
  }

  /// `Schedule`
  String get classSchedule {
    return Intl.message(
      'Schedule',
      name: 'classSchedule',
      desc: '',
      args: [],
    );
  }

  /// `Students`
  String get classStudents {
    return Intl.message(
      'Students',
      name: 'classStudents',
      desc: '',
      args: [],
    );
  }

  /// `Classes`
  String get classList {
    return Intl.message(
      'Classes',
      name: 'classList',
      desc: '',
      args: [],
    );
  }

  /// `New Class`
  String get newClass {
    return Intl.message(
      'New Class',
      name: 'newClass',
      desc: '',
      args: [],
    );
  }

  /// `Curriculum`
  String get curriculumName {
    return Intl.message(
      'Curriculum',
      name: 'curriculumName',
      desc: '',
      args: [],
    );
  }

  /// `Alias`
  String get curriculumAlternateName {
    return Intl.message(
      'Alias',
      name: 'curriculumAlternateName',
      desc: '',
      args: [],
    );
  }

  /// `Teacher`
  String get curriculumTeacher {
    return Intl.message(
      'Teacher',
      name: 'curriculumTeacher',
      desc: '',
      args: [],
    );
  }

  /// `Students`
  String get curriculumStudents {
    return Intl.message(
      'Students',
      name: 'curriculumStudents',
      desc: '',
      args: [],
    );
  }

  /// `Curriculums`
  String get curriculumList {
    return Intl.message(
      'Curriculums',
      name: 'curriculumList',
      desc: '',
      args: [],
    );
  }

  /// `New Curriculum`
  String get newCurriculum {
    return Intl.message(
      'New Curriculum',
      name: 'newCurriculum',
      desc: '',
      args: [],
    );
  }

  /// `Lessons Schedule`
  String get dayScheduleList {
    return Intl.message(
      'Lessons Schedule',
      name: 'dayScheduleList',
      desc: '',
      args: [],
    );
  }

  /// `{classname} schedule`
  String classScheduleName(Object classname) {
    return Intl.message(
      '$classname schedule',
      name: 'classScheduleName',
      desc: '',
      args: [classname],
    );
  }

  /// `Venue`
  String get venueName {
    return Intl.message(
      'Venue',
      name: 'venueName',
      desc: '',
      args: [],
    );
  }

  /// `Venues`
  String get venueList {
    return Intl.message(
      'Venues',
      name: 'venueList',
      desc: '',
      args: [],
    );
  }

  /// `New Vanue`
  String get newVenue {
    return Intl.message(
      'New Vanue',
      name: 'newVenue',
      desc: '',
      args: [],
    );
  }

  /// `Lesson`
  String get lessonName {
    return Intl.message(
      'Lesson',
      name: 'lessonName',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get personName {
    return Intl.message(
      'Name',
      name: 'personName',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get personFirstName {
    return Intl.message(
      'First Name',
      name: 'personFirstName',
      desc: '',
      args: [],
    );
  }

  /// `Middle Name`
  String get personMiddleName {
    return Intl.message(
      'Middle Name',
      name: 'personMiddleName',
      desc: '',
      args: [],
    );
  }

  /// `Last Name`
  String get personLastName {
    return Intl.message(
      'Last Name',
      name: 'personLastName',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get personEmail {
    return Intl.message(
      'Email',
      name: 'personEmail',
      desc: '',
      args: [],
    );
  }

  /// `Birthday`
  String get personBirthday {
    return Intl.message(
      'Birthday',
      name: 'personBirthday',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get personType {
    return Intl.message(
      'Type',
      name: 'personType',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get personTypeAll {
    return Intl.message(
      'All',
      name: 'personTypeAll',
      desc: '',
      args: [],
    );
  }

  /// `Student`
  String get personTypeStudent {
    return Intl.message(
      'Student',
      name: 'personTypeStudent',
      desc: '',
      args: [],
    );
  }

  /// `Teacher`
  String get personTypeTeacher {
    return Intl.message(
      'Teacher',
      name: 'personTypeTeacher',
      desc: '',
      args: [],
    );
  }

  /// `Parent / Observer`
  String get personTypeParent {
    return Intl.message(
      'Parent / Observer',
      name: 'personTypeParent',
      desc: '',
      args: [],
    );
  }

  /// `Admin`
  String get personTypeAdmin {
    return Intl.message(
      'Admin',
      name: 'personTypeAdmin',
      desc: '',
      args: [],
    );
  }

  /// `Related Students`
  String get personRelatedStudents {
    return Intl.message(
      'Related Students',
      name: 'personRelatedStudents',
      desc: '',
      args: [],
    );
  }

  /// `Student, Teachers and other`
  String get peopleList {
    return Intl.message(
      'Student, Teachers and other',
      name: 'peopleList',
      desc: '',
      args: [],
    );
  }

  /// `New {type}`
  String newPerson(Object type) {
    return Intl.message(
      'New $type',
      name: 'newPerson',
      desc: '',
      args: [type],
    );
  }

  /// `Schedule start date`
  String get scheduleFromDate {
    return Intl.message(
      'Schedule start date',
      name: 'scheduleFromDate',
      desc: '',
      args: [],
    );
  }

  /// `End date`
  String get scheduleTillDate {
    return Intl.message(
      'End date',
      name: 'scheduleTillDate',
      desc: '',
      args: [],
    );
  }

  /// `{order} lesson`
  String scheduleLessonOrder(Object order) {
    return Intl.message(
      '$order lesson',
      name: 'scheduleLessonOrder',
      desc: '',
      args: [order],
    );
  }

  /// `no lesson`
  String get scheduleNoLesson {
    return Intl.message(
      'no lesson',
      name: 'scheduleNoLesson',
      desc: '',
      args: [],
    );
  }

  /// `Lesson`
  String get lesson {
    return Intl.message(
      'Lesson',
      name: 'lesson',
      desc: '',
      args: [],
    );
  }

  /// `Curriculum should be selected`
  String get errorCurriculumEmpty {
    return Intl.message(
      'Curriculum should be selected',
      name: 'errorCurriculumEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Venue should be selected`
  String get errorVenueEmpty {
    return Intl.message(
      'Venue should be selected',
      name: 'errorVenueEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Schedule should be selected`
  String get errorClassScheduleEmpty {
    return Intl.message(
      'Schedule should be selected',
      name: 'errorClassScheduleEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Students should be selected`
  String get errorClassStudentsEmpty {
    return Intl.message(
      'Students should be selected',
      name: 'errorClassStudentsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Grade should be provided`
  String get errorClassGradeEmpty {
    return Intl.message(
      'Grade should be provided',
      name: 'errorClassGradeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Grade should be a number`
  String get errorClassGradeNotANumber {
    return Intl.message(
      'Grade should be a number',
      name: 'errorClassGradeNotANumber',
      desc: '',
      args: [],
    );
  }

  /// `Grade should be between 1 and 11`
  String get errorClassGradeNotInRange {
    return Intl.message(
      'Grade should be between 1 and 11',
      name: 'errorClassGradeNotInRange',
      desc: '',
      args: [],
    );
  }

  /// `Name should be provided`
  String get errorNameEmpty {
    return Intl.message(
      'Name should be provided',
      name: 'errorNameEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Teacher should be selected`
  String get errorTeacherEmpty {
    return Intl.message(
      'Teacher should be selected',
      name: 'errorTeacherEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Selected Student is already in the list`
  String get errorStudentAlreadyPresent {
    return Intl.message(
      'Selected Student is already in the list',
      name: 'errorStudentAlreadyPresent',
      desc: '',
      args: [],
    );
  }

  /// `Selected Person is not a Teacher`
  String get errorPersonIsNotATeacher {
    return Intl.message(
      'Selected Person is not a Teacher',
      name: 'errorPersonIsNotATeacher',
      desc: '',
      args: [],
    );
  }

  /// `Selected Person is not a Student`
  String get errorPersonIsNotAStudent {
    return Intl.message(
      'Selected Person is not a Student',
      name: 'errorPersonIsNotAStudent',
      desc: '',
      args: [],
    );
  }

  /// `First Name should be provided`
  String get errorPersonFirstNameEmpty {
    return Intl.message(
      'First Name should be provided',
      name: 'errorPersonFirstNameEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Last Name should be provided`
  String get errorPersonLastNameEmpty {
    return Intl.message(
      'Last Name should be provided',
      name: 'errorPersonLastNameEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Email should be provided`
  String get errorPersonEmailEmpty {
    return Intl.message(
      'Email should be provided',
      name: 'errorPersonEmailEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Birthdat should be provided`
  String get errorPersonBirthdayEmpty {
    return Intl.message(
      'Birthdat should be provided',
      name: 'errorPersonBirthdayEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Students should be selected`
  String get errorPersonParentStudentsEmpty {
    return Intl.message(
      'Students should be selected',
      name: 'errorPersonParentStudentsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Start Date should be provided`
  String get errorScheduleFromDateEmpty {
    return Intl.message(
      'Start Date should be provided',
      name: 'errorScheduleFromDateEmpty',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}