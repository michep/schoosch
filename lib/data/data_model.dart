import 'package:get/get.dart';
import 'package:schoosch/data/class_model.dart';
import 'package:schoosch/data/curriculum_model.dart';
import 'package:schoosch/data/firestore.dart';
import 'package:schoosch/data/people_model.dart';
import 'package:schoosch/data/studygroup_model.dart';
import 'package:schoosch/data/venue_model.dart';

class DataModel extends GetxController {
  final String _id;
  final String _name;
  final String _address;
  final String _inn;
  final Map<String, String> _attributes;
  final List<PeopleModel> _people;
  final List<VenueModel> _venue;
  final List<CurriculumModel> _curriculum;
  final List<StudyGroupModel> _studygroup;
  final List<ClassModel> _learningclass;

  final String _currentuseruid;
  late final FStore _data;

  Future<void> init() async {
    _data = FStore();
    _data.init();
  }

  DataModel(
    this._id,
    this._name,
    this._address,
    this._inn,
    this._attributes,
    this._people,
    this._venue,
    this._curriculum,
    this._studygroup,
    this._learningclass,
    this._currentuseruid,
  );

  DataModel.empty() : this('', '', '', '', {}, [], [], [], [], [], '');

  Future<List<ClassModel>> get learningclass async {
    return _learningclass;
  }
}
