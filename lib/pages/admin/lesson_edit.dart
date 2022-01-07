import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:schoosch/pages/admin/curriculum_edit.dart';
import 'package:schoosch/pages/admin/curriculum_list.dart';
import 'package:schoosch/pages/admin/venue_edit.dart';
import 'package:schoosch/pages/admin/venue_list.dart';
import 'package:schoosch/widgets/selectablevalue_field.dart';
import 'package:schoosch/widgets/utils.dart';

class LessonPage extends StatefulWidget {
  final LessonModel _lesson;
  final String _title;

  const LessonPage(this._lesson, this._title, {Key? key}) : super(key: key);

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  // final TextEditingController _order = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  CurriculumModel? curriculum;
  VenueModel? venue;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._title),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _delete(widget._lesson),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              children: [
                SelectableValueFormField<CurriculumModel>(
                  title: 'Учебный предмет',
                  initFutureFunc: _initCurriculum,
                  titleFunc: (value) => value?.name ?? '',
                  listFunc: () => CurriculumListPage(
                    InstitutionModel.currentInstitution,
                    selectionMode: true,
                  ),
                  detailsFunc: () => CurriculumPage(curriculum!, curriculum!.name),
                  validatorFunc: (value) => Utils.validateTextNotEmpty(value, 'Учебный предмет должен быть выбран'),
                  callback: (value) => _setCurriculum(value),
                ),
                SelectableValueFormField<VenueModel>(
                  title: 'Кабинет',
                  initFutureFunc: _initVenue,
                  titleFunc: (value) => value?.name ?? '',
                  listFunc: () => VenueListPage(
                    InstitutionModel.currentInstitution,
                    selectionMode: true,
                  ),
                  detailsFunc: () => VenuePage(venue!, venue!.name),
                  validatorFunc: (value) => Utils.validateTextNotEmpty(value, 'Кабинет должен быть выбран'),
                  callback: (value) => _setVenue(value),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ElevatedButton(
                    child: const Text('Сохранить изменения'),
                    onPressed: () => _save(widget._lesson),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<CurriculumModel?> _initCurriculum() {
    return widget._lesson.curriculum.then((value) {
      curriculum = value;
      return curriculum;
    });
  }

  bool _setCurriculum(CurriculumModel? value) {
    curriculum = value;
    return true;
  }

  Future<VenueModel?> _initVenue() {
    return widget._lesson.venue.then((value) {
      venue = value;
      return venue;
    });
  }

  bool _setVenue(VenueModel? value) {
    venue = value;
    return true;
  }

  Future<void> _save(LessonModel lesson) async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> map = {};
      map['order'] = lesson.order;
      map['curriculum_id'] = curriculum!.id;
      map['venue_id'] = venue!.id;
      var nlesson = LessonModel.fromMap(lesson.aclass, lesson.schedule, lesson.id, map);
      await nlesson.save();
      Get.back<LessonModel>(result: nlesson);
    }
  }

  Future<void> _delete(LessonModel lesson) async {}
}
