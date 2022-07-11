import 'package:get/get.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/model/lessontime_model.dart';

class DayLessontimeModel {
  late String? _id;
  late String name;
  final List<LessontimeModel> _lessontimes = [];
  bool _lessontimesLoaded = false;

  String? get id => _id;

  @override
  String toString() {
    return name;
  }

  DayLessontimeModel.fromMap(this._id, Map<String, Object?> map) {
    name = map['name'] != null ? map['name'] as String : throw 'need name key in daylessontime $_id';
  }

  Future<List<LessontimeModel>> get lessontimes async {
    if (!_lessontimesLoaded) {
      _lessontimes.addAll(await Get.find<FStore>().getLessontime(_id!));
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
    var id = await Get.find<FStore>().saveDayLessontime(this);
    _id ??= id;
    return this;
  }
}
