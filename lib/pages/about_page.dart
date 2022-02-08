import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final List<bool> _isOpen = [false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("о приложении"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ExpansionPanelList(
            expandedHeaderPadding: EdgeInsets.zero,
            elevation: 1,
            dividerColor: Colors.blue,
            children: [
              ExpansionPanel(
                headerBuilder: (context, isOpen) {
                  return const Text("Основные функции");
                },
                body: const Text(
                  "Ученик:\n имеет возможность посмотреть расписание, увидеть свои задания на дом и оценки, а так же отзываться об учителях своей школы.\nУчитель:\n имеет возможность ставить оценки, назначать дз всему классу или отдельному человеку, имеет доступ к расписанию.\nРодитель:\n может проверять оценки своего ребенка и его пропуски.",
                ),
                isExpanded: _isOpen[0],
              ),
              ExpansionPanel(
                headerBuilder: (context, isOpen) {
                  return const Text("Кто такой админ");
                },
                body: const Text(
                  "Админ - это статус, позволяющий учителю или родителю изменять данные о классе, расписании или всей школе. Имеет набор дополнительных функций, позволяющих взаимодействовать с базой данных.",
                ),
                isExpanded: _isOpen[1],
              ),
              ExpansionPanel(
                headerBuilder: (context, isOpen) {
                  return const Text("hello 3");
                },
                body: const Text("now Open 3333"),
                isExpanded: _isOpen[2],
              ),
              ExpansionPanel(
                headerBuilder: (context, isOpen) {
                  return const Text("hello 4");
                },
                body: const Text("now Open 4444"),
                isExpanded: _isOpen[3],
              ),
            ],
            expansionCallback: (i, isOpen) {
              setState(() {
                _isOpen[i] = !isOpen;
              });
            },
          ),
        ],
      ),
    );
  }
}
