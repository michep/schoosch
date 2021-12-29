import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/daylessontime_model.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/model/person_model.dart';
import 'package:schoosch/pages/admin/daylessontime_list.dart';
import 'package:schoosch/pages/admin/people_list.dart';
import 'package:schoosch/widgets/utils.dart';

class ClassPage extends StatefulWidget {
  final ClassModel aclass;
  final String title;

  const ClassPage(this.aclass, this.title, {Key? key}) : super(key: key);

  @override
  State<ClassPage> createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _grade = TextEditingController();
  final TextEditingController _mastercont = TextEditingController();
  final TextEditingController _daylessontimecont = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final List<StudentModel> students = [];
  TeacherModel? master;
  DayLessontimeModel? dayLessontime;

  @override
  void initState() {
    _name.value = TextEditingValue(text: widget.aclass.name);
    _grade.value = TextEditingValue(text: widget.aclass.grade != 0 ? widget.aclass.grade.toString() : '');
    widget.aclass.students.then((value) {
      setState(() {
        students.addAll(value);
      });
    });
    widget.aclass.master.then((value) {
      if (value != null) {
        setState(() {
          _mastercont.text = value.fullName;
          master = value;
        });
      }
    });
    widget.aclass.getDayLessontime().then((value) {
      if (value != null) {
        setState(() {
          _daylessontimecont.text = value.name;
          dayLessontime = value;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => delete(widget.aclass),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _name,
                        decoration: const InputDecoration(
                          label: Text(
                            'Название учебного класса',
                          ),
                        ),
                        validator: (value) => Utils.validateTextNotEmpty(value, 'Название должно быть заполнено'),
                      ),
                      TextFormField(
                        controller: _grade,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text(
                            'Год обучения',
                          ),
                        ),
                        validator: (value) => Utils.validateTextNotEmpty(value, 'Год обучения должен быть заполнен'),
                      ),
                      masterFormField(context),
                      dayLessontimeField(context),
                    ],
                  ),
                ),
                childrenFormField(context),
                ElevatedButton(
                  child: const Text('Сохранить изменения'),
                  onPressed: () => save(widget.aclass),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget dayLessontimeField(BuildContext context) {
    return TextFormField(
      controller: _daylessontimecont,
      showCursor: false,
      keyboardType: TextInputType.none,
      decoration: InputDecoration(
        label: const Text(
          'Расписание времени уроков',
        ),
        suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: dayLessontime == null
                ? IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: selectDayLessontime,
                  )
                : IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: removeDayLessontime,
                  )),
      ),
      validator: (value) => Utils.validateTextNotEmpty(value, 'Расписание должно быть выбрано'),
    );
  }

  Widget masterFormField(BuildContext context) {
    return TextFormField(
      controller: _mastercont,
      showCursor: false,
      keyboardType: TextInputType.none,
      decoration: InputDecoration(
        label: const Text(
          'Классный руководитель',
        ),
        suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: master == null
                ? IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: selectMaster,
                  )
                : IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: removeMaster,
                  )),
      ),
      validator: (value) => Utils.validateTextNotEmpty(value, 'Классный руководитель должен быть выбран'),
    );
  }

  Widget childrenFormField(BuildContext context) {
    return FormField<List<StudentModel>>(
      initialValue: students,
      builder: (fieldstate) => ExpansionTile(
        controlAffinity: ListTileControlAffinity.leading,
        title: Text('Учащиея класса (${students.length})'),
        subtitle: fieldstate.hasError
            ? Text(fieldstate.errorText!, style: TextStyle(fontSize: 12, color: Theme.of(context).errorColor))
            : const SizedBox.shrink(),
        trailing: IconButton(
          icon: Icon(
            Icons.add,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: addChild,
        ),
        children: [
          ...students.map((s) => ListTile(
                title: SelectableText(s.fullName),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => removeChild(s),
                ),
              )),
        ],
      ),
    );
  }

  Future<void> addChild() async {
    var res = await Get.to<PersonModel>(() => PeopleListPage(InstitutionModel.currentInstitution, selectionMode: true));
    if (res != null && !students.contains(res)) {
      setState(() {
        students.add(res.asStudent!);
      });
    }
  }

  void removeChild(StudentModel student) {
    setState(() {
      students.remove(student);
    });
  }

  Future<void> selectMaster() async {
    var res = await Get.to<PersonModel>(() => PeopleListPage(InstitutionModel.currentInstitution, selectionMode: true));
    if (res != null) {
      setState(() {
        _mastercont.text = res.fullName;
        master = res.asTeacher;
      });
    }
  }

  void removeMaster() {
    setState(() {
      master = null;
      _mastercont.text = '';
    });
  }

  Future<void> selectDayLessontime() async {
    var res = await Get.to<DayLessontimeModel>(() => DayLessontimeListPage(InstitutionModel.currentInstitution, selectionMode: true));
    if (res != null) {
      setState(() {
        _daylessontimecont.text = res.name;
        dayLessontime = res;
      });
    }
  }

  void removeDayLessontime() {
    setState(() {
      dayLessontime = null;
      _daylessontimecont.text = '';
    });
  }

  Future<void> save(ClassModel aclass) async {
    if (_formKey.currentState!.validate()) {
      aclass.name = _name.text;
      aclass.grade = int.parse(_grade.text);
      aclass.masterId = master!.id!;
      aclass.dayLessontimeId = dayLessontime!.id!;
      aclass.studentIds.clear();
      aclass.studentIds.addAll(students.map((e) => e.id!));
      aclass.save();
      Get.back(result: 'refresh');
    }
  }

  Future<void> delete(ClassModel aclass) async {}
}
