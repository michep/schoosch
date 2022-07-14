import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/lessontime_model.dart';
import 'package:schoosch/pages/admin/lessontime_edit.dart';

class LessonTimeTile extends StatefulWidget {
  final LessontimeModel _lessontime;
  final bool _isLast;
  final void Function() _deleteFunc;

  const LessonTimeTile(this._lessontime, this._isLast, this._deleteFunc, {Key? key}) : super(key: key);

  @override
  State<LessonTimeTile> createState() => _LessonTimeTileState();
}

class _LessonTimeTileState extends State<LessonTimeTile> {
  late LessontimeModel _lessontime;

  @override
  void initState() {
    _lessontime = widget._lessontime;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(_lessontime.order.toString()),
      title: Text(_lessontime.formatPeriod()),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.chevron_right),
          widget._isLast
              ? IconButton(onPressed: widget._deleteFunc, icon: const Icon(Icons.delete))
              : IconButton(onPressed: null, icon: Icon(Icons.delete, color: Theme.of(context).scaffoldBackgroundColor)),
        ],
      ),
      onTap: () => _onTap(_lessontime),
    );
  }

  void _onTap(LessontimeModel lessontime) async {
    var res = await Get.to<LessontimeModel>(() => LessonTimePage(lessontime), transition: Transition.rightToLeft);
    if (res is LessontimeModel) {
      setState(() {
        _lessontime = lessontime;
      });
    }
  }
}
