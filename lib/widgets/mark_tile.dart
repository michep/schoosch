import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:schoosch/model/mark_model.dart';

class MarkTile extends StatelessWidget {
  final MarkModel _mark;
  final Function _funk;

  const MarkTile(this._mark, this._funk, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // trailing: Text(_mark.mark.toString()),
      trailing: StreamBuilder<DocumentSnapshot>(
        stream: _mark.markStream(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            var a = snapshot.data!.data() as Map<String, dynamic>;
            return Text(a['mark'].toString());
          } else {
            return const Text('оценка');
          }
        },
      ),
      title: Text(_mark.comment),
      onTap: () => _funk,
    );
  }
}
