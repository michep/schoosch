import 'package:schoosch/data/curriculum_model.dart';
import 'package:schoosch/data/lessontime_model.dart';
import 'package:schoosch/data/venue_model.dart';

class LessonModel {
  final String id;
  final CurriculumModel curriculum;
  final VenueModel venue;
  final LessontimeModel lessontime;
  bool ready;

  LessonModel(
    this.id,
    this.curriculum,
    this.venue,
    this.lessontime, [
    this.ready = false,
  ]);

  LessonModel.fromMap(String id, Map<String, Object?> map, CurriculumModel curriculum, VenueModel venue, LessontimeModel lessontime)
      : this(
          id,
          curriculum,
          venue,
          lessontime,
          map['ready'] != null ? map['ready'] as bool : false,
        );

  Map<String, dynamic> toMap() {
    return {
      'ready': ready,
    };
  }
}
