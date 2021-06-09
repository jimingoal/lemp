import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../env.dart';
import '../models/student.dart';
import '../widgets/form.dart';

class Edit extends StatefulWidget {
  final Student? student;

  Edit({this.student});

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  // This is  for form validations
  final formKey = GlobalKey<FormState>();

  // This is for text onChange
  late TextEditingController nameController;
  late TextEditingController ageController;

  // Http post request
  Future editStudent() async {
    return await http.post(
      Uri.http(kUrl, "/flutter_api/update.php"),
      body: {
        "id": widget.student?.id.toString(),
        "name": nameController.text,
        "age": ageController.text
      },
    );
  }

  void _onConfirm(context) async {
    await editStudent();
    // Remove all existing routes until the Home.dart, then rebuild Home.
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    nameController = TextEditingController(text: widget.student?.name);
    ageController = TextEditingController(text: widget.student?.age.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("수정하기"),
      ),
      bottomNavigationBar: BottomAppBar(
        child: RaisedButton(
          child: Text('확인'),
          color: Colors.blue,
          textColor: Colors.white,
          onPressed: () {
            _onConfirm(context);
          },
        ),
      ),
      body: Container(
        height: double.infinity,
        padding: EdgeInsets.all(20),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: AppForm(
              formKey: formKey,
              nameController: nameController,
              ageController: ageController,
            ),
          ),
        ),
      ),
    );
  }
}
