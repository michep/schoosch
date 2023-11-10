import 'package:get/get.dart';
import 'package:schoosch/controller/proxy_controller.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:schoosch/model/status_enum.dart';
import 'package:schoosch/widgets/utils.dart';

enum StudyPeriodType {
  year,
  semester;

  static const _year = 'year';
  static const _semester = 'semester';

  static StudyPeriodType _parse(String value) {
    switch (value) {
      case _year:
        return StudyPeriodType.year;
      case _semester:
        return StudyPeriodType.semester;
      default:
        throw 'unkown type';
    }
  }

  String get nameString {
    switch (this) {
      case StudyPeriodType.year:
        return _year;
      case StudyPeriodType.semester:
        return _semester;
    }
  }

  String localizedName(AppLocalizations S) {
    switch (this) {
      case StudyPeriodType.year:
        return S.periodYear;
      case StudyPeriodType.semester:
        return S.periodSemester;
    }
  }
}

class StudyPeriodModel {
  String? _id;
  late final String name;
  late final DateTime from;
  late final DateTime till;
  late final StudyPeriodType type;
  late final StatusModel status;

  String? get id => _id;

  StudyPeriodModel.empty()
      : this.fromMap(null, {
          'name': '',
          'type': StudyPeriodType.year.nameString,
          'status': StatusModel.active.nameInt,
          'from': DateTime.now().toIso8601String(),
          'till': DateTime.now().toIso8601String(),
        });

  StudyPeriodModel.fromMap(this._id, Map<String, dynamic> map) {
    name = map['name'] != null ? map['name'] as String : throw 'need name key in period $id';
    map['type'] != null ? type = StudyPeriodType._parse(map['type']) : throw 'need type key in period $id';
    map['status'] != null ? status = StatusModel.parse(map['status']) : throw 'need status key in period $id';
    from = map['from'] != null
        ? DateTime.tryParse(map['from']) != null
            ? DateTime.tryParse(map['from'])!
            : throw 'from key should be datetime string in period $_id'
        : throw 'need from key in period $_id';
    till = map['till'] != null
        ? DateTime.tryParse(map['till']) != null
            ? DateTime.tryParse(map['till'])!
            : throw 'till key should be datetime string in period $_id'
        : throw 'need till key in period $_id';
  }

  String get formatPeriod {
    return Utils.formatPeriod(from, till);
  }

  Map<String, dynamic> toMap({bool withId = false, bool recursive = false}) {
    Map<String, dynamic> res = {};
    if (withId) res['_id'] = id;
    res['name'] = name;
    res['from'] = from.toIso8601String();
    res['till'] = till.toIso8601String();
    res['type'] = type.nameString;
    res['status'] = status.nameInt;
    return res;
  }

  Future<StudyPeriodModel> save() async {
    var id = await Get.find<ProxyStore>().saveStudyPeriod(this);
    _id ??= id;
    return this;
  }
}
