import 'package:flutter/material.dart';
import 'package:tasker/components/buttonNew.dart';
import 'package:tasker/models/todo.dart';
import 'package:tasker/screens/tasksWidget.dart';
import 'package:tasker/services/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Todo> items = [];

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
            Text("Salut32"),
            TasksWidget(items: items)
          ])
  
    ),
    floatingActionButton: FloatingNewButton(
        onPressed: _loadData
      )
    );
  }

  Future<void> _loadData() async {
    print("UPDATING DATA....");
    DatabaseService.getItems().then((result) {
      setState(() {
         print("COUNT:"+result.length.toString());
        items = result;
      });
    });
  }
}
