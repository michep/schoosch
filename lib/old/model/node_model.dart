import 'package:flutter/cupertino.dart';

class NodeModel {
  final String id;
  late final String? name;
  late final int floor;
  late final Offset position;

  NodeModel({
    required this.id,
    this.name,
    required this.floor,
    required this.position,
  });

  NodeModel.fromMap(this.id, Map<String, dynamic> map) {
    name = map['name'] != null ? map['name'] as String : throw 'need name in node $id';
    floor = map['floor'] != null ? map['floor'] as int : throw 'need floor in node $id';
    if (map['position'] != null) {
      position = Offset((map['position'][0] as int).toDouble(), (map['position'][1] as int).toDouble());
    } else {
      throw 'need position in node $id';
    }
  }
}
