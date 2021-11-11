import 'package:cloud_firestore/cloud_firestore.dart';

class YearweekModel {
  final String id;
  late final int order;
  late final DateTime start;
  late final DateTime end;

  YearweekModel.fromMap(this.id, Map<String, Object?> map) {
    order = map['order'] != null ? map['order'] as int : -1;
    start = map['start'] != null ? DateTime.fromMillisecondsSinceEpoch((map['start'] as Timestamp).millisecondsSinceEpoch) : DateTime(2000);
    end = map['end'] != null ? DateTime.fromMillisecondsSinceEpoch((map['end'] as Timestamp).millisecondsSinceEpoch) : DateTime(3000);
  }
}
