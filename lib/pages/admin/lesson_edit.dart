import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/model/lesson_model.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:schoosch/pages/admin/curriculum_edit.dart';
import 'package:schoosch/pages/admin/curriculum_list.dart';
import 'package:schoosch/pages/admin/venue_edit.dart';
import 'package:schoosch/pages/admin/venue_list.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/selectablevaluedropdown_field.dart';
import 'package:schoosch/widgets/utils.dart';

class LessonPage extends StatefulWidget {
  final LessonModel _lesson;
  final String _title;

  const LessonPage(this._lesson, this._title, {Key? key}) : super(key: key);

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  final _formKey = GlobalKey<FormState>();
  CurriculumModel? curriculum;
  VenueModel? venue;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var loc = S.of(context);
    return Scaffold(
      appBar: MAppBar(
        widget._title,
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
                SelectableValueDropdownFormField<CurriculumModel>(
                  title: loc.curriculumName,
                  initFutureFunc: _initCurriculum,
                  initOptionsFutureFunc: _initCurriculumOptions,
                  titleFunc: (value) => value?.name ?? '',
                  listFunc: () => CurriculumListPage(
                    InstitutionModel.currentInstitution,
                    selectionMode: true,
                  ),
                  detailsFunc: () => CurriculumPage(curriculum!, curriculum!.name),
                  validatorFunc: (value) => Utils.validateTextNotEmpty(value, loc.errorCurriculumEmpty),
                  callback: (value) => _setCurriculum(value),
                ),
                SelectableValueDropdownFormField<VenueModel>(
                  title: loc.venueName,
                  initFutureFunc: _initVenue,
                  initOptionsFutureFunc: _initVenueOptions,
                  titleFunc: (value) => value?.name ?? '',
                  listFunc: () => VenueListPage(
                    InstitutionModel.currentInstitution,
                    selectionMode: true,
                  ),
                  detailsFunc: () => VenuePage(venue!, venue!.name),
                  validatorFunc: (value) => Utils.validateTextNotEmpty(value, loc.errorVenueEmpty),
                  callback: (value) => _setVenue(value),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ElevatedButton(
                    child: Text(loc.saveChanges),
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

  Future<List<CurriculumModel>> _initCurriculumOptions() {
    return InstitutionModel.currentInstitution.curriculums();
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

  Future<List<VenueModel>> _initVenueOptions() {
    return InstitutionModel.currentInstitution.venues;
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
      // await nlesson.save();
      Get.back<LessonModel>(result: nlesson);
    }
  }

  Future<void> _delete(LessonModel lesson) async {}
}
