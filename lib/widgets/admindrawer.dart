import 'package:flutter/material.dart';
import 'package:schoosch/widgets/mdrawerheader.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        drawerHeader(context),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(onPressed: () {}, child: const Text('Информация об учебном заведении')),
            TextButton(onPressed: () {}, child: const Text('Сотрудники, учителя и ученики')),
            TextButton(onPressed: () {}, child: const Text('Классы')),
            TextButton(onPressed: () {}, child: const Text('Кабинеты и помещения')),
            TextButton(onPressed: () {}, child: const Text('Учебные предметы')),
            TextButton(onPressed: () {}, child: const Text('Расписание уроков на неделю')),
          ],
        ),
      ],
    );
  }
}
