import 'package:get/get.dart';
import 'package:schoosch/controller/proxy_controller.dart';

class VenueModel {
  late String? _id;
  late String name;
  // late int? floor;
  // late String? type;
  // List<Offset> coords = [];
  // late Offset _labelOffset;
  // late var path = Path();

  String? get id => _id;

  @override
  String toString() {
    return name;
  }

  VenueModel.empty()
      : this.fromMap(null, <String, dynamic>{
          'name': '',
        });

  VenueModel.fromMap(this._id, Map<String, Object?> map) {
    name = map['name'] != null ? map['name'] as String : throw 'need name key in venue $id';
    // floor = map['floor'] != null
    //     ? map['floor'] as int
    //     : throw 'need floor key in venue $id';
    // type = map['type'] != null
    //     ? map['type'] as String
    //     : throw 'need type key in venue $id';
    // if (!['room', 'floor'].contains(type)) throw 'incorrect type in venue $_id';
    // if (map['coords'] != null) {
    //   var listCoords = map['coords'] as List<dynamic>;
    //   for (var i = 0; i < listCoords.length; i = i + 2) {
    //     coords.add(Offset(
    //         (listCoords[i] as int).toDouble(), (listCoords[i + 1] as int).toDouble()));
    //   }
    // } else {
    //   throw 'need coords key in venue $id';
    // }
    // if (map['offset'] != null) {
    //   var listOffset = map['offset'] as List<dynamic>;
    //     _labelOffset = Offset((listOffset[0] as int).toDouble(), (listOffset[1] as int).toDouble());
    // } else {
    //   throw 'need offset key in venue $id';
    // }
    // _initPath();
  }

  Map<String, dynamic> toMap({bool withId = false}) {
    Map<String, dynamic> res = {};
    if (withId) res['_id'] = id;
    res['name'] = name;
    return res;
  }

  Future<VenueModel> save() async {
    var id = await Get.find<ProxyStore>().saveVenue(this);
    _id ??= id;
    return this;
  }

  Future<void> delete() async {
    if (_id != null) return Get.find<ProxyStore>().deleteVenue(this);
  }

  // void _initPath() {
  //   path.moveTo(coords[0].dx, coords[0].dy);
  //   for (int i = 1; i <= coords.length; i++) {
  //     path.lineTo(coords[i - 1].dx, coords[i - 1].dy);
  //   }
  //   path.close();
  // }

  // void paint(Canvas canvas, Color color) {
  //   var paint = Paint()
  //     ..strokeJoin = StrokeJoin.round
  //     ..color = color
  //     ..strokeWidth = 5
  //     ..style = PaintingStyle.stroke;
  //   canvas.drawPath(path, paint);

  //   var ts = TextSpan(
  //     text: name,
  //     style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
  //   );
  //   var tp = TextPainter(text: ts, textDirection: TextDirection.ltr)..layout(maxWidth: 200);

  //   tp.paint(canvas, Offset(_labelOffset.dx - tp.width / 2, _labelOffset.dy - tp.height / 2));
  // }
}
