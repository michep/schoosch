import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/pages/admin/class_edit.dart';
import 'package:schoosch/widgets/utils.dart';

class ClassListPage extends StatefulWidget {
  final InstitutionModel institution;
  final bool selectionMode;

  const ClassListPage(this.institution, {this.selectionMode = false, Key? key}) : super(key: key);

  @override
  State<ClassListPage> createState() => _ClassListPageState();
}

class _ClassListPageState extends State<ClassListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Учебные классы'),
        actions: widget.selectionMode ? [] : [IconButton(onPressed: newClass, icon: const Icon(Icons.add))],
      ),
      body: SafeArea(
        child: FutureBuilder<List<ClassModel>>(
            future: widget.institution.classes,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Utils.progressIndicator();
              var sorted = snapshot.data!;
              sorted.sort((a, b) => a.name.compareTo(b.name));
              return ListView(
                children: [
                  ...sorted.map(
                    (v) => ListTile(
                      onTap: () => onTap(v),
                      title: Text(v.name),
                      trailing: const Icon(Icons.chevron_right),
                      subtitle: Text(v.grade.toString()),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }

  Future onTap(ClassModel aclass) async {
    if (widget.selectionMode) {
      return Get.back(result: aclass);
    } else {
      var res = await Get.to<String>(() => ClassPage(aclass));
      if (res != null && res == 'refresh') {
        setState(() {});
      }
    }
  }

  Future newClass() async {
    var nclass = ClassModel.empty();
    var res = await Get.to<String>(() => ClassPage(nclass));
    if (res != null && res == 'refresh') {
      setState(() {});
    }
  }
}
