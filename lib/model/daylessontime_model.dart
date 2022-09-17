import 'package:get/get.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:schoosch/controller/mongo_controller.dart';
import 'package:schoosch/model/lessontime_model.dart';

class DayLessontimeModel {
  late ObjectId? id;
  late String name;
  final List<LessontimeModel> _lessontimes = [];
  bool _lessontimesLoaded = false;

  @override
  String toString() {
    return name;
  }

  DayLessontimeModel.fromMap(this.id, Map<String, Object?> map) {
    name = map['name'] != null ? map['name'] as String : throw 'need name key in daylessontime $id';
  }

  Future<List<LessontimeModel>> get lessontimes async {
    if (!_lessontimesLoaded) {
      _lessontimes.addAll(await Get.find<MStore>().getLessontimes(id!));
      _lessontimes.sort((a, b) => a.order.compareTo(b.order));
      _lessontimesLoaded = true;
    }
    return _lessontimes;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> res = {};
    res['name'] = name;
    return res;
  }

  Future<DayLessontimeModel> save() async {
    var nid = await Get.find<MStore>().saveDayLessontime(this);
    id ??= nid;
    return this;
  }
}
