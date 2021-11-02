import 'package:cloud_firestore/cloud_firestore.dart';

class YearweekModel {
  final String id;
  final int order;
  final DateTime? start;
  final DateTime? end;

  const YearweekModel(
    this.id,
    this.order,
    this.start,
    this.end,
  );

  YearweekModel.fromMap(String id, Map<String, Object?> map)
      : this(
          id,
          map['order'] != null ? map['order'] as int : -1,
          map['start'] != null ? DateTime.fromMillisecondsSinceEpoch((map['start'] as Timestamp).millisecondsSinceEpoch) : null,
          map['end'] != null ? DateTime.fromMillisecondsSinceEpoch((map['end'] as Timestamp).millisecondsSinceEpoch) : null,
        );
}
