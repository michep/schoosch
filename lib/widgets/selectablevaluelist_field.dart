import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoosch/widgets/selectablevalue_field.dart';

typedef WidgetValueFunc<T> = Widget Function(T? value);
typedef ListFutureFunc<T> = Future<List<T>> Function();
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
    Key? key,
  }) : super(key: key);

  @override
  _SelectableValueListFormFieldState<T> createState() => _SelectableValueListFormFieldState<T>();
}

class _SelectableValueListFormFieldState<T> extends State<SelectableValueListFormField<T>> {
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
        subtitle: fieldstate.hasError
            ? Text(fieldstate.errorText!, style: TextStyle(fontSize: 12, color: Theme.of(context).errorColor))
            : const SizedBox.shrink(),
        trailing: IconButton(
          icon: Icon(
            Icons.add,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: addData,
        ),
        children: [
          ..._dataList.map((s) => ListTile(
                title: SelectableText(widget.titleFunc(s)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.open_in_new),
                      onPressed: () => openData(s),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => removeData(s),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Future<void> addData() async {
    var res = await Get.to<T>(widget.listFunc, transition: Transition.rightToLeft);
    if (res != null) {
      setState(() => addValue(res));
    }
  }

  Future<void> openData(T value) async {
    var res = await Get.to<T>(() => widget.detailsFunc(value), transition: Transition.rightToLeft);
    if (res != null) {
      setState(() => setValue(res));
    }
  }

  void addValue(T value) {
    if (widget.addElementFunc(value)) {
      _dataList.add(value);
    }
  }

  void setValue(T value) {
    if (widget.setElementFunc(value)) {
      var i = _dataList.indexOf(value);
      _dataList.remove(value);
      _dataList.insert(i, value!);
    }
  }

  void removeData(T value) {
    if (widget.removeElementFunc(value)) {
      _dataList.remove(value);
    }
  }
}
