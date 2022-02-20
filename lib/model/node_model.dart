import 'package:flutter/cupertino.dart';

class NodeModel {
  final String? name;
  final int floor;
  final Offset position;

  NodeModel({
    this.name,
    required this.floor,
    required this.position,
  });
}