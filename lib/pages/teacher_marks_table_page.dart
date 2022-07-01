import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schoosch/model/curriculum_model.dart';
import 'package:schoosch/model/mark_model.dart';
import 'package:schoosch/model/person_model.dart';

class TeacherTablePage extends StatelessWidget {
  final CurriculumModel currentcur;
  const TeacherTablePage({Key? key, required this.currentcur}) : super(key: key);

  List<Widget> _buildMarkCells(List<MarkModel> listmark) {
    return List.generate(
      listmark.length,
      (index) => Container(
        alignment: Alignment.center,
        width: 120.0,
        height: 60.0,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.black54),
        margin: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(DateFormat.Md().format(listmark[index].date)),
            Text(listmark[index].mark.toString()),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildStudentCells(List<StudentModel> liststud) {
    return List.generate(
      liststud.length,
      (index) => Container(
        alignment: Alignment.center,
        width: 150.0,
        height: 60.0,
        decoration: const BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(
              color: Colors.black,
              width: 1.5,
            ),
          ),
        ),
        margin: const EdgeInsets.all(4.0),
        child: Text(liststud[index].lastname),
      ),
    );
  }

  List<Widget> _buildRows(List<StudentModel> liststud) {
    return List.generate(
      liststud.length,
      (index) => FutureBuilder<List<MarkModel>>(
          future: liststud[index].curriculumMarks(currentcur),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Text('nothing');
            }
            if (snapshot.data!.isEmpty) {
              return Container(
                alignment: Alignment.center,
                width: 120.0,
                height: 60.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black54,
                ),
                margin: const EdgeInsets.all(4.0),
                child: const Text('NO MARKS'),
              );
            }
            return Row(children: _buildMarkCells(snapshot.data!));
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentcur.aliasOrName),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<List<StudentModel>>(
          future: currentcur.allStudents(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Text('NO DATA');
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _buildStudentCells(snapshot.data!),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _buildRows(snapshot.data!),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
