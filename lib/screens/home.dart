import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lemp/env.dart';

import '../models/student.dart';
import './details.dart';
import './create.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  late Future<List<Student>> students;
  final studentListKey = GlobalKey<HomeState>();

  @override
  void initState() {
    super.initState();
    students = getStudentList().whenComplete(() {
      setState(() {});
    });
  }

  // Future<List<Student>> getStudentList() async {
  //   try {
  //     final response =
  //         await http.get(Uri.http('172.19.0.1', "/", {"route": "user.list"}));
  //     print(response.body);
  //     final items = json.decode(response.body).cast<Map<String, dynamic>>();
  //     print(items);
  //     List<Student> students = items.map<Student>((json) {
  //       return Student.fromJson(json);
  //     }).toList();

  //     return students;
  //   } catch (e) {
  //     print(e.toString());
  //   }

  //   return students;
  // }

  Future<List<Student>> getStudentList() async {
    print('getStudentList()');
    try {
      Response response = await Dio().get(
        kUrl,
        queryParameters: {'route': 'user.list'},
      );
      print('response.data: ${response.data}');
      List<Student> students = response.data.map<Student>((json) {
        return Student.fromJson(json);
      }).toList();
      return students;
    } on DioError catch (e) {
      print('getStudentList e: ${e.message}');
    }
    return students;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: studentListKey,
      appBar: AppBar(
        title: Text('학생 목록'),
      ),
      body: Center(
        child: FutureBuilder<List<Student>>(
          future: students,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            // By default, show a loading spinner.
            if (!snapshot.hasData) return CircularProgressIndicator();
            // Render student lists
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                var data = snapshot.data[index];
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.person),
                    trailing: Icon(Icons.view_list),
                    title: Text(
                      data.name,
                      style: TextStyle(fontSize: 20),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Details(student: data)),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return Create();
          }));
        },
      ),
    );
  }
}
