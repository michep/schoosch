import 'package:directed_graph/directed_graph.dart';
import 'package:flutter/cupertino.dart';
import 'package:schoosch/model/node_model.dart';

final Map<String, NodeModel> _n = {
  '207': NodeModel(name: '207', floor: 2, position: const Offset(170, 72),),
  'K1': NodeModel(floor: 2, position: const Offset(170, 166),),
  'WC': NodeModel(name: 'WC', floor: 2, position: const Offset(170, 256),),
  '205': NodeModel(name: '205', floor: 2, position: const Offset(310, 72),),
  'K2': NodeModel(floor: 1, position: const Offset(310, 166),),
  '211': NodeModel(name: '211', floor: 2, position: const Offset(310, 256),),
  '210': NodeModel(name: '210', floor: 2, position: const Offset(386, 256),),
  '204': NodeModel(name: '204', floor: 2, position: const Offset(470, 72),),
  'K3': NodeModel(floor: 1, position: const Offset(470, 166),),
  '203': NodeModel(name: '203', floor: 2, position: const Offset(610, 72),),
  'K4': NodeModel(floor: 2, position: const Offset(610, 166),),
  '208': NodeModel(name: '208', floor: 2, position: const Offset(610, 256),),
  '202': NodeModel(name: '202', floor: 2, position: const Offset(750, 72),),
  'K5': NodeModel(floor: 1, position: const Offset(750, 166),),
};

final Map<NodeModel, Set<NodeModel>> _dummy_graph = {
  _n['207']!: {_n['K1']!,},
  _n['K1']!: {_n['WC']!, _n['K2']!,},
  _n['K2']!: {_n['205']!, _n['211']!, _n['K3']!},
  _n['211']!: {_n['210']!},
  _n['K3']!: {_n['204']!, _n['K4']!},
  _n['K4']!: {_n['203']!, _n['208']!, _n['K5']!},
  _n['K5']!: {_n['202']!},
};

final BidirectedGraph<NodeModel> bg = BidirectedGraph<NodeModel>(_dummy_graph);

List<NodeModel> testPath(String start, String finish) {
  return bg.shortestPath(_n[start]!, _n[finish]!).toList();
}
