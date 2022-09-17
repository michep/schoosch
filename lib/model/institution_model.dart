import 'package:get/get.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:schoosch/controller/mongo_controller.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/daylessontime_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/venue_model.dart';

class InstitutionModel {
  final ObjectId id;
  late final String name;
  late final String address;
  final Map<String, String> attributes = {};

  InstitutionModel.fromMap(this.id, Map<String, dynamic> map) {
    name = map['name'] != null ? map['name'] as String : throw 'need name key in institution $id';
    address = map['address'] != null ? map['address'] as String : '';
  }

  static InstitutionModel get currentInstitution => Get.find<MStore>().currentInstitution!;

  Future<List<VenueModel>> get venues async {
    return Get.find<MStore>().getAllVenues();
  }

  Future<List<PersonModel>> people() async {
    return Get.find<MStore>().getAllPeople();
  }

  Future<PersonModel> getPerson(ObjectId id) async {
    return Get.find<MStore>().getPerson(id);
  }

  Future<List<ClassModel>> get classes async {
    return Get.find<MStore>().getAllClasses();
  }

  Future<List<CurriculumModel>> get curriculums async {
    return Get.find<MStore>().getAllCurriculums();
  }

  Future<List<DayLessontimeModel>> get daylessontimes async {
    return Get.find<MStore>().getAllDayLessontime();
  }

  Future<void> createChatRoom(PersonModel other) async {
    return await Get.find<MStore>().createChatRoom(other);
  }

  Future<List<PersonModel>> findFreeTeachers(DateTime date, int order) async {
    return await Get.find<MStore>().getFreeTeachersOnLesson(date, order);
  }

  // Future<List<PersonModel>> getUsersByName(String query) async {
  //   return Get.find<MStore>().getPeopleByName(query);
  // }
}
