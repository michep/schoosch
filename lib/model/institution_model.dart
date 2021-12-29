import 'package:get/get.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/daylessontime_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/venue_model.dart';

class InstitutionModel {
  late final String id;
  late final String name;
  late final String address;
  late final Map<String, String> attributes;

  InstitutionModel.fromMap(this.id, Map<String, dynamic> map) {
    name = map['name'] != null ? map['name'] as String : throw 'need name key in institution $id';
    address = map['address'] != null ? map['address'] as String : '';
  }

  static InstitutionModel get currentInstitution => Get.find<FStore>().currentInstitution!;

  Future<List<VenueModel>> get venues async {
    return Get.find<FStore>().getAllVenues();
  }

  Future<List<PersonModel>> get people async {
    return Get.find<FStore>().getAllPeople();
  }

  Future<List<ClassModel>> get classes async {
    return Get.find<FStore>().getAllClasses();
  }

  Future<List<CurriculumModel>> get curriculums async {
    return Get.find<FStore>().getAllCurriculums();
  }

  Future<List<DayLessontimeModel>> get daylessontimes async {
    return Get.find<FStore>().getAllDayLessontime();
  }
}
