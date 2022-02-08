import 'package:flutter/material.dart';
import 'package:schoosch/model/venue_model.dart';

class Floor extends StatefulWidget {
  final List<VenueModel> blueprints;
  final String? chosenRoom;

  const Floor(this.blueprints, this.chosenRoom, {Key? key}) : super(key: key);

  @override
  _FloorState createState() => _FloorState();
}

class _FloorState extends State<Floor> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: getSize(widget.blueprints, context),
      painter: LinePainter(widget.blueprints, widget.chosenRoom),
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

  LinePainter(
    this.blueprints,
    this.chosen,
  );

  @override
  void paint(Canvas canvas, Size size) {
    for (var b in blueprints) {
      b.paint(canvas, chosen == b.name ? Colors.blue : Colors.black);
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
