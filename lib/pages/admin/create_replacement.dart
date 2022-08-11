// import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/model/venue_model.dart';
import 'package:schoosch/widgets/selectablevaluedropdown_field.dart';
import 'package:schoosch/widgets/utils.dart';

class CreateReplacement extends StatefulWidget {
  final ClassModel aclass;
  const CreateReplacement(this.aclass, {Key? key}) : super(key: key);

  @override
  State<CreateReplacement> createState() => _CreateReplacementState();
}

class _CreateReplacementState extends State<CreateReplacement> {
  DateTime? date;
  PersonModel? newTeacher;
  CurriculumModel? newCurriculum;
  int? newOrder;
  VenueModel? newVenue;
  final _formKey = GlobalKey<FormState>();

  TextEditingController dateCont = TextEditingController();
  TextEditingController orderCont = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var loc = S.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              children: [
                TextFormField(
                  controller: dateCont,
                  onTap: () => showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(DateTime.now().year - 1),
                    lastDate: DateTime(DateTime.now().year + 1),
                  ).then((value) {
                    if (value != null) {
                      date = value;
                      dateCont.text = DateFormat('dd/MM/yyyy').format(value);
                    }
                  }),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'нужно указать дату заменяемого урока.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: orderCont,
                  keyboardType: TextInputType.number,
                  onChanged: (v) {
                    newOrder = int.parse(v);
                  },
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'нужно указать номер заменяемого урока.';
                    }
                    return null;
                  },
                ),
                SelectableValueDropdownFormField<CurriculumModel>(
                  title: loc.curriculumName,
                  initFutureFunc: _initCurriculum,
                  initOptionsFutureFunc: _initCurriculumOptions,
                  listFunc: () => Container(),
                  titleFunc: (value) => value?.aliasOrName ?? '',
                  callback: _setCurriculum,
                  validatorFunc: (v) {
                    if (v == null) {
                      return 'нужно выбрать урок на замену.';
                    }
                    return null;
                  },
                ),
                SelectableValueDropdownFormField<VenueModel>(
                  title: loc.venueName,
                  initFutureFunc: _initVenue,
                  initOptionsFutureFunc: _initVenueOptions,
                  listFunc: () => Container(),
                  titleFunc: (value) => value?.name ?? '',
                  callback: _setVenue,
                  validatorFunc: (v) {
                    if (v == null) {
                      return 'нужно выбрать кабинет на замену.';
                    }
                    return null;
                  },
                ),
                SelectableValueDropdownFormField<PersonModel>(
                  title: loc.curriculumTeacher,
                  initFutureFunc: _initMaster,
                  initOptionsFutureFunc: _initMasterOptions,
                  titleFunc: (value) => value?.fullName ?? '',
                  listFunc: () => Container(),
                  callback: (value) => _setMaster(value),
                  validatorFunc: (v) {
                    if (v == null) {
                      return 'нужно выбрать учителя на замену.';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            await saveForm();
                          },
                    child: isLoading ? Utils.progressIndicator() : Text(loc.saveChanges),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> saveForm() async {
    bool isValid = _formKey.currentState!.validate();
    if (isValid) {
      setState(() {
        isLoading = true;
      });
      await _createReplacement({
        'order': newOrder,
        'curriculum_id': newCurriculum!.id,
        'venue_id': newVenue!.id,
        'teacher_id': newTeacher!.id,
        'date': date,
      }).whenComplete(() {
        setState(() {
          isLoading = false;
          Get.back();
        });
      });
    }
  }

  Future<void> _createReplacement(Map<String, dynamic> map) async {
    widget.aclass.createReplacement(map);
  }

  Future<CurriculumModel?> _initCurriculum() async {
    return newCurriculum;
  }

  Future<List<CurriculumModel>> _initCurriculumOptions() {
    return InstitutionModel.currentInstitution.curriculums;
  }

  bool _setCurriculum(CurriculumModel? value) {
    newCurriculum = value;
    return true;
  }

  Future<VenueModel?> _initVenue() async {
    return newVenue;
  }

  Future<List<VenueModel>> _initVenueOptions() {
    return InstitutionModel.currentInstitution.venues;
  }

  bool _setVenue(VenueModel? value) {
    newVenue = value;
    return true;
  }

  Future<PersonModel?> _initMaster() async {
    return newTeacher;
  }

  Future<List<PersonModel>> _initMasterOptions() async {
    var ppl = await InstitutionModel.currentInstitution.people();
    return ppl.where((element) => element.asTeacher != null).toList();
  }

  bool _setMaster(PersonModel? value) {
    if (value != null) {
      if (value.asTeacher != null) {
        newTeacher = value.asTeacher;
        return true;
      } else {
        if (value is TeacherModel) {
          newTeacher = (value);
          return true;
        } else {
          newTeacher = null;
          Utils.showErrorSnackbar(S.of(context).errorPersonIsNotATeacher);
          return false;
        }
      }
    } else {
      newTeacher = null;
      return true;
    }
  }
}
