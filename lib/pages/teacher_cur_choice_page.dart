import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/fire_store_controller.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/pages/teacher_marks_table_page.dart';
import 'package:schoosch/widgets/utils.dart';

class CurriculumChoicePage extends StatelessWidget {
  const CurriculumChoicePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('предмет'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<List<CurriculumModel>>(
          future: Get.find<FStore>().getTeacherCurriculums(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Utils.progressIndicator();
            }
            if (snapshot.data!.isEmpty) {
              return const Text('NOTHING');
            }
            return ListView.builder(
              itemBuilder: (_, index) {
                return ListTile(
                  onTap: () {
                    Get.to(
                      TeacherTablePage(
                        currentcur: snapshot.data![index],
                      ),
                    );
                  },
                  title: Text(snapshot.data![index].aliasOrName),
                  subtitle: Text(snapshot.data![index].id!),
                );
              },
              itemCount: snapshot.data!.length,
            );
          },
        ),
      ),
    );
  }
}
