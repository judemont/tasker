import 'package:flutter/material.dart';
import 'package:tasker/models/todo.dart';
import 'package:tasker/services/database.dart';

class TasksWidget extends StatefulWidget {
  final List<Todo> items;
  final Function onListChange;
  final Function removeTask;
  final Function renameTask;

  const TasksWidget(
      {super.key,
      required this.items,
      required this.onListChange,
      required this.removeTask,
      required this.renameTask});

  @override
  State<TasksWidget> createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  Offset _tapPosition = Offset.zero;
  bool displayCompletedTasks = false;

  var renameTitleFieldController = TextEditingController();
  var renameDescriptionFieldController = TextEditingController();

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

  void showContextMenu(BuildContext context, Todo todo) async {
    renameTitleFieldController = TextEditingController(text: todo.content);
    renameDescriptionFieldController =
        TextEditingController(text: todo.description);

    final RenderObject? overlay =
        Overlay.of(context).context.findRenderObject();

    showMenu(
        context: context,
        position: RelativeRect.fromRect(
            Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 30, 30),
            Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
                overlay.paintBounds.size.height)),
        items: [
          PopupMenuItem(
            value: "delete",
            child: const Text("Delete"),
            onTap: () {
              widget.removeTask(todo.id);
              widget.onListChange();
            },
          ),
          PopupMenuItem(
            value: "rename",
            child: Text("Edit"),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Edit"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: renameTitleFieldController,
                        decoration:
                            const InputDecoration(hintText: "New Title"),
                      ),
                      TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: renameDescriptionFieldController,
                        decoration:
                            const InputDecoration(hintText: "New Description"),
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
                        widget.renameTask(todo, renameTitleFieldController.text,
                            renameDescriptionFieldController.text);
                        widget.onListChange();
                        Navigator.pop(context, "ok");
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    print("COUNT2:${widget.items.length}");
    return Wrap(
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: widget.items.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
                confirmDismiss: (direction) async {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Description"),
                      content: Text(widget.items[index].description!),
                      actions: [
                        TextButton(
                          onPressed:() => Navigator.pop(context, "ok"),
                          child: Text("OK")
                        )
                      ],
                    )
                  );

                  return false;
                },
                background: Container(
                  color: Colors.blue,
                ),
                direction: DismissDirection.endToStart,
                key: UniqueKey(),
                child: GestureDetector(
                    onTapDown: (details) => _getTapPosition(details),
                    onLongPress: () {
                      showContextMenu(context, widget.items[index]);
                    },
                    child: Visibility(
                      visible: displayCompletedTasks ||
                          !widget.items[index].completed,
                      child: CheckboxListTile(
                        title: Text(widget.items[index].content),
                        value: widget.items[index].completed,
                        onChanged: (value) {
                          print("ListBox Value : " + value.toString());
                          DatabaseService.updateTaskStatue(
                                  widget.items[index].id!,
                                  widget.items[index].completed)
                              .then((value) {
                            widget.onListChange();
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    )));
          },
        ),
        SwitchListTile(
            title: Text("Display completed task"),
            value: displayCompletedTasks,
            onChanged: (bool value) {
              setState(() {
                displayCompletedTasks = value;
              });
            })
      ],
    );
  }
}
