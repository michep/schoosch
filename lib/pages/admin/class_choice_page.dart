import 'package:flutter/material.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/class_model.dart';
import 'package:schoosch/model/institution_model.dart';
import 'package:schoosch/pages/admin/create_replacement.dart';
import 'package:schoosch/pages/admin/freelessons_page.dart';
import 'package:schoosch/widgets/utils.dart';

class ClassChoicePage extends StatefulWidget {
  final InstitutionModel _institution;
  final bool forReplacements;
  const ClassChoicePage(this._institution, this.forReplacements, {Key? key}) : super(key: key);

  @override
  State<ClassChoicePage> createState() => _ClassChoicePageState();
}

class _ClassChoicePageState extends State<ClassChoicePage> {
  final TextEditingController _name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var loc = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.classList),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Card(
              child: ExpansionTile(
                title: _inSearch ? Text(loc.search, style: const TextStyle(fontStyle: FontStyle.italic)) : Text(loc.search),
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    onChanged: (_) => setState(() {}),
                    controller: _name,
                    decoration: InputDecoration(
                      label: Text(loc.name),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() {
                          _name.value = TextEditingValue.empty;
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<ClassModel>>(
                  future: widget._institution.classes,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Utils.progressIndicator();
                    var sorted = snapshot.data!;
                    sorted.sort((a, b) => a.name.compareTo(b.name));
                    return Scrollbar(
                      thumbVisibility: true,
                      child: ListView(
                        children: [
                          ...sorted.where(_filter).map(
                                (v) => ListTile(
                                  onTap: () => _onTapClass(v),
                                  title: Text(v.name),
                                  subtitle: Text(v.grade.toString()),
                                  trailing: const Icon(Icons.chevron_right),
                                ),
                              ),
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  bool _filter(ClassModel aclass) {
    return aclass.name.toUpperCase().contains(_name.text.toUpperCase());
  }

  bool get _inSearch {
    return _name.text.isNotEmpty;
  }

  Future<void> _onTapClass(ClassModel aclass) async {
    Navigator.push(
      context,
      widget.forReplacements ? MaterialPageRoute(
        builder: (context) => CreateReplacement(aclass),
      ) : MaterialPageRoute(builder: (context) => FreeLessonsPage(aclass)),
    );
  }

  
}
