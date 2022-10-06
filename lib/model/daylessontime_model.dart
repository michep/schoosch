import 'package:get/get.dart';
import 'package:schoosch/controller/proxy_controller.dart';
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

    if (map.containsKey('time') && map['time'].runtimeType == List) {
      for (var t in map['time'] as List) {
        _lessontimes.add(LessontimeModel.fromMap(t['_id'], t));
      }
      _lessontimesLoaded = true;
    }
  }

  Future<List<LessontimeModel>> get lessontimes async {
    if (!_lessontimesLoaded) {
      _lessontimes.addAll(await Get.find<ProxyStore>().getLessontimes(_id!));
      _lessontimes.sort((a, b) => a.order.compareTo(b.order));
      _lessontimesLoaded = true;
    }
    return _lessontimes;
  }

  List<LessontimeModel>? get lessontimes_sync {
    return _lessontimesLoaded ? _lessontimes : null;
  }

  Map<String, dynamic> toMap({bool withId = false}) {
    Map<String, dynamic> res = {};
    if (withId) res['_id'] = id;
    res['name'] = name;
    return res;
  }

  Future<DayLessontimeModel> save() async {
    var id = await Get.find<ProxyStore>().saveDayLessontime(this);
    _id ??= id;
    return this;
  }
}
