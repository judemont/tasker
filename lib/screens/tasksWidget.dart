import 'package:flutter/material.dart';
import 'package:tasker/models/todo.dart';
import 'package:tasker/services/database.dart';

class TasksWidget extends StatefulWidget {
  final List<Todo> items;
  final Function onListChange;
  const TasksWidget(
      {super.key, required this.items, required this.onListChange});

  @override
  State<TasksWidget> createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
/*

  Future<void> _loadData() async {
    print("UPDATING DATA....");
    DatabaseService.getItems().then((result) {
      setState(() {
        widget.items = result;
      });
    });
  }
*/
  @override
  void initState() {
    //_loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("COUNT2:${widget.items.length}");
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.items.length,
      itemBuilder: (BuildContext context, int index) {
        return CheckboxListTile(
          title: Text(widget.items[index].content),
          value: widget.items[index].completed,
          subtitle: const Text("description"),
          onChanged: (value) {
            print("ListBox Value : "+value.toString());
            DatabaseService.updateTaskStatue(
                    widget.items[index].id!, widget.items[index].completed)
                .then((value) {
              widget.onListChange();
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
        );
      },
    );
  }
}

/*

          ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return Material(
              child: CheckboxListTile(
            title: Text(items[index].content),
            value: items[index].completed,
            onChanged: (value) {
              print(value);
              DatabaseService.updateTaskStatue(
                      items[index].id!, items[index].completed)
                  .then((value) {
                _loadData();
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ));
        },
      )),
      floatingActionButton: FloatingNewButton(
        onPressed: _loadData,
      ),
      */