import 'package:flutter/material.dart';

class AppForm extends StatefulWidget {
  // Required for form validations
  final GlobalKey<FormState> formKey;

  // Handles text onchange
  final TextEditingController nameController;
  final TextEditingController ageController;

  AppForm(
      {required this.formKey,
      required this.nameController,
      required this.ageController});

  @override
  _AppFormState createState() => _AppFormState();
}

class _AppFormState extends State<AppForm> {
  String? _validateName(String? value) {
    if (value == null) return null;

    if (value.length < 3) return '이름은 2글자 이상 입력하세요';
    return null;
  }

  String? _validateAge(String? value) {
    if (value == null) return null;

    Pattern pattern = r'(?<=\s|^)\d+(?=\s|$)';
    RegExp regex = new RegExp(pattern.toString());
    if (!regex.hasMatch(value)) return '나이는 숫자죠?';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      autovalidateMode: AutovalidateMode.always,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: widget.nameController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(labelText: '이름'),
            validator: _validateName,
          ),
          TextFormField(
            controller: widget.ageController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: '나이'),
            validator: _validateAge,
          ),
        ],
      ),
    );
  }
}
