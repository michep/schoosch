// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(classname) => "${classname} schedule";

  static String m1(type) => "New ${type}";

  static String m2(name) => "Observe class ${name}";

  static String m3(order) => "${order} lesson";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "aboutTitle": MessageLookupByLibrary.simpleMessage("About this app"),
        "appBarTitle": MessageLookupByLibrary.simpleMessage("Schoosch"),
        "appTiile": MessageLookupByLibrary.simpleMessage(
            "Schoosch is school schedule app"),
        "chooseClassTitle":
            MessageLookupByLibrary.simpleMessage("Choose Class"),
        "classGrade": MessageLookupByLibrary.simpleMessage("Grade"),
        "classHomeworkCompletionsTitle":
            MessageLookupByLibrary.simpleMessage("Homework Completions"),
        "classHomeworkTitle":
            MessageLookupByLibrary.simpleMessage("Class Homework"),
        "classList": MessageLookupByLibrary.simpleMessage("Classes"),
        "classMaster": MessageLookupByLibrary.simpleMessage("Teacher"),
        "className": MessageLookupByLibrary.simpleMessage("Name"),
        "classSchedule": MessageLookupByLibrary.simpleMessage("Lessons Times"),
        "classScheduleName": m0,
        "classStudents": MessageLookupByLibrary.simpleMessage("Students"),
        "classStudentsTitle":
            MessageLookupByLibrary.simpleMessage("Class Students"),
        "commentTitle": MessageLookupByLibrary.simpleMessage("Comment"),
        "currentLessonAbsences": MessageLookupByLibrary.simpleMessage("Absent"),
        "currentLessonClassHomework":
            MessageLookupByLibrary.simpleMessage("Class homework for this day"),
        "currentLessonHomeworks":
            MessageLookupByLibrary.simpleMessage("Homework for today"),
        "currentLessonMarks": MessageLookupByLibrary.simpleMessage("Marks"),
        "currentLessonPersonalHomeworks": MessageLookupByLibrary.simpleMessage(
            "Personal homeworks for this day"),
        "curriculumAlternateName":
            MessageLookupByLibrary.simpleMessage("Alias"),
        "curriculumList": MessageLookupByLibrary.simpleMessage("Curriculums"),
        "curriculumName": MessageLookupByLibrary.simpleMessage("Curriculum"),
        "curriculumStudents": MessageLookupByLibrary.simpleMessage("Students"),
        "curriculumTeacher": MessageLookupByLibrary.simpleMessage("Teacher"),
        "dayLessonTimeName":
            MessageLookupByLibrary.simpleMessage("Lesson Times"),
        "dayLessontimeList":
            MessageLookupByLibrary.simpleMessage("Lessons Times"),
        "dayScheduleList": MessageLookupByLibrary.simpleMessage("Schedule"),
        "editInstitution":
            MessageLookupByLibrary.simpleMessage("Edit Institution"),
        "errorCanNotBeUncompleted": MessageLookupByLibrary.simpleMessage(
            "This completion is Confirmed and can not be set as Uncompleted"),
        "errorClassGradeEmpty":
            MessageLookupByLibrary.simpleMessage("Grade should be provided"),
        "errorClassGradeNotANumber":
            MessageLookupByLibrary.simpleMessage("Grade should be a number"),
        "errorClassGradeNotInRange": MessageLookupByLibrary.simpleMessage(
            "Grade should be between 1 and 11"),
        "errorClassScheduleEmpty":
            MessageLookupByLibrary.simpleMessage("Schedule should be selected"),
        "errorClassStudentsEmpty":
            MessageLookupByLibrary.simpleMessage("Students should be selected"),
        "errorCurriculumEmpty": MessageLookupByLibrary.simpleMessage(
            "Curriculum should be selected"),
        "errorHomeWorkExists": MessageLookupByLibrary.simpleMessage(
            "There is already a homework for this student, please select another student"),
        "errorHomeworkTextEmpty": MessageLookupByLibrary.simpleMessage(
            "Homework text shold not be empty"),
        "errorMarkError":
            MessageLookupByLibrary.simpleMessage("Mark shoud be defined"),
        "errorMarkTypeLabelEmpty": MessageLookupByLibrary.simpleMessage(
            "Mark type Label should not be empty"),
        "errorMarkTypeWeightEmpty": MessageLookupByLibrary.simpleMessage(
            "Mark type Weight should not be empty and need to be a number"),
        "errorNameEmpty":
            MessageLookupByLibrary.simpleMessage("Name should be provided"),
        "errorPersonBirthdayEmpty":
            MessageLookupByLibrary.simpleMessage("Birthdat should be provided"),
        "errorPersonEmailEmpty":
            MessageLookupByLibrary.simpleMessage("Email should be provided"),
        "errorPersonFirstNameEmpty": MessageLookupByLibrary.simpleMessage(
            "First Name should be provided"),
        "errorPersonIsNotAStudent": MessageLookupByLibrary.simpleMessage(
            "Selected Person is not a Student"),
        "errorPersonIsNotATeacher": MessageLookupByLibrary.simpleMessage(
            "Selected Person is not a Teacher"),
        "errorPersonLastNameEmpty": MessageLookupByLibrary.simpleMessage(
            "Last Name should be provided"),
        "errorPersonParentClassesEmpty":
            MessageLookupByLibrary.simpleMessage("Classes should be selected"),
        "errorPersonParentStudentsEmpty":
            MessageLookupByLibrary.simpleMessage("Students should be selected"),
        "errorScheduleFromDateEmpty": MessageLookupByLibrary.simpleMessage(
            "Start Date should be provided"),
        "errorStudentAlreadyPresent": MessageLookupByLibrary.simpleMessage(
            "Selected Student is already in the list"),
        "errorStudentEmpty":
            MessageLookupByLibrary.simpleMessage("Student should be selected"),
        "errorTeacherEmpty":
            MessageLookupByLibrary.simpleMessage("Teacher should be selected"),
        "errorUnknownMarkType": MessageLookupByLibrary.simpleMessage(
            "Mark type should be selected"),
        "errorUnknownPersonType":
            MessageLookupByLibrary.simpleMessage("unknown person type"),
        "errorVenueEmpty":
            MessageLookupByLibrary.simpleMessage("Venue should be selected"),
        "freeLessonsTitle":
            MessageLookupByLibrary.simpleMessage("Search for Free Lessons"),
        "freeTeachersTitle":
            MessageLookupByLibrary.simpleMessage("Search for Free Teachers"),
        "fromTimeTitle": MessageLookupByLibrary.simpleMessage("From time"),
        "fromTitle": MessageLookupByLibrary.simpleMessage("From"),
        "homeworkTextTitle":
            MessageLookupByLibrary.simpleMessage("Homework Text"),
        "homeworkTitle": MessageLookupByLibrary.simpleMessage("Homework"),
        "lesson": MessageLookupByLibrary.simpleMessage("Lesson"),
        "lessonName": MessageLookupByLibrary.simpleMessage("Lesson"),
        "lessonTitle": MessageLookupByLibrary.simpleMessage("Lesson"),
        "loginPageTitle":
            MessageLookupByLibrary.simpleMessage("Application Login"),
        "markTitle": MessageLookupByLibrary.simpleMessage("Mark"),
        "markTypeLabel": MessageLookupByLibrary.simpleMessage("Short Label"),
        "markTypeList": MessageLookupByLibrary.simpleMessage("Mark types"),
        "markTypeTitle": MessageLookupByLibrary.simpleMessage("Mark type"),
        "markTypeWeight": MessageLookupByLibrary.simpleMessage("Weight"),
        "modelStatusTitle": MessageLookupByLibrary.simpleMessage("Status"),
        "name": MessageLookupByLibrary.simpleMessage("Name"),
        "newClass": MessageLookupByLibrary.simpleMessage("New Class"),
        "newCurriculum": MessageLookupByLibrary.simpleMessage("New Curriculum"),
        "newMarkType": MessageLookupByLibrary.simpleMessage("New Mark type"),
        "newPerson": m1,
        "newVenue": MessageLookupByLibrary.simpleMessage("New Vanue"),
        "nextLessonClassHomework":
            MessageLookupByLibrary.simpleMessage("Class homework for next day"),
        "nextLessonHomeworks":
            MessageLookupByLibrary.simpleMessage("Create Homework"),
        "nextLessonPersonalHomeworks": MessageLookupByLibrary.simpleMessage(
            "Personal omeworks for next day"),
        "noWeekSchedule":
            MessageLookupByLibrary.simpleMessage("no schedule for this week"),
        "observedClassTitle": m2,
        "peopleList":
            MessageLookupByLibrary.simpleMessage("Student, Teachers and other"),
        "periodSemester":
            MessageLookupByLibrary.simpleMessage("study semester"),
        "periodYear": MessageLookupByLibrary.simpleMessage("study year"),
        "personBirthday": MessageLookupByLibrary.simpleMessage("Birthday"),
        "personEmail": MessageLookupByLibrary.simpleMessage("Email"),
        "personFirstName": MessageLookupByLibrary.simpleMessage("First Name"),
        "personLastName": MessageLookupByLibrary.simpleMessage("Last Name"),
        "personMiddleName": MessageLookupByLibrary.simpleMessage("Middle Name"),
        "personName": MessageLookupByLibrary.simpleMessage("Name"),
        "personRelatedClasses":
            MessageLookupByLibrary.simpleMessage("Related classes"),
        "personRelatedStudents":
            MessageLookupByLibrary.simpleMessage("Related Students"),
        "personType": MessageLookupByLibrary.simpleMessage("Type"),
        "personTypeAdmin": MessageLookupByLibrary.simpleMessage("Admin"),
        "personTypeAll": MessageLookupByLibrary.simpleMessage("All"),
        "personTypeObserver": MessageLookupByLibrary.simpleMessage("Observer"),
        "personTypeParent": MessageLookupByLibrary.simpleMessage("Parent"),
        "personTypeStudent": MessageLookupByLibrary.simpleMessage("Student"),
        "personTypeTeacher": MessageLookupByLibrary.simpleMessage("Teacher"),
        "personalHomeworkTitle":
            MessageLookupByLibrary.simpleMessage("Personal Homework"),
        "replacementsTitle":
            MessageLookupByLibrary.simpleMessage("Schedule Replacements"),
        "roleAdmin": MessageLookupByLibrary.simpleMessage("Administrator"),
        "roleObserver": MessageLookupByLibrary.simpleMessage("Observer"),
        "roleParent": MessageLookupByLibrary.simpleMessage("Parnet"),
        "roleStudent": MessageLookupByLibrary.simpleMessage("Student"),
        "roleTeacher": MessageLookupByLibrary.simpleMessage("Teacher"),
        "saveChanges": MessageLookupByLibrary.simpleMessage("Save changes"),
        "scheduleFromDate":
            MessageLookupByLibrary.simpleMessage("Schedule start date"),
        "scheduleLessonOrder": m3,
        "scheduleNoLesson": MessageLookupByLibrary.simpleMessage("no lesson"),
        "scheduleTillDate": MessageLookupByLibrary.simpleMessage("End date"),
        "search": MessageLookupByLibrary.simpleMessage("Search"),
        "setCompleted":
            MessageLookupByLibrary.simpleMessage("Set as Completed"),
        "setMarkTitle": MessageLookupByLibrary.simpleMessage("Set Mark"),
        "setUncompleted":
            MessageLookupByLibrary.simpleMessage("Set as Uncompleted"),
        "statusActive": MessageLookupByLibrary.simpleMessage("Active"),
        "statusInactive": MessageLookupByLibrary.simpleMessage("Inactive"),
        "studentTitle": MessageLookupByLibrary.simpleMessage("Student"),
        "studyPeriodList":
            MessageLookupByLibrary.simpleMessage("Study Periods"),
        "studyPeriodTitle":
            MessageLookupByLibrary.simpleMessage("Study Period"),
        "studyPeriodTypeTitle":
            MessageLookupByLibrary.simpleMessage("Study Period Type"),
        "tabScheduleHomeworksTitle":
            MessageLookupByLibrary.simpleMessage("Schedule/HW"),
        "tabStudentsPerformance":
            MessageLookupByLibrary.simpleMessage("Performance"),
        "tillTimeTitle": MessageLookupByLibrary.simpleMessage("Till time"),
        "tillTitle": MessageLookupByLibrary.simpleMessage("Till"),
        "todateTitle": MessageLookupByLibrary.simpleMessage("TBD till"),
        "updateMarkTitle": MessageLookupByLibrary.simpleMessage("Update Mark"),
        "userProfileTitle":
            MessageLookupByLibrary.simpleMessage("User profile"),
        "venueList": MessageLookupByLibrary.simpleMessage("Venues"),
        "venueName": MessageLookupByLibrary.simpleMessage("Venue"),
        "weekSchedule": MessageLookupByLibrary.simpleMessage(
            "Student Classes Schedules Info")
      };
}
