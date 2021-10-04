import 'package:get/get.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:schoosch/data/lesson_model.dart';
import 'package:schoosch/data/lessontime_model.dart';
import 'package:schoosch/data/schedule_model.dart';
import 'package:schoosch/data/weekday_model.dart';
import 'package:schoosch/data/class_model.dart';
import 'package:schoosch/data/datasource_interface.dart';

class MDB extends GetxController implements SchooschDatasource {
  late final Db db;
  final List<WeekdaysModel> _weekdaysCache = [];
  final List<LessontimeModel> _lessontimesCache = [];

  @override
  Future<void> init() async {
    db = await Db.create('mongodb+srv://admin:1qaz2wsx@cluster0.3zgxn.mongodb.net/schoosch?retryWrites=true&w=majority');
    await db.open();
    await getWeekdayNameModels();
    await getLessontimeModels();
  }

  @override
  Future<void> getWeekdayNameModels() async {
    var _weekdays = await db.collection('weekdays').find().toList();
    for (var _weekday in _weekdays) {
      _weekdaysCache.add(WeekdaysModel(_weekday['_id'].toString(), _weekday['name']));
    }
  }

  @override
  Future<void> getLessontimeModels() async {
    var _lessontimes = await db.collection('lessontime').find().toList();
    for (var _lessontime in _lessontimes) {
      _lessontimesCache.add(LessontimeModel(_lessontime['_id'].toString(), _lessontime['from'], _lessontime['till']));
    }
  }

  @override
  Future<WeekdaysModel> getWeekdayNameModel(int order) async {
    return _weekdaysCache[order - 1];
  }

  @override
  Future<LessontimeModel> getLessontimeModel(int order) async {
    return _lessontimesCache[order - 1];
  }

  @override
  Future<List<ClassModel>> getClassesModel() async {
    return db.collection('class').find().map<ClassModel>((event) => ClassModel.fromMap((event['_id'] as ObjectId).$oid, event)).toList();
  }

  @override
  Future<List<ScheduleModel>> getSchedulesModel(String classId) async {
    return db
        .collection('schedule')
        .find({'class_id': classId})
        .map<ScheduleModel>((event) => ScheduleModel.fromMap(event['_id'].toString(), event))
        .toList();
  }

  @override
  Future<List<ScheduleModel>> getSchedulesWithLessonsModel(String classId) async {
    return db
        .collection('schedule')
        .modernAggregate(AggregationPipelineBuilder()
            .addStage(
              Match(Expr(Eq(const Field('class_id'), ObjectId.parse(classId)))),
            )
            .addStage(
              Lookup(from: 'lesson', localField: 'lesson_ids', foreignField: '_id', as: 'lessons'),
            )
            .build())
        .asyncMap<ScheduleModel>((_sched) async {
      List<LessonModel> _lessmods = [];

      for (var _less in _sched['lessons']) {
        var _time = await getLessontimeModel(_sched['day']);
        Map<String, dynamic> _tm = {'timeFrom': _time.from, 'timeTill': _time.till};
        _tm.addAll(_less);
        _lessmods.add(LessonModel.fromMap(_less['_id'].toString(), _tm));
      }
      return ScheduleModel.fromMap(
        _sched['_id'].toString(),
        _sched,
        _lessmods,
      );
    }).toList();
  }

  @override
  Future<void> updateLesson(LessonModel lesson) {
    // TODO: implement updateLesson
    throw UnimplementedError();
  }
}
