import 'package:get/get.dart';
import 'package:schoosch/controller/proxy_controller.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/widgets/utils.dart';

class StudyPeriodModel {
  String? _id;
  late final String name;
  late final DateTime from;
  late final DateTime till;
  late final PeriodType type;

  String? get id => _id;

  StudyPeriodModel.fromMap(this._id, Map<String, dynamic> map) {
    name = map['name'] != null ? map['name'] as String : throw 'need name key in period $id';
    map['type'] != null ? type = PeriodTypeExt._parse(map['type']) : throw 'need type key in period $id';
    from = map['from'] != null
        ? DateTime.tryParse(map['from']) != null
            ? DateTime.tryParse(map['from'])!
            : throw 'from key should be datetime string in period $_id'
        : throw 'need from key in period $_id';
    from = map['till'] != null
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
    res['type'] = type._nameString;
    return res;
  }

  Future<StudyPeriodModel> save() async {
    var id = await Get.find<ProxyStore>().saveStudyPeriod(this);
    _id ??= id;
    return this;
  }
}

enum PeriodType {
  year,
  semester,
}

extension PeriodTypeExt on PeriodType {
  static const _year = 'year';
  static const _semester = 'semester';

  static PeriodType _parse(String value) {
    switch (value) {
      case _year:
        return PeriodType.year;
      case _semester:
        return PeriodType.semester;
      default:
        throw 'unkown type';
    }
  }

  String get _nameString {
    switch (this) {
      case PeriodType.year:
        return _year;
      case PeriodType.semester:
        return _semester;
    }
  }

  String localizedName(S S) {
    switch (this) {
      case PeriodType.year:
        return S.periodYear;
      case PeriodType.semester:
        return S.periodSemester;
    }
  }
}
