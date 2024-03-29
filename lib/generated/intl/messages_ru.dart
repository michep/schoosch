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

  static String m2(name) => "Обзор класса ${name}";

  static String m3(order) => "${order} урок";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "aboutTitle": MessageLookupByLibrary.simpleMessage("О приложении"),
        "appBarTitle": MessageLookupByLibrary.simpleMessage("Скуш"),
        "appTiile":
            MessageLookupByLibrary.simpleMessage("Скуш - школьный дневник"),
        "chooseClassTitle":
            MessageLookupByLibrary.simpleMessage("Выбор класса"),
        "classGrade": MessageLookupByLibrary.simpleMessage("Год обучения"),
        "classHomeworkCompletionsTitle":
            MessageLookupByLibrary.simpleMessage("Выполнение"),
        "classHomeworkTitle":
            MessageLookupByLibrary.simpleMessage("Задание всему классу"),
        "classList": MessageLookupByLibrary.simpleMessage("Учебные классы"),
        "classMaster":
            MessageLookupByLibrary.simpleMessage("Классный руководитель"),
        "className":
            MessageLookupByLibrary.simpleMessage("Название учебного класса"),
        "classSchedule":
            MessageLookupByLibrary.simpleMessage("Расписание времени уроков"),
        "classScheduleName": m0,
        "classStudents":
            MessageLookupByLibrary.simpleMessage("Учащиеяся класса"),
        "classStudentsTitle":
            MessageLookupByLibrary.simpleMessage("Ученики класса"),
        "commentTitle": MessageLookupByLibrary.simpleMessage("Комментарий"),
        "currentLessonAbsences":
            MessageLookupByLibrary.simpleMessage("Отсутствующие"),
        "currentLessonClassHomework":
            MessageLookupByLibrary.simpleMessage("Задание классу на этот урок"),
        "currentLessonHomeworks":
            MessageLookupByLibrary.simpleMessage("ДЗ на сегодня"),
        "currentLessonMarks": MessageLookupByLibrary.simpleMessage("Оценки"),
        "currentLessonPersonalHomeworks": MessageLookupByLibrary.simpleMessage(
            "Персональные задания на этот урок"),
        "curriculumAlternateName":
            MessageLookupByLibrary.simpleMessage("Альтернативное название"),
        "curriculumList":
            MessageLookupByLibrary.simpleMessage("Учебные предметы"),
        "curriculumName":
            MessageLookupByLibrary.simpleMessage("Учебный предмет"),
        "curriculumStudents":
            MessageLookupByLibrary.simpleMessage("Группа учащихся"),
        "curriculumTeacher":
            MessageLookupByLibrary.simpleMessage("Преподаватель"),
        "dayLessonTimeName":
            MessageLookupByLibrary.simpleMessage("Раписание времени уроков"),
        "dayLessontimeList":
            MessageLookupByLibrary.simpleMessage("Расписания времени уроков"),
        "dayScheduleList":
            MessageLookupByLibrary.simpleMessage("Раписание занятий"),
        "editInstitution": MessageLookupByLibrary.simpleMessage(
            "Информация об учебном заведении"),
        "errorCanNotBeUncompleted": MessageLookupByLibrary.simpleMessage(
            "выполнение уже подтверждено, его нельзя отметить как невыполненное"),
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
        "errorHomeWorkExists": MessageLookupByLibrary.simpleMessage(
            "Задание для этого ученика уже существует, пожалуйста выберите другого ученика"),
        "errorHomeworkTextEmpty": MessageLookupByLibrary.simpleMessage(
            "Текст задания не может быть пустым"),
        "errorMarkError":
            MessageLookupByLibrary.simpleMessage("Нужно выбрать оценку"),
        "errorMarkTypeLabelEmpty": MessageLookupByLibrary.simpleMessage(
            "Короткое название не может быть пустым"),
        "errorMarkTypeWeightEmpty": MessageLookupByLibrary.simpleMessage(
            "Вес не может быть пустым и должен быть числом"),
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
        "errorPersonParentClassesEmpty":
            MessageLookupByLibrary.simpleMessage("Нужно выбрать классы"),
        "errorPersonParentStudentsEmpty":
            MessageLookupByLibrary.simpleMessage("Нужно выбрать учащихся"),
        "errorScheduleFromDateEmpty": MessageLookupByLibrary.simpleMessage(
            "Дата начала действия должна быть выбрана"),
        "errorStudentAlreadyPresent": MessageLookupByLibrary.simpleMessage(
            "Выбранный учащийся уже присутствует в группе"),
        "errorStudentEmpty":
            MessageLookupByLibrary.simpleMessage("Учченик должен быть выбран"),
        "errorTeacherEmpty": MessageLookupByLibrary.simpleMessage(
            "Преподаватель должен быть выбран"),
        "errorUnknownMarkType":
            MessageLookupByLibrary.simpleMessage("Нужно выбрать Тип оценки"),
        "errorUnknownPersonType":
            MessageLookupByLibrary.simpleMessage("unknown person type"),
        "errorVenueEmpty":
            MessageLookupByLibrary.simpleMessage("Кабинет должен быть выбран"),
        "freeLessonsTitle":
            MessageLookupByLibrary.simpleMessage("Поиск свободных уроков"),
        "freeTeachersTitle":
            MessageLookupByLibrary.simpleMessage("Поиск свободных учителей"),
        "fromTimeTitle": MessageLookupByLibrary.simpleMessage("Время начала"),
        "fromTitle": MessageLookupByLibrary.simpleMessage("Начало"),
        "homeworkTextTitle":
            MessageLookupByLibrary.simpleMessage("Текст задания"),
        "homeworkTitle":
            MessageLookupByLibrary.simpleMessage("Домашнее задание"),
        "lesson": MessageLookupByLibrary.simpleMessage("Урок"),
        "lessonName": MessageLookupByLibrary.simpleMessage("Урок"),
        "lessonTitle": MessageLookupByLibrary.simpleMessage("Урок"),
        "loginPageTitle":
            MessageLookupByLibrary.simpleMessage("Вход в приложение"),
        "markTitle": MessageLookupByLibrary.simpleMessage("Оценка"),
        "markTypeLabel":
            MessageLookupByLibrary.simpleMessage("Короткое название"),
        "markTypeList": MessageLookupByLibrary.simpleMessage("Типы оценок"),
        "markTypeTitle": MessageLookupByLibrary.simpleMessage("Тип оценки"),
        "markTypeWeight": MessageLookupByLibrary.simpleMessage("Вес"),
        "modelStatusTitle": MessageLookupByLibrary.simpleMessage("Статус"),
        "name": MessageLookupByLibrary.simpleMessage("Название"),
        "newClass": MessageLookupByLibrary.simpleMessage("Новый учебный класс"),
        "newCurriculum":
            MessageLookupByLibrary.simpleMessage("Новый учебный предмет"),
        "newMarkType": MessageLookupByLibrary.simpleMessage("Новый Тип оценки"),
        "newPerson": m1,
        "newVenue": MessageLookupByLibrary.simpleMessage("Новый кабинет"),
        "nextLessonClassHomework": MessageLookupByLibrary.simpleMessage(
            "Задание классу на следующий урок"),
        "nextLessonHomeworks":
            MessageLookupByLibrary.simpleMessage("Задать ДЗ"),
        "nextLessonPersonalHomeworks": MessageLookupByLibrary.simpleMessage(
            "Персональные задания на следующий урок"),
        "noWeekSchedule": MessageLookupByLibrary.simpleMessage(
            "нет расписания на эту неделю"),
        "observedClassTitle": m2,
        "peopleList": MessageLookupByLibrary.simpleMessage(
            "Сотрудники, учителя и ученики"),
        "periodSemester":
            MessageLookupByLibrary.simpleMessage("учебный период"),
        "periodYear": MessageLookupByLibrary.simpleMessage("учебный год"),
        "personBirthday": MessageLookupByLibrary.simpleMessage("Дата рождения"),
        "personEmail": MessageLookupByLibrary.simpleMessage("Email"),
        "personFirstName": MessageLookupByLibrary.simpleMessage("Имя"),
        "personLastName": MessageLookupByLibrary.simpleMessage("Фамилия"),
        "personMiddleName": MessageLookupByLibrary.simpleMessage("Отчетсво"),
        "personName": MessageLookupByLibrary.simpleMessage("Имя"),
        "personRelatedClasses":
            MessageLookupByLibrary.simpleMessage("Связанные классы"),
        "personRelatedStudents":
            MessageLookupByLibrary.simpleMessage("Связанные учащиеся"),
        "personType": MessageLookupByLibrary.simpleMessage("Тип"),
        "personTypeAdmin":
            MessageLookupByLibrary.simpleMessage("Администратор"),
        "personTypeAll": MessageLookupByLibrary.simpleMessage("Все типы"),
        "personTypeObserver":
            MessageLookupByLibrary.simpleMessage("Наблюдатель"),
        "personTypeParent": MessageLookupByLibrary.simpleMessage("Родитель"),
        "personTypeStudent": MessageLookupByLibrary.simpleMessage("Учащийся"),
        "personTypeTeacher":
            MessageLookupByLibrary.simpleMessage("Преподаватель"),
        "personalHomeworkTitle":
            MessageLookupByLibrary.simpleMessage("Д/З личное"),
        "replacementsTitle":
            MessageLookupByLibrary.simpleMessage("Подмены в расписании"),
        "roleAdmin": MessageLookupByLibrary.simpleMessage("Администратор"),
        "roleObserver": MessageLookupByLibrary.simpleMessage("Наблюдатель"),
        "roleParent": MessageLookupByLibrary.simpleMessage("Родитель"),
        "roleStudent": MessageLookupByLibrary.simpleMessage("Ученик"),
        "roleTeacher": MessageLookupByLibrary.simpleMessage("Учитель"),
        "saveChanges":
            MessageLookupByLibrary.simpleMessage("Сохранить изменения"),
        "scheduleFromDate":
            MessageLookupByLibrary.simpleMessage("Начало действия расписания"),
        "scheduleLessonOrder": m3,
        "scheduleNoLesson":
            MessageLookupByLibrary.simpleMessage("нет этого урока"),
        "scheduleTillDate":
            MessageLookupByLibrary.simpleMessage("Окончание действия"),
        "search": MessageLookupByLibrary.simpleMessage("Поиск"),
        "setCompleted":
            MessageLookupByLibrary.simpleMessage("сообщить о выполнении"),
        "setMarkTitle":
            MessageLookupByLibrary.simpleMessage("Поставить оценку"),
        "setUncompleted":
            MessageLookupByLibrary.simpleMessage("отметить как невыполненное"),
        "statusActive": MessageLookupByLibrary.simpleMessage("Активно"),
        "statusInactive": MessageLookupByLibrary.simpleMessage("Неактивно"),
        "studentTitle": MessageLookupByLibrary.simpleMessage("Ученик"),
        "studyPeriodList":
            MessageLookupByLibrary.simpleMessage("Учебные периоды"),
        "studyPeriodTitle":
            MessageLookupByLibrary.simpleMessage("Учебный период"),
        "studyPeriodTypeTitle":
            MessageLookupByLibrary.simpleMessage("Тип учебного периода"),
        "tabScheduleHomeworksTitle":
            MessageLookupByLibrary.simpleMessage("Расписание/ДЗ"),
        "tabStudentsPerformance":
            MessageLookupByLibrary.simpleMessage("Успеваемость"),
        "tillTimeTitle":
            MessageLookupByLibrary.simpleMessage("Время окончания"),
        "tillTitle": MessageLookupByLibrary.simpleMessage("Окончание"),
        "todateTitle": MessageLookupByLibrary.simpleMessage("Выполнить к дате"),
        "updateMarkTitle":
            MessageLookupByLibrary.simpleMessage("Изменить оценку"),
        "userProfileTitle":
            MessageLookupByLibrary.simpleMessage("Профиль пользователя"),
        "venueList":
            MessageLookupByLibrary.simpleMessage("Кабинеты и помещения"),
        "venueName": MessageLookupByLibrary.simpleMessage("Кабинет"),
        "weekSchedule":
            MessageLookupByLibrary.simpleMessage("Расписание уроков на неделю")
      };
}
