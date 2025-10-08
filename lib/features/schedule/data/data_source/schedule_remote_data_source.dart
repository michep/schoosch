import 'package:get/get.dart';
import 'package:isoweek/isoweek.dart';
import 'package:schoosch/core/providers/base_dio_functions.dart';
import 'package:schoosch/features/class/domain/model/class_model.dart';
import 'package:schoosch/features/schedule/domain/model/schedule_model.dart';
import 'package:schoosch/features/week/presentation/controller/week_controller.dart';
import 'package:schoosch/old/model/institution_model.dart';

final class ScheduleRemoteDataSource {

  Future<void> init(InstitutionModel institution) async {}

  Future<List<ClassScheduleModel>> getClassWeekSchedule(ClassModel aclass, Week currentWeek) async {
    var curweek = Get.find<WeekController>().currentWeek;
    var js = await BaseDioFunctions.getList(path: '/class/${aclass.id}}/weekschedule/${curweek.day(0).toIso8601String()}');
    return js.map((e) => ClassScheduleModel.fromMap(aclass, e['_id'], e)).toList();
  }

  Future<List<StudentScheduleModel>> getStudentWeekSchedule(ClassModel aclass, String studentId, Week currentWeek) async {
    var curweek = Get.find<WeekController>().currentWeek;
    var js = await BaseDioFunctions.get(path: '/class/${aclass.id}/weekschedule/${curweek.day(0).toIso8601String()}/student/$studentId');
    return (js as List<dynamic>).map((e) => StudentScheduleModel.fromMap(aclass, e['_id'], e)).toList();
  }

  Future<List<TeacherScheduleModel>> getTeacherWeekSchedule(String teacherId, Week currentWeek) async {
    var curweek = Get.find<WeekController>().currentWeek;
    var js = await BaseDioFunctions.getList(path: '/person/$teacherId/teacher/weekschedule/${curweek.day(0).toIso8601String()}');
    return js.map((e) => TeacherScheduleModel.fromMap(e['schedule_id'], e)).toList();
  }
}
