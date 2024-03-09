import 'package:flutter/material.dart';
import 'package:tasker/models/group.dart';
import '../services/database.dart';

class GroupWidget extends StatefulWidget {
  final List<Group> groupItems;
  Function onListChange;
  Function onTodoChange;
  int? selectedGroupId;
  final Function removeGroup;

  GroupWidget(
      {Key? key,
      required this.selectedGroupId,
      required this.groupItems,
      required this.onListChange,
      required this.onTodoChange,
      required this.removeGroup})
      : super(key: key);

  @override
  State<GroupWidget> createState() => _GroupWidgetState();
}

class _GroupWidgetState extends State<GroupWidget> {
  final TextEditingController groupItemController = TextEditingController();
  Offset _tapPosition = Offset.zero;

  void _getTapPosition(TapDownDetails details) {
    final RenderBox referenceBox = context.findRenderObject() as RenderBox;
    setState(() {
      _tapPosition = referenceBox.globalToLocal(details.globalPosition);
    });
  }

  void showContextMenu(BuildContext context, int taskId) async {
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
              widget.selectedGroupId = 1;
              widget.removeGroup(taskId);
              widget.onTodoChange(widget.selectedGroupId);
              widget.onListChange();
            },
          ),
          const PopupMenuItem(
            value: "rename",
            child: Text("Rename"),
          ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    print("COUNT-GROUP: ${widget.groupItems.length}");
    print(widget.groupItems);

    return Scaffold(
      body: Wrap(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 50, bottom: 40, left: 20),
            child: const Text(
              "Groups :",
              style: TextStyle(fontSize: 30),
            ),
          ),
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: widget.groupItems.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTapDown: (details) => _getTapPosition(details),
                onLongPress: () {
                  showContextMenu(context, widget.groupItems[index].id!);
                },
                child: ListTile(
                  title: Text(widget.groupItems[index].name),
                  selected:
                      widget.selectedGroupId == widget.groupItems[index].id,
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      widget.selectedGroupId = widget.groupItems[index].id;
                      //widget.onListChange;
                      widget.onTodoChange(widget.groupItems[index].id);
                    });
                  },
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_circle_outline),
        onPressed: () {
          addGroup();
        },
      ),
    );
  }

  addGroup() {
    var textFieldController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("New Group"),
        content: TextField(
          controller: textFieldController,
          decoration: const InputDecoration(hintText: "Group name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              print(textFieldController.text);

              DatabaseService.createGroup(Group(name: textFieldController.text))
                  .then((value) {
                widget.onListChange();
                widget.onTodoChange();
              });

              Navigator.pop(context, 'OK');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
