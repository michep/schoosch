import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/teacher/teacher_marks_table_page.dart';
import 'package:schoosch/widgets/utils.dart';

class SubjectList extends StatelessWidget {
  final ClassModel _class;
  const SubjectList(this._class, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Column(
    //   mainAxisSize: MainAxisSize.min,
    //   children: [
    //     const Text('Предметы:'),
    //     const SizedBox(
    //       height: 20,
    //     ),
    //     FutureBuilder<List<CurriculumModel>>(
    //       future: _class.getCurriculums(),
    //       builder: (context, snapshot) {
    //         if (!snapshot.hasData) {
    //           return Utils.progressIndicator();
    //         }
    //         if (snapshot.data!.isEmpty) {
    //           return const Text('нет предметов');
    //         }
    //         return ListView.builder(
    //           itemBuilder: (context, index) {
    //             return ListTile(
    //               title: Text(snapshot.data![index].aliasOrName),
    //               subtitle: Text(snapshot.data![index].id!),
    //               onTap: () {
    //                 Get.to(
    //                   TeacherTablePage(
    //                     currentcur: snapshot.data![index],
    //                   ),
    //                 );
    //               },
    //             );
    //           },
    //           itemCount: snapshot.data!.length,
    //         );
    //       },
    //     ),
    //   ],
    // );
    return FutureBuilder<List<CurriculumModel>>(
      // future: _class.getCurriculums(forceRefresh: false),
      future: _class.curriculums(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Utils.progressIndicator();
        }
        if (snapshot.data!.isEmpty) {
          return const Text('нет предметов');
        }
        return ListView.builder(
          itemBuilder: (context, index) {
            var cur = snapshot.data!.elementAt(index);
            return FutureBuilder<TeacherModel?>(
                future: cur.master,
                builder: (context, teachersnap) {
                  if (!teachersnap.hasData) {
                    return const SizedBox.shrink();
                  }
                  var teacher = teachersnap.data!;
                  return ListTile(
                    title: Text(cur.aliasOrName),
                    subtitle: Text(teacher.abbreviatedName),
                    onTap: () {
                      Get.to(
                        () => TeacherTablePage(
                          currentcur: cur,
                          aclass: _class,
                          teacher: teacher,
                        ),
                      );
                    },
                  );
                });
          },
          itemCount: snapshot.data!.length,
        );
      },
    );
  }
}
