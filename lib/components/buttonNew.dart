import 'package:flutter/material.dart';
import 'package:tasker/models/todo.dart';
import 'package:tasker/screens/home.dart';
import 'package:tasker/services/database.dart';

class FloatingNewButton extends StatelessWidget {
  final VoidCallback onPressed;

  const FloatingNewButton({Key? key, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _titleFieldController = TextEditingController();
    var _descriptionFieldController = TextEditingController();

    return FloatingActionButton(
      child: const Icon(Icons.add_circle),
      onPressed: () => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("New ToDo"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleFieldController,
                decoration: const InputDecoration(hintText: "Title"),
              ),
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: _descriptionFieldController,
                decoration: const InputDecoration(hintText: "Description"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                print(_titleFieldController.text);

                DatabaseService.createItem(
                        Todo(content: _titleFieldController.text))
                    .then((value) {
                  onPressed();
                });

                Navigator.pop(context, 'ok');
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }
}
