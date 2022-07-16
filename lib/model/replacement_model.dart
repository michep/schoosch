// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:schoosch/model/curriculum_model.dart';
// import 'package:schoosch/model/person_model.dart';
// import 'package:schoosch/model/venue_model.dart';

// class ReplacementModel {
//   late final String? id;
//   late final DateTime? date;
//   late final int? lessonOrder;
//   late final PersonModel? teacher;
//   late final CurriculumModel? curriculum;
//   late final VenueModel? venue;

//   ReplacementModel.fromMap(this.id, Map<String, dynamic> map) {
//     date = map['date'] != null ? DateTime.fromMillisecondsSinceEpoch((map['date'] as Timestamp).millisecondsSinceEpoch) : throw '';
//     lessonOrder = map['lesson_order'] != null ? map['lesson_order'] as int : throw '';
//     teacher = map['teacher'] ?? null;
//     curriculum = map['curriculum'] ?? null;
//     venue = map['venue'] ?? null;
//   }
// }
