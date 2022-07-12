import 'package:flutter/material.dart';

class LessonTimeTile extends StatelessWidget {
  const LessonTimeTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        isThreeLine: false,
        leading: Text('1'),
        title: Row(
          children: [Text('from'), Text('till')],
        ));
  }
}
