// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ru';

  static String m0(classname) => "${classname}, расписание";

  static String m1(type) => "Новый ${type}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "admDrawerEditInstitution": MessageLookupByLibrary.simpleMessage(
            "Информация об учебном заведении"),
        "admDrawerListClass":
            MessageLookupByLibrary.simpleMessage("Учебные классы"),
        "admDrawerListCurriculum":
            MessageLookupByLibrary.simpleMessage("Учебные предметы"),
        "admDrawerListPeople": MessageLookupByLibrary.simpleMessage(
            "Сотрудники, учителя и ученики"),
        "admDrawerListSchedule":
            MessageLookupByLibrary.simpleMessage("Расписание уроков на неделю"),
        "admDrawerListVenue":
            MessageLookupByLibrary.simpleMessage("Кабинеты и помещения"),
        "appBarTitle": MessageLookupByLibrary.simpleMessage("Скууш"),
        "appTiile":
            MessageLookupByLibrary.simpleMessage("Скууш - школьный дневник"),
        "errorClassGradeEmpty": MessageLookupByLibrary.simpleMessage(
            "Год обучения должен быть заполнен"),
        "errorClassGradeNotANumber": MessageLookupByLibrary.simpleMessage(
            "Год обучения должен быть числом"),
        "errorClassGradeNotInRange": MessageLookupByLibrary.simpleMessage(
            "Год обучения должен быть между 1 и 11"),
        "errorClassScheduleEmpty": MessageLookupByLibrary.simpleMessage(
            "Расписание должно быть выбрано"),
        "errorClassStudentsEmpty":
            MessageLookupByLibrary.simpleMessage("Нужно выбрать учащихся"),
        "errorCurriculumEmpty": MessageLookupByLibrary.simpleMessage(
            "Учебный предмет должен быть выбран"),
        "errorNameEmpty": MessageLookupByLibrary.simpleMessage(
            "Название должно быть заполнено"),
        "errorPersonBirthdayEmpty":
            MessageLookupByLibrary.simpleMessage("Нужно указать дату рождения"),
        "errorPersonEmailEmpty": MessageLookupByLibrary.simpleMessage(
            "Email адрес должен быть заполнен"),
        "errorPersonFirstNameEmpty":
            MessageLookupByLibrary.simpleMessage("Имя должно быть заполнено"),
        "errorPersonIsNotAStudent": MessageLookupByLibrary.simpleMessage(
            "Выбранный персонаж не является учащимся"),
        "errorPersonIsNotATeacher": MessageLookupByLibrary.simpleMessage(
            "Выбранный персонаж не является преподавателем"),
        "errorPersonLastNameEmpty": MessageLookupByLibrary.simpleMessage(
            "Фамилия должна быть заполнена"),
        "errorPersonParentStudentsEmpty":
            MessageLookupByLibrary.simpleMessage("Нужно выбрать учащихся"),
        "errorStudentAlreadyPresent": MessageLookupByLibrary.simpleMessage(
            "Выбранный учащийся уже присутствует в группе"),
        "errorTeacherEmpty": MessageLookupByLibrary.simpleMessage(
            "Преподаватель должен быть выбран"),
        "errorVenueEmpty":
            MessageLookupByLibrary.simpleMessage("Кабинет должен быть выбран"),
        "labelClassGrade": MessageLookupByLibrary.simpleMessage("Год обучения"),
        "labelClassListTitle":
            MessageLookupByLibrary.simpleMessage("Учебные классы"),
        "labelClassMaster":
            MessageLookupByLibrary.simpleMessage("Классный руководитель"),
        "labelClassName":
            MessageLookupByLibrary.simpleMessage("Название учебного класса"),
        "labelClassSchedule":
            MessageLookupByLibrary.simpleMessage("Расписание времени уроков"),
        "labelClassScheduleTitle": m0,
        "labelClassStudents":
            MessageLookupByLibrary.simpleMessage("Учащиеяся класса"),
        "labelCurriculumAlternateName":
            MessageLookupByLibrary.simpleMessage("Альтернативное название"),
        "labelCurriculumListTitle":
            MessageLookupByLibrary.simpleMessage("Учебные предметы"),
        "labelCurriculumName":
            MessageLookupByLibrary.simpleMessage("Учебный предмет"),
        "labelCurriculumStudents":
            MessageLookupByLibrary.simpleMessage("Группа учащихся"),
        "labelCurriculumTeacher":
            MessageLookupByLibrary.simpleMessage("Преподаватель"),
        "labelDayScheduleListTitle":
            MessageLookupByLibrary.simpleMessage("Раписания времени уроков"),
        "labelLessonTitle": MessageLookupByLibrary.simpleMessage("Урок"),
        "labelName": MessageLookupByLibrary.simpleMessage("Название"),
        "labelNewClass":
            MessageLookupByLibrary.simpleMessage("Новый учебный класс"),
        "labelNewCurriculum":
            MessageLookupByLibrary.simpleMessage("Новый учебный предмет"),
        "labelNewPerson": m1,
        "labelNewVenue": MessageLookupByLibrary.simpleMessage("Новый кабинет"),
        "labelPeopleListLitle": MessageLookupByLibrary.simpleMessage(
            "Сотрудники, учителя и ученики"),
        "labelPersonBirthday":
            MessageLookupByLibrary.simpleMessage("Дата рождения"),
        "labelPersonEmail": MessageLookupByLibrary.simpleMessage("Email"),
        "labelPersonFirstName": MessageLookupByLibrary.simpleMessage("Имя"),
        "labelPersonLastName": MessageLookupByLibrary.simpleMessage("Фамилия"),
        "labelPersonMiddleName":
            MessageLookupByLibrary.simpleMessage("Отчетсво"),
        "labelPersonName": MessageLookupByLibrary.simpleMessage("Имя"),
        "labelPersonRelatedStudents":
            MessageLookupByLibrary.simpleMessage("Связанные учащиеся"),
        "labelPersonType": MessageLookupByLibrary.simpleMessage("Тип"),
        "labelPersonTypeAdmin":
            MessageLookupByLibrary.simpleMessage("Администратор"),
        "labelPersonTypeAll": MessageLookupByLibrary.simpleMessage("Все типы"),
        "labelPersonTypeParent":
            MessageLookupByLibrary.simpleMessage("Родитель \\ Наблюдатель"),
        "labelPersonTypeStudent":
            MessageLookupByLibrary.simpleMessage("Учащийся"),
        "labelPersonTypeTeacher":
            MessageLookupByLibrary.simpleMessage("Преподаватель"),
        "labelSaveChanges":
            MessageLookupByLibrary.simpleMessage("Сохранить изменения"),
        "labelSearch": MessageLookupByLibrary.simpleMessage("Поиск"),
        "labelVenueListTitle":
            MessageLookupByLibrary.simpleMessage("Кабинеты и помещения"),
        "labelVenueName": MessageLookupByLibrary.simpleMessage("Кабинет")
      };
}
