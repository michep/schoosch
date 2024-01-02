import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/widgets/selectablevaluedropdown_field.dart';

typedef WidgetValueFunc<T> = Widget Function(T? value);
typedef CallbackFunc<T> = bool Function(T value);
typedef ListFormFieldValidator = String? Function();

class SelectableValueListFormField<T> extends StatefulWidget {
  final String title;
  final ListFutureFunc<T> initListFutureFunc;
  final WidgetFunc listFunc;
  final WidgetValueFunc<T> detailsFunc;
  final TitleFunc<T> titleFunc;
  final CallbackMaybeFunc<T> addElementFunc;
  final CallbackFunc<T> setElementFunc;
  final CallbackFunc<T> removeElementFunc;
  final ListFormFieldValidator? listValidatorFunc;

  const SelectableValueListFormField({
    required this.title,
    required this.initListFutureFunc,
    required this.listFunc,
    required this.detailsFunc,
    required this.titleFunc,
    required this.addElementFunc,
    required this.setElementFunc,
    required this.removeElementFunc,
    this.listValidatorFunc,
    super.key,
  });

  @override
  SelectableValueListFormFieldState<T> createState() => SelectableValueListFormFieldState<T>();
}

class SelectableValueListFormFieldState<T> extends State<SelectableValueListFormField<T>> {
  final List<T> _dataList = [];

  @override
  void initState() {
    widget.initListFutureFunc().then((res) => setState(() => _dataList.addAll(res)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<List<T>>(
      initialValue: _dataList,
      validator: widget.listValidatorFunc != null ? (_) => widget.listValidatorFunc!() : null,
      builder: (fieldstate) => ExpansionTile(
        controlAffinity: ListTileControlAffinity.leading,
        title: Text('${widget.title} (${_dataList.length})'),
        subtitle:
            fieldstate.hasError ? Text(fieldstate.errorText!, style: TextStyle(fontSize: 12, color: Get.theme.colorScheme.error)) : const SizedBox.shrink(),
        trailing: IconButton(
          icon: Icon(
            Icons.add,
            color: Get.theme.primaryColor,
          ),
          onPressed: _addData,
        ),
        children: [
          ..._dataList.map((s) => ListTile(
                title: SelectableText(widget.titleFunc(s)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.open_in_new),
                      onPressed: () => _openData(s),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeData(s),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Future<void> _addData() async {
    var res = await Get.to<T>(widget.listFunc, transition: Transition.rightToLeft);
    if (res != null) {
      setState(() => _addValue(res));
    }
  }

  Future<void> _openData(T value) async {
    var res = await Get.to<T>(() => widget.detailsFunc(value), transition: Transition.rightToLeft);
    if (res != null) {
      setState(() => _setValue(res));
    }
  }

  void _addValue(T value) {
    if (widget.addElementFunc(value)) {
      _dataList.add(value);
    }
  }

  void _setValue(T value) {
    if (widget.setElementFunc(value)) {
      var i = _dataList.indexOf(value);
      _dataList.remove(value);
      _dataList.insert(i, value!);
    }
  }

  void _removeData(T value) {
    if (widget.removeElementFunc(value)) {
      _dataList.remove(value);
    }
  }
}
