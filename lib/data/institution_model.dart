// import 'package:get/get.dart';
// import 'package:schoosch/data/class_model.dart';
// import 'package:schoosch/data/curriculum_model.dart';
// import 'package:schoosch/data/lessontime_model.dart';
// import 'package:schoosch/data/people_model.dart';
// import 'package:schoosch/data/studygroup_model.dart';
// import 'package:schoosch/data/venue_model.dart';

// import 'fire_store.dart';

// class InstitutionModel {
//   final String _id;
//   final String _name;
//   final String _address;
//   final String _inn;
//   Map<String, String>? _attributes;
//   List<LessontimeModel>? _lessontime;
//   List<PeopleModel>? _people;
//   List<VenueModel>? _venue;
//   List<CurriculumModel>? _curriculum;
//   List<StudyGroupModel>? _studygroup;
//   List<ClassModel>? _learningclass;

//   InstitutionModel(
//     this._id,
//     this._name,
//     this._address,
//     this._inn,
//   );

//   InstitutionModel.simple() : this('', '', '', '');

//   Future<List<ClassModel>> get learningclass async {
//     if (_learningclass != null) {
//       return _learningclass!;
//     } else {
//       var data = Get.find<FStore>();
//       return [];
//     }
//   }

//   Future<List<PeopleModel>> get people async {
//     if (_people != null) {
//       return _people!;
//     } else {
//       return [];
//     }
//   }
// }
