import 'package:flutter/material.dart';

class CheckBoxForm extends StatefulWidget {
  final String title;
  final Function(String, bool) onCheckboxSelected;

  const CheckBoxForm({
    Key? key,
    required this.title,
    required this.onCheckboxSelected,
  }) : super(key: key);

  @override
  _CheckBoxFormState createState() => _CheckBoxFormState();
}

class _CheckBoxFormState extends State<CheckBoxForm> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 60,
      child: CheckboxListTile(
        title: Text(widget.title),
        value: _isSelected,
        onChanged: (value) {
          setState(() {
            _isSelected = value!;
            widget.onCheckboxSelected(widget.title, _isSelected);
          });
        },
      ),
    );
  }
}
