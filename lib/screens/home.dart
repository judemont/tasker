import 'package:flutter/material.dart';
import 'package:todolistv3/components/buttonNew.dart';
import 'package:todolistv3/components/tasksCheckbox.dart';
import 'package:todolistv3/models/todo.dart';
import 'package:todolistv3/services/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Todo> items = [];

  Future<void> _loadData() async {
    print("UPDATING DATA....");
    DatabaseService.getItems().then((result) {
      setState(() {
        items = result;
      });
    });
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ToDoApp"),
        centerTitle: true,
      ),
      body: Center(
        child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return Row(children: [
            Text(items[index].content),
            TasksCheckbox(items[index].id),
          ]);
        },
                )
      ),
      floatingActionButton: FloatingNewButton(
        onPressed: _loadData,
      ),
    );
  }
}
