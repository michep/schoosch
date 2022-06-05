import 'package:flutter/material.dart';
// import 'package:schoosch/model/dummy_nodes_data.dart';
import 'package:schoosch/model/node_model.dart';
import 'package:schoosch/model/venue_model.dart';

class Floor extends StatefulWidget {
  final List<VenueModel> blueprints;
  final String? chosenRoom;
  final List<NodeModel?>? nodepath;

  const Floor(this.blueprints, this.chosenRoom, this.nodepath, {Key? key}) : super(key: key);

  @override
  FloorState createState() => FloorState();
}

class FloorState extends State<Floor> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: getSize(widget.blueprints, context),
      painter: LinePainter(widget.blueprints, widget.chosenRoom, nodepath: widget.nodepath),
    );
  }

  Size getSize(List<VenueModel> list, BuildContext context) {
    double maxx = 0;
    double maxy = 0;
    double minx = double.infinity;
    double miny = double.infinity;
    for (var b in list) {
      for (var i in b.coords) {
        if (i.dx > maxx) {
          maxx = i.dx;
        }
        if (i.dy > maxy) {
          maxy = i.dy;
        }
        if (i.dx < minx) {
          minx = i.dx;
        }
        if (i.dy < miny) {
          miny = i.dy;
        }
      }
    }
    double w = maxx - minx;
    double h = maxy - miny;
    // return Size(ss.width * 2 + w - 100, ss.height * 2 + h - 100);
    return Size(w, h);
  }
}

class LinePainter extends CustomPainter {
  List<VenueModel> blueprints;
  String? chosen;
  List<NodeModel?>? nodepath;

  LinePainter(
    this.blueprints,
    this.chosen, {
    required this.nodepath,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var b in blueprints) {
      b.paint(canvas, chosen == b.name ? Colors.blue : Colors.black);
    }

    // if (nodepath![0] != NodeModel(floor: 0, position: const Offset(0, 0))) {
    if (nodepath!.isNotEmpty) {
      // var floornodepath = nodepath!.where((element) => element!.floor == blueprints[0].floor).toList();
      var p = Path();
      var paint = Paint()
        ..strokeJoin = StrokeJoin.round
        ..color = Colors.red
        ..strokeWidth = 7
        ..style = PaintingStyle.stroke;
      p.moveTo(nodepath![0]!.position.dx, nodepath![0]!.position.dy);
      for (int i = 1; i < nodepath!.length; i++) {
        p.lineTo(nodepath![i]!.position.dx, nodepath![i]!.position.dy);
      }
      // p.moveTo(floornodepath[0]!.position.dx, floornodepath[0]!.position.dy);
      // for (int i = 1; i < nodepath!.length; i++) {
      //   p.lineTo(floornodepath[i]!.position.dx, floornodepath[i]!.position.dy);
      // }
      canvas.drawPath(p, paint);
    }
    // canvas.translate(1000, 1000);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  @override
  bool hitTest(Offset position) {
    return blueprints.firstWhere((element) => element.type == 'floor').path.contains(position);
  }
}
