import 'package:flutter/material.dart';
import 'package:tasker/models/todo.dart';
import 'package:tasker/services/database.dart';

class FloatingNewButton extends StatelessWidget {
  final VoidCallback onPressed;

  const FloatingNewButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    var titleFieldController = TextEditingController();
    var descriptionFieldController = TextEditingController();

    return FloatingActionButton(
      child: const Icon(Icons.add_task),
      onPressed: () => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("New ToDo"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleFieldController,
                decoration: const InputDecoration(hintText: "Title"),
              ),
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: descriptionFieldController,
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
                print(titleFieldController.text);
                print(descriptionFieldController.text);

                DatabaseService.createItem(
                        Todo(content: titleFieldController.text, description: descriptionFieldController.text))
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
