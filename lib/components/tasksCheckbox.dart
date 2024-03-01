import 'package:flutter/material.dart';
import 'package:todolistv3/models/todo.dart';
import 'package:todolistv3/services/database.dart';

class TasksCheckbox extends StatefulWidget {
  final int? taskID;

  TasksCheckbox(this.taskID, {super.key});

  @override
  State<TasksCheckbox> createState() => _TasksCheckboxState();
}

class _TasksCheckboxState extends State<TasksCheckbox> {
  Todo task = Todo(id: 0, completed: false, content: '');

  @override
  void initState() {
    DatabaseService.getItem(widget.taskID!).then((Todo result) {
      setState(() {
        task = result;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: task.completed,
      onChanged: (value) {
        print(value);
        DatabaseService.updateTaskStatue(task.id!, task.completed);
        DatabaseService.getItem(widget.taskID!).then((Todo result) {
          setState(() {
            task = result;
          });
        });
      },
    );
  }
}
