import 'package:flutter/material.dart';
import 'package:todolistv3/models/todo.dart';
import 'package:todolistv3/screens/home.dart';
import 'package:todolistv3/services/database.dart';

class FloatingNewButton extends StatelessWidget {
  final VoidCallback onPressed;

  const FloatingNewButton({Key? key, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _textFieldController = TextEditingController();

    return FloatingActionButton(
      child: const Icon(Icons.add_circle),
      onPressed: () => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("New ToDo"),
          content: TextField(
            controller: _textFieldController,
            decoration:
                const InputDecoration(hintText: "What do you need to do?"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                print(_textFieldController.text);

                DatabaseService.createItem(
                  Todo(content: _textFieldController.text)).then((value) {
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
