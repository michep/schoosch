import 'package:get/get.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/model/lessontime_model.dart';

class DayLessontimeModel {
  String? _id;
  late String name;
  final List<LessontimeModel> _lessontimes = [];
  bool _lessontimesLoaded = false;

  String? get id => _id;

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
}
