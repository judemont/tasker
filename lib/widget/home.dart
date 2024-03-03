import 'package:flutter/material.dart';
import 'package:tasker/widget/buttonNew.dart';
import 'package:tasker/models/group.dart';

import 'package:tasker/models/todo.dart';
import 'package:tasker/widget/groupWidget.dart';
import 'package:tasker/widget/tasksWidget.dart';
import 'package:tasker/services/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Todo> items = [];
  List<Group> groups = [];

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
          children: [
            GroupWidget(groupItems: groups),
            TasksWidget(items: items, onListChange: _loadData)
                      ])
  
    ),
    floatingActionButton: FloatingNewButton(
        onPressed: _loadData
      )
    );
  }

  Future<void> _loadData() async {
    print("UPDATING DATA......");
    DatabaseService.getGroups().then((result){
      setState(() {
         print("Group COUNT:${result.length}");
        groups = result;
      });
    } );
    DatabaseService.getItems().then((result) {
      setState(() {
         print("Todo COUNT:${result.length}");
        items = result;
      });
    });
  }
}
