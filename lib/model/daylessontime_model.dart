import 'package:get/get.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/model/lessontime_model.dart';

class DayLessontimeModel {
  String? id;
  late String name;
  final List<LessontimeModel> _lessontimes = [];
  bool _lessontimesLoaded = false;

  DayLessontimeModel.fromMap(this.id, Map<String, Object?> map) {
    name = map['name'] != null ? map['name'] as String : throw 'need name key in daylessontime $id';
  }

  Future<List<LessontimeModel>> get lessontimes async {
    if (!_lessontimesLoaded) {
      _lessontimes.addAll(await Get.find<FStore>().getLessontime(id!));
      _lessontimesLoaded = true;
    }
    return _lessontimes;
  }
}
