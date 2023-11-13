import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:schoosch/model/marktype_model.dart';
import 'package:schoosch/model/status_enum.dart';
import 'package:schoosch/widgets/appbar.dart';
import 'package:schoosch/widgets/modelstatus_field.dart';
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
  late StatusModel _status;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _name.value = TextEditingValue(text: widget._type.name);
    _label.value = TextEditingValue(text: widget._type.label);
    _weight.value = TextEditingValue(text: widget._type.weight.toString());
    _status = widget._type.status;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var loc = AppLocalizations.of(context)!;
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
                    label: Text(loc.name),
                  ),
                  validator: (value) => Utils.validateTextNotEmpty(value, loc.errorNameEmpty),
                ),
                TextFormField(
                  controller: _label,
                  decoration: InputDecoration(
                    label: Text(loc.markTypeLabel),
                  ),
                  validator: (value) => Utils.validateTextNotEmpty(value, loc.errorMarkTypeLabelEmpty),
                ),
                ModelStatusFormField(
                  status: _status,
                  onChanged: (v) {
                    if (v is StatusModel) {
                      setState(() {
                        _status = v;
                      });
                    }
                  },
                ),
                TextFormField(
                  controller: _weight,
                  // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    label: Text(loc.markTypeWeight),
                  ),
                  validator: (value) => Utils.validateNumNotEmpty(value, loc.errorMarkTypeWeightEmpty),
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
      map['status'] = _status.nameInt;
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
