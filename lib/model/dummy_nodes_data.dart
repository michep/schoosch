// import 'package:directed_graph/directed_graph.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:schoosch/model/node_model.dart';

// final Map<String, NodeModel> _n = {
//   'L2': NodeModel(floor: 2, position: const Offset(70, 166)),
//   '207': NodeModel(name: '207', floor: 2, position: const Offset(170, 72),),
//   'K1': NodeModel(floor: 2, position: const Offset(170, 166),),
//   'WC2': NodeModel(name: 'WC2', floor: 2, position: const Offset(170, 256),),
//   '205': NodeModel(name: '205', floor: 2, position: const Offset(310, 72),),
//   'K2': NodeModel(floor: 2, position: const Offset(310, 166),),
//   '211': NodeModel(name: '211', floor: 2, position: const Offset(310, 256),),
//   '210': NodeModel(name: '210', floor: 2, position: const Offset(386, 256),),
//   '204': NodeModel(name: '204', floor: 2, position: const Offset(470, 72),),
//   'K3': NodeModel(floor: 2, position: const Offset(470, 166),),
//   '203': NodeModel(name: '203', floor: 2, position: const Offset(610, 72),),
//   'K4': NodeModel(floor: 2, position: const Offset(610, 166),),
//   '208': NodeModel(name: '208', floor: 2, position: const Offset(610, 256),),
//   '202': NodeModel(name: '202', floor: 2, position: const Offset(750, 72),),
//   'K5': NodeModel(floor: 2, position: const Offset(750, 166),),

//   'L1': NodeModel(floor: 1, position: const Offset(70, 166)),
//   '107': NodeModel(name: '107', floor: 1, position: const Offset(170, 72),),
//   'K6': NodeModel(floor: 1, position: const Offset(170, 166),),
//   'WC1': NodeModel(name: 'WC1', floor: 1, position: const Offset(170, 256),),
//   '105': NodeModel(name: '105', floor: 1, position: const Offset(310, 72),),
//   'K7': NodeModel(floor: 1, position: const Offset(310, 166),),
//   '110': NodeModel(name: '110', floor: 1, position: const Offset(310, 256),),
//   '104': NodeModel(name: '104', floor: 1, position: const Offset(470, 72),),
//   'K8': NodeModel(floor: 1, position: const Offset(470, 166),),
//   '103': NodeModel(name: '103', floor: 1, position: const Offset(610, 72),),
//   'K9': NodeModel(floor: 1, position: const Offset(610, 166),),
//   '108': NodeModel(name: '108', floor: 1, position: const Offset(610, 256),),
//   '102': NodeModel(name: '102', floor: 1, position: const Offset(750, 72),),
//   'K10': NodeModel(floor: 1, position: const Offset(750, 166),),
// };

// final Map<NodeModel, Set<NodeModel>> _dummy_graph = {
//   _n['207']!: {_n['K1']!,},
//   _n['K1']!: {_n['WC2']!, _n['K2']!, _n['L2']!},
//   _n['K2']!: {_n['205']!, _n['211']!, _n['K3']!},
//   _n['211']!: {_n['210']!},
//   _n['K3']!: {_n['204']!, _n['K4']!},
//   _n['K4']!: {_n['203']!, _n['208']!, _n['K5']!},
//   _n['K5']!: {_n['202']!},

//   _n['L2']!: {_n['L1']!}, 

//   _n['107']!: {_n['K6']!,},
//   _n['K6']!: {_n['WC1']!, _n['K7']!, _n['L1']!},
//   _n['K7']!: {_n['105']!, _n['110']!, _n['K8']!},
//   _n['K8']!: {_n['104']!, _n['K9']!},
//   _n['K9']!: {_n['103']!, _n['108']!, _n['K10']!},
//   _n['K10']!: {_n['102']!},
// };

// final BidirectedGraph<NodeModel> bg = BidirectedGraph<NodeModel>(_dummy_graph);

// List<NodeModel> testPath(String start, String finish) {
//   return bg.shortestPath(_n[start]!, _n[finish]!).toList();
// }
