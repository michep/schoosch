import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:schoosch/generated/l10n.dart';
import 'package:schoosch/model/marktype_model.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/utils.dart';

class MarktypePage extends StatefulWidget {
  final MarkType _type;
  final String _title;

  const MarktypePage(this._type, this._title, {super.key});

  @override
  State<MarktypePage> createState() => _MarktypePageState();
}

class _MarktypePageState extends State<MarktypePage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _label = TextEditingController();
  final TextEditingController _weight = TextEditingController();
  final TextEditingController _status = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _name.value = TextEditingValue(text: widget._type.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var loc = S.of(context);
    return Scaffold(
      appBar: MAppBar(
        widget._title,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _delete(widget._type),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                TextFormField(
                  controller: _name,
                  decoration: InputDecoration(
                    label: Text(loc.marktypeName),
                  ),
                  validator: (value) => Utils.validateTextNotEmpty(value, loc.errorNameEmpty),
                ),
                TextFormField(
                  controller: _label,
                  decoration: InputDecoration(
                    label: Text(loc.marktypeLabel),
                  ),
                  validator: (value) => Utils.validateTextNotEmpty(value, loc.errorNameEmpty),
                ),
                TextFormField(
                  controller: _status,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    label: Text(loc.marktypeStatus),
                  ),
                  validator: (value) {
                    if (value != null) {
                      if (value == '1' || value == '0') {
                        return null;
                      } 
                    }
                    return loc.errorMarktypeStatus;
                  },
                ),
                TextFormField(
                  controller: _weight,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    label: Text(loc.marktypeWeight),
                  ),
                  validator: (value) => Utils.validateTextNotEmpty(value, loc.errorWeightEmpty),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ElevatedButton(
                    child: Text(loc.saveChanges),
                    onPressed: () => _save(widget._type),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _save(MarkType type) async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> map = {};
      map['name'] = _name.text;
      map['label'] = _label.text;
      map['status'] = int.parse(_status.text);
      map['weight'] = double.parse(_weight.text);
      map['institution_id'] = type.institutionId;
      var ntype = MarkType.fromMap(type.id, map);
      await ntype.save();
      Get.back<MarkType>(result: ntype);
    }
  }

  Future<void> _delete(MarkType type) async {
    type.delete();
    Get.back<MarkType>(result: type);
  }
}
