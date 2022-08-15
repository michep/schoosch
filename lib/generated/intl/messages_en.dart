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

  static String m2(order) => "${order} lesson";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "appBarTitle": MessageLookupByLibrary.simpleMessage("Schoosch"),
        "appTiile": MessageLookupByLibrary.simpleMessage(
            "Schoosch is school schedule app"),
        "classGrade": MessageLookupByLibrary.simpleMessage("Grade"),
        "classList": MessageLookupByLibrary.simpleMessage("Classes"),
        "classMaster": MessageLookupByLibrary.simpleMessage("Teacher"),
        "className": MessageLookupByLibrary.simpleMessage("Name"),
        "classSchedule": MessageLookupByLibrary.simpleMessage("Lessons Times"),
        "classScheduleName": m0,
        "classStudents": MessageLookupByLibrary.simpleMessage("Students"),
        "classStudentsTitle":
            MessageLookupByLibrary.simpleMessage("Class Students"),
        "commentTitle": MessageLookupByLibrary.simpleMessage("Comment"),
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
        "errorVenueEmpty":
            MessageLookupByLibrary.simpleMessage("Venue should be selected"),
        "fromTitle": MessageLookupByLibrary.simpleMessage("From time"),
        "lesson": MessageLookupByLibrary.simpleMessage("Lesson"),
        "lessonName": MessageLookupByLibrary.simpleMessage("Lesson"),
        "markTitle": MessageLookupByLibrary.simpleMessage("Mark"),
        "name": MessageLookupByLibrary.simpleMessage("Name"),
        "newClass": MessageLookupByLibrary.simpleMessage("New Class"),
        "newCurriculum": MessageLookupByLibrary.simpleMessage("New Curriculum"),
        "newPerson": m1,
        "newVenue": MessageLookupByLibrary.simpleMessage("New Vanue"),
        "peopleList":
            MessageLookupByLibrary.simpleMessage("Student, Teachers and other"),
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
        "saveChanges": MessageLookupByLibrary.simpleMessage("Save changes"),
        "scheduleFromDate":
            MessageLookupByLibrary.simpleMessage("Schedule start date"),
        "scheduleLessonOrder": m2,
        "scheduleNoLesson": MessageLookupByLibrary.simpleMessage("no lesson"),
        "scheduleTillDate": MessageLookupByLibrary.simpleMessage("End date"),
        "search": MessageLookupByLibrary.simpleMessage("Search"),
        "setMarkTitle": MessageLookupByLibrary.simpleMessage("Set Mark"),
        "studentTitle": MessageLookupByLibrary.simpleMessage("Student"),
        "tillTitle": MessageLookupByLibrary.simpleMessage("Till time"),
        "updateMarkTitle": MessageLookupByLibrary.simpleMessage("Update Mark"),
        "venueList": MessageLookupByLibrary.simpleMessage("Venues"),
        "venueName": MessageLookupByLibrary.simpleMessage("Venue"),
        "weekSchedule": MessageLookupByLibrary.simpleMessage(
            "Student Classes Schedules Info")
      };
}
