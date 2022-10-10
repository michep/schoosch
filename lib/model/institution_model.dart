import 'package:get/get.dart';
import 'package:schoosch/controller/proxy_controller.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/daylessontime_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/venue_model.dart';

class InstitutionModel {
  final String id;
  late final String name;
  late final String address;
  final Map<String, String> attributes = {};
  final List<CurriculumModel> _curriculums = [];
  bool _curriculumsLoaded = false;

  InstitutionModel.fromMap(this.id, Map<String, dynamic> map) {
    name = map['name'] != null ? map['name'] as String : throw 'need name key in institution $id';
    address = map['address'] != null ? map['address'] as String : '';
  }

  static InstitutionModel get currentInstitution => Get.find<ProxyStore>().currentInstitution!;

  Future<List<VenueModel>> get venues async {
    return Get.find<ProxyStore>().getAllVenues();
  }

  Future<List<PersonModel>> people() async {
    return Get.find<ProxyStore>().getAllPeople();
  }

  Future<PersonModel> getPerson(String id) async {
    return Get.find<ProxyStore>().getPerson(id);
  }

  Future<List<ClassModel>> get classes async {
    return Get.find<ProxyStore>().getAllClasses();
  }

  Future<List<CurriculumModel>> curriculums({bool forceRefresh = false}) async {
    if (!_curriculumsLoaded || forceRefresh) {
      var curs = await Get.find<ProxyStore>().getAllCurriculums();
      _curriculums.addAll(curs);
      _curriculumsLoaded = true;
    }
    return _curriculums;
  }

  Future<List<DayLessontimeModel>> get daylessontimes async {
    return Get.find<ProxyStore>().getAllDayLessontime();
  }

  // Future<void> createChatRoom(PersonModel other) async {
  //   return await Get.find<MStore>().createChatRoom(other);
  // }

  // Future<List<PersonModel>> findFreeTeachers(DateTime date, int order) async {
  //   return await Get.find<MStore>().getFreeTeachersOnLesson(date, order);
  // }

  // Future<List<PersonModel>> getUsersByName(String query) async {
  //   return Get.find<MStore>().getPeopleByName(query);
  // }
}
