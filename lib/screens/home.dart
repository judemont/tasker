import 'package:flutter/material.dart';
import 'package:tasker/components/buttonNew.dart';
import 'package:tasker/models/group.dart';

import 'package:tasker/models/todo.dart';
import 'package:tasker/screens/groupWidget.dart';
import 'package:tasker/screens/tasksWidget.dart';
import 'package:tasker/services/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Todo> items = [];
  List<Group> groups = [];

  int selectedGroupId = 0 ; 


  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tasker"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
          child: Column(
          children: [
            GroupWidget(selectedGroupId : selectedGroupId,groupItems: groups,onListChange:  _loadGroups ,onTodoChange: _loadTodoFromGroup ,),
            TasksWidget(items: items, onListChange: _loadData)
                      ])
  
    ),
    floatingActionButton: FloatingNewButton(
        onPressed: _loadData
      ) 
    );
  }

  Future<void> _loadTodoFromGroup(int groupId) async {
    selectedGroupId = groupId; 
    print("function  _loadTodoFromGroup");
    print("function  _loadTodoFromGroup ID:"+selectedGroupId.toString());
    DatabaseService.getItemFromGroup(selectedGroupId).then((value) {
       setState(() {
         print("Todo COUNT:${value.length}");
        items = value;
      });
    });
  }

  Future<void> _loadGroups() async {
    print("function  _loadGroups");
        DatabaseService.getGroups().then((result){
      setState(() {
         print("Group COUNT:${result.length}");
        groups = result;
      });
    } );
  }

  Future<void> _loadData() async {
    print("UPDATING DATA......");

    _loadGroups();

    DatabaseService.getItems().then((result) {
      setState(() {
         print("Todo COUNT:${result.length}");
        items = result;
      });
    });
  }
}
