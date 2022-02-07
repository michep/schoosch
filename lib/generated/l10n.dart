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
  String get labelSaveChanges {
    return Intl.message(
      'Save changes',
      name: 'labelSaveChanges',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get labelSearch {
    return Intl.message(
      'Search',
      name: 'labelSearch',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get labelName {
    return Intl.message(
      'Name',
      name: 'labelName',
      desc: '',
      args: [],
    );
  }

  /// `Edit Institution`
  String get admDrawerEditInstitution {
    return Intl.message(
      'Edit Institution',
      name: 'admDrawerEditInstitution',
      desc: '',
      args: [],
    );
  }

  /// `Venues Info`
  String get admDrawerListVenue {
    return Intl.message(
      'Venues Info',
      name: 'admDrawerListVenue',
      desc: '',
      args: [],
    );
  }

  /// `Students, Teachers and Other People Info`
  String get admDrawerListPeople {
    return Intl.message(
      'Students, Teachers and Other People Info',
      name: 'admDrawerListPeople',
      desc: '',
      args: [],
    );
  }

  /// `Curriculums Info`
  String get admDrawerListCurriculum {
    return Intl.message(
      'Curriculums Info',
      name: 'admDrawerListCurriculum',
      desc: '',
      args: [],
    );
  }

  /// `Student Classes Info`
  String get admDrawerListClass {
    return Intl.message(
      'Student Classes Info',
      name: 'admDrawerListClass',
      desc: '',
      args: [],
    );
  }

  /// `Student Classes Schedules Info`
  String get admDrawerListSchedule {
    return Intl.message(
      'Student Classes Schedules Info',
      name: 'admDrawerListSchedule',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get labelClassName {
    return Intl.message(
      'Name',
      name: 'labelClassName',
      desc: '',
      args: [],
    );
  }

  /// `Grade`
  String get labelClassGrade {
    return Intl.message(
      'Grade',
      name: 'labelClassGrade',
      desc: '',
      args: [],
    );
  }

  /// `Teacher`
  String get labelClassMaster {
    return Intl.message(
      'Teacher',
      name: 'labelClassMaster',
      desc: '',
      args: [],
    );
  }

  /// `Schedule`
  String get labelClassSchedule {
    return Intl.message(
      'Schedule',
      name: 'labelClassSchedule',
      desc: '',
      args: [],
    );
  }

  /// `Students`
  String get labelClassStudents {
    return Intl.message(
      'Students',
      name: 'labelClassStudents',
      desc: '',
      args: [],
    );
  }

  /// `Classes`
  String get labelClassListTitle {
    return Intl.message(
      'Classes',
      name: 'labelClassListTitle',
      desc: '',
      args: [],
    );
  }

  /// `New Class`
  String get labelNewClass {
    return Intl.message(
      'New Class',
      name: 'labelNewClass',
      desc: '',
      args: [],
    );
  }

  /// `Учебный предмет`
  String get labelCurriculumName {
    return Intl.message(
      'Учебный предмет',
      name: 'labelCurriculumName',
      desc: '',
      args: [],
    );
  }

  /// `Альтернативное название`
  String get labelCurriculumAlternateName {
    return Intl.message(
      'Альтернативное название',
      name: 'labelCurriculumAlternateName',
      desc: '',
      args: [],
    );
  }

  /// `Преподаватель`
  String get labelCurriculumTeacher {
    return Intl.message(
      'Преподаватель',
      name: 'labelCurriculumTeacher',
      desc: '',
      args: [],
    );
  }

  /// `Группа учащихся`
  String get labelCurriculumStudents {
    return Intl.message(
      'Группа учащихся',
      name: 'labelCurriculumStudents',
      desc: '',
      args: [],
    );
  }

  /// `Учебные предметы`
  String get labelCurriculumListTitle {
    return Intl.message(
      'Учебные предметы',
      name: 'labelCurriculumListTitle',
      desc: '',
      args: [],
    );
  }

  /// `Новый учебный предмет`
  String get labelNewCurriculum {
    return Intl.message(
      'Новый учебный предмет',
      name: 'labelNewCurriculum',
      desc: '',
      args: [],
    );
  }

  /// `Раписания времени уроков`
  String get labelDayScheduleListTitle {
    return Intl.message(
      'Раписания времени уроков',
      name: 'labelDayScheduleListTitle',
      desc: '',
      args: [],
    );
  }

  /// `{classname}, расписание`
  String labelClassScheduleTitle(Object classname) {
    return Intl.message(
      '$classname, расписание',
      name: 'labelClassScheduleTitle',
      desc: '',
      args: [classname],
    );
  }

  /// `Кабинет`
  String get labelVenueName {
    return Intl.message(
      'Кабинет',
      name: 'labelVenueName',
      desc: '',
      args: [],
    );
  }

  /// `Кабинеты и помещения`
  String get labelVenueListTitle {
    return Intl.message(
      'Кабинеты и помещения',
      name: 'labelVenueListTitle',
      desc: '',
      args: [],
    );
  }

  /// `Новый кабинет`
  String get labelNewVenue {
    return Intl.message(
      'Новый кабинет',
      name: 'labelNewVenue',
      desc: '',
      args: [],
    );
  }

  /// `Урок`
  String get labelLessonTitle {
    return Intl.message(
      'Урок',
      name: 'labelLessonTitle',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get labelPersonName {
    return Intl.message(
      'Name',
      name: 'labelPersonName',
      desc: '',
      args: [],
    );
  }

  /// `Имя`
  String get labelPersonFirstName {
    return Intl.message(
      'Имя',
      name: 'labelPersonFirstName',
      desc: '',
      args: [],
    );
  }

  /// `Отчетсво`
  String get labelPersonMiddleName {
    return Intl.message(
      'Отчетсво',
      name: 'labelPersonMiddleName',
      desc: '',
      args: [],
    );
  }

  /// `Фамилия`
  String get labelPersonLastName {
    return Intl.message(
      'Фамилия',
      name: 'labelPersonLastName',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get labelPersonEmail {
    return Intl.message(
      'Email',
      name: 'labelPersonEmail',
      desc: '',
      args: [],
    );
  }

  /// `Дата рождения`
  String get labelPersonBirthday {
    return Intl.message(
      'Дата рождения',
      name: 'labelPersonBirthday',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get labelPersonType {
    return Intl.message(
      'Type',
      name: 'labelPersonType',
      desc: '',
      args: [],
    );
  }

  /// `Все типы`
  String get labelPersonTypeAll {
    return Intl.message(
      'Все типы',
      name: 'labelPersonTypeAll',
      desc: '',
      args: [],
    );
  }

  /// `Учащийся`
  String get labelPersonTypeStudent {
    return Intl.message(
      'Учащийся',
      name: 'labelPersonTypeStudent',
      desc: '',
      args: [],
    );
  }

  /// `Преподаватель`
  String get labelPersonTypeTeacher {
    return Intl.message(
      'Преподаватель',
      name: 'labelPersonTypeTeacher',
      desc: '',
      args: [],
    );
  }

  /// `Родитель \ Наблюдатель`
  String get labelPersonTypeParent {
    return Intl.message(
      'Родитель \\ Наблюдатель',
      name: 'labelPersonTypeParent',
      desc: '',
      args: [],
    );
  }

  /// `Администратор`
  String get labelPersonTypeAdmin {
    return Intl.message(
      'Администратор',
      name: 'labelPersonTypeAdmin',
      desc: '',
      args: [],
    );
  }

  /// `Связанные учащиеся`
  String get labelPersonRelatedStudents {
    return Intl.message(
      'Связанные учащиеся',
      name: 'labelPersonRelatedStudents',
      desc: '',
      args: [],
    );
  }

  /// `Сотрудники, учителя и ученики`
  String get labelPeopleListLitle {
    return Intl.message(
      'Сотрудники, учителя и ученики',
      name: 'labelPeopleListLitle',
      desc: '',
      args: [],
    );
  }

  /// `Новый {type}`
  String labelNewPerson(Object type) {
    return Intl.message(
      'Новый $type',
      name: 'labelNewPerson',
      desc: '',
      args: [type],
    );
  }

  /// `Учебный предмет должен быть выбран`
  String get errorCurriculumEmpty {
    return Intl.message(
      'Учебный предмет должен быть выбран',
      name: 'errorCurriculumEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Кабинет должен быть выбран`
  String get errorVenueEmpty {
    return Intl.message(
      'Кабинет должен быть выбран',
      name: 'errorVenueEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Расписание должно быть выбрано`
  String get errorClassScheduleEmpty {
    return Intl.message(
      'Расписание должно быть выбрано',
      name: 'errorClassScheduleEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Нужно выбрать учащихся`
  String get errorClassStudentsEmpty {
    return Intl.message(
      'Нужно выбрать учащихся',
      name: 'errorClassStudentsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Год обучения должен быть заполнен`
  String get errorClassGradeEmpty {
    return Intl.message(
      'Год обучения должен быть заполнен',
      name: 'errorClassGradeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Год обучения должен быть числом`
  String get errorClassGradeNotANumber {
    return Intl.message(
      'Год обучения должен быть числом',
      name: 'errorClassGradeNotANumber',
      desc: '',
      args: [],
    );
  }

  /// `Год обучения должен быть между 1 и 11`
  String get errorClassGradeNotInRange {
    return Intl.message(
      'Год обучения должен быть между 1 и 11',
      name: 'errorClassGradeNotInRange',
      desc: '',
      args: [],
    );
  }

  /// `Название должно быть заполнено`
  String get errorNameEmpty {
    return Intl.message(
      'Название должно быть заполнено',
      name: 'errorNameEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Преподаватель должен быть выбран`
  String get errorTeacherEmpty {
    return Intl.message(
      'Преподаватель должен быть выбран',
      name: 'errorTeacherEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Выбранный учащийся уже присутствует в группе`
  String get errorStudentAlreadyPresent {
    return Intl.message(
      'Выбранный учащийся уже присутствует в группе',
      name: 'errorStudentAlreadyPresent',
      desc: '',
      args: [],
    );
  }

  /// `Выбранный персонаж не является преподавателем`
  String get errorPersonIsNotATeacher {
    return Intl.message(
      'Выбранный персонаж не является преподавателем',
      name: 'errorPersonIsNotATeacher',
      desc: '',
      args: [],
    );
  }

  /// `Выбранный персонаж не является учащимся`
  String get errorPersonIsNotAStudent {
    return Intl.message(
      'Выбранный персонаж не является учащимся',
      name: 'errorPersonIsNotAStudent',
      desc: '',
      args: [],
    );
  }

  /// `Имя должно быть заполнено`
  String get errorPersonFirstNameEmpty {
    return Intl.message(
      'Имя должно быть заполнено',
      name: 'errorPersonFirstNameEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Фамилия должна быть заполнена`
  String get errorPersonLastNameEmpty {
    return Intl.message(
      'Фамилия должна быть заполнена',
      name: 'errorPersonLastNameEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Email адрес должен быть заполнен`
  String get errorPersonEmailEmpty {
    return Intl.message(
      'Email адрес должен быть заполнен',
      name: 'errorPersonEmailEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Нужно указать дату рождения`
  String get errorPersonBirthdayEmpty {
    return Intl.message(
      'Нужно указать дату рождения',
      name: 'errorPersonBirthdayEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Нужно выбрать учащихся`
  String get errorPersonParentStudentsEmpty {
    return Intl.message(
      'Нужно выбрать учащихся',
      name: 'errorPersonParentStudentsEmpty',
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
