import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/proxy_controller.dart';
import 'package:schoosch/model/attachments_model.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/daylessontime_model.dart';
import 'package:schoosch/model/marktype_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/studyperiod_model.dart';
import 'package:schoosch/model/venue_model.dart';

class InstitutionModel {
  final String id;
  late final String name;
  late final String address;
  late final AttachmentModel? logo;
  final Map<String, String> attributes = {};
  final List<CurriculumModel> _curriculums = [];
  bool _curriculumsLoaded = false;
  bool _yearPeriodLoaded = false;
  bool _semesterPeriodsLoaded = false;
  late final StudyPeriodModel? _yearPeriod;
  final List<StudyPeriodModel> _semesterPeriods = [];
  final List<MarkType> _markTypes = [];

  final Map<String, Uint8List> _files = {};

  InstitutionModel.fromMap(this.id, Map<String, dynamic> map) {
    name = map['name'] != null ? map['name'] as String : throw 'need name key in institution $id';
    address = map['address'] != null ? map['address'] as String : '';

    if (map.containsKey('logo') && map['logo'] is Map) {
      logo = AttachmentModel.fromMap(map['logo']['_id'], map['logo']);
    } else {
      logo = null;
    }
  }

  static InstitutionModel get currentInstitution => Get.find<ProxyStore>().currentInstitution!;

  Future<void> prefetchMarkTypes() async {
    _markTypes.addAll(await Get.find<ProxyStore>().getAllMarktypes());
  }

  Future<List<VenueModel>> get venues async {
    return Get.find<ProxyStore>().getAllVenues();
  }

  Future<List<MarkType>> get marktypes async {
    return Get.find<ProxyStore>().getAllMarktypes();
  }

  Future<List<StudyPeriodModel>> get studyperiods async {
    return Get.find<ProxyStore>().getAllStudyPeriods();
  }

  Future<StudyPeriodModel?> get currentYearPeriod async {
    if (!_yearPeriodLoaded) {
      _yearPeriod = await Get.find<ProxyStore>().getYearPeriodForDate(DateTime.now());
      _yearPeriodLoaded = true;
    }
    return _yearPeriod;
  }

  // Future<StudyPeriodModel?> get currentSemesterPeriod async {
  //   return Get.find<ProxyStore>().getSemesterPeriodForDate(DateTime.now());
  // }

  Future<List<StudyPeriodModel>> get currentYearSemesterPeriods async {
    if (!_semesterPeriodsLoaded) {
      _semesterPeriods.addAll(
        await Get.find<ProxyStore>().getSemesterPeriodsForPeriod(
          (await currentYearPeriod)!,
        ),
      );
      _semesterPeriodsLoaded = true;
    }
    return _semesterPeriods;
  }

  Future<List<StudyPeriodModel>> get currentYearAndSemestersPeriods async {
    return [...(await currentYearSemesterPeriods), (await currentYearPeriod)!];
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
      _curriculums.clear();
      _curriculums.addAll(curs);
      _curriculumsLoaded = true;
    }
    return _curriculums;
  }

  Future<List<DayLessontimeModel>> get daylessontimes async {
    return Get.find<ProxyStore>().getAllDayLessontime();
  }

  Future<Uint8List?> getFile(AttachmentModel? attachment) async {
    if (attachment == null) {
      return null;
    }
    if (!_files.keys.contains(id)) {
      var data = await Get.find<ProxyStore>().getFileData(attachment);
      _files.addAll({id: data});
    }
    return _files[id]!;
  }

  List<MarkType> get marktypesSync => _markTypes;

  MarkType getMarkTypeFromId(String id) {
    return _markTypes.firstWhere(
      (element) => element.id == id,
      orElse: () => MarkType.empty(),
    );
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
