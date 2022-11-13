import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/proxy_controller.dart';
import 'package:schoosch/model/daylessontime_model.dart';
import 'package:schoosch/widgets/utils.dart';

class LessontimeModel {
  String? id;
  late int order;
  late TimeOfDay from;
  late TimeOfDay till;

  LessontimeModel.fromMap(this.id, Map<String, Object?> map) {
    order = map['order'] != null ? map['order'] as int : throw 'need order key in lessontime $id';
    var f = map['from'] != null ? (map['from'] as String).split(':') : throw 'need from key in lessontime $id';
    if (f.length != 2) throw 'incorrect from in lessontime $id';
    var t = map['till'] != null ? (map['till'] as String).split(':') : throw 'need till key in lessontime $id';
    if (t.length != 2) throw 'incorrect till in lessontime $id';
    from = TimeOfDay(hour: int.parse(f[0]), minute: int.parse(f[1]));
    till = TimeOfDay(hour: int.parse(t[0]), minute: int.parse(t[1]));
  }

  Map<String, dynamic> toMap({bool withId = false}) {
    Map<String, dynamic> res = {};
    if (withId) res['_id'] = id;
    res['order'] = order;
    res['from'] = Utils.formatTimeOfDay(from);
    res['till'] = Utils.formatTimeOfDay(till);
    return res;
  }

  Future<LessontimeModel> save(DayLessontimeModel daylessontime) async {
    await Get.find<ProxyStore>().saveLessontime(daylessontime, this);
    return this;
  }

  Future<void> delete(DayLessontimeModel daylessontime) async {
    return Get.find<ProxyStore>().deleteLessontime(daylessontime, this);
  }

  String formatPeriod() {
    return '${Utils.formatTimeOfDay(from)} \u2014 ${Utils.formatTimeOfDay(till)}';
  }
}
