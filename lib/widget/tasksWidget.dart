import 'package:flutter/material.dart';
import 'package:tasker/models/todo.dart';
import 'package:tasker/services/database.dart';

class TasksWidget extends StatefulWidget {
  final List<Todo> items;
  final Function onListChange;
  final Function removeTask;

  const TasksWidget(
      {super.key, required this.items, required this.onListChange, required this.removeTask});

  @override
  State<TasksWidget> createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  Offset _tapPosition = Offset.zero;
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

  void _getTapPosition(TapDownDetails details) {
    final RenderBox referenceBox = context.findRenderObject() as RenderBox;
    setState(() {
      _tapPosition = referenceBox.globalToLocal(details.globalPosition);
    });
  }

  void showContextMenu(BuildContext context, int taskId) async {
    final RenderObject? overlay =
        Overlay.of(context)?.context.findRenderObject();

    final result = await showMenu(
        context: context,
        position: RelativeRect.fromRect(
            Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 30, 30),
            Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
                overlay.paintBounds.size.height)),
        items: [
          PopupMenuItem(
            value: "delete",
            child: const Text("Delete"),
            onTap: () => widget.removeTask(taskId),
          ),
          const PopupMenuItem(
            value: "rename",
            child: Text("Rename"),
          ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    print("COUNT2:${widget.items.length}");
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.items.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTapDown: (details) => _getTapPosition(details),
          onLongPress: () {
            showContextMenu(context, widget.items[index].id!);
          },
          child: CheckboxListTile(
            title: Text(widget.items[index].content),
            value: widget.items[index].completed,
            subtitle: Text(widget.items[index].description ?? ""),
            onChanged: (value) {
              print("ListBox Value : " + value.toString());
              DatabaseService.updateTaskStatue(
                      widget.items[index].id!, widget.items[index].completed)
                  .then((value) {
                widget.onListChange();
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
        );
      },
    );
  }
}
