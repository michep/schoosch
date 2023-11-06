import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/controller/proxy_controller.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/pages/observer/observer_page.dart';

class ClassListTile extends StatelessWidget {
  final ClassModel _class;

  const ClassListTile(this._class, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        _class.name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: const SizedBox(
        height: 10,
      ),
      onTap: () {
        Get.find<ProxyStore>().currentObserverClass = _class;
        Get.to(() => ObserverPage(_class));
      },
    );
  }
}
