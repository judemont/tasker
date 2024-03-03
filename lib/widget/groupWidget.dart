import 'package:flutter/material.dart';
import 'package:tasker/models/group.dart';

import '../services/database.dart';

class GroupWidget extends StatefulWidget {
  final List<Group> groupItems ;
  Function? onListChange;
  Function? onTodoChange;
  int? selectedGroupId ;
  GroupWidget({super.key,this.selectedGroupId,required this.groupItems, this.onListChange, this.onTodoChange});

  @override
  State<GroupWidget> createState() => _GroupWidgetState();
}

class _GroupWidgetState extends State<GroupWidget> {
  final TextEditingController groupItemControler = TextEditingController();
  //int selectedGroupID = 0; 
  @override
  Widget build(BuildContext context) {
    print("COUNT-GROUP:${widget.groupItems.length}");
    return Row(
      children: [
      DropdownMenu(
        width: MediaQuery.of(context).size.width * 0.5,
        initialSelection: widget.selectedGroupId,
        onSelected: (value) {
          print("On Selected ");

          setState(() {
            print ("select value :"+value.toString());
            
            widget.selectedGroupId = value ;
            //widget.onListChange;
            widget.onTodoChange!(value);  
          });
          
        },
        controller: groupItemControler,
        enableFilter: true,
        requestFocusOnTap: true,
        label: const Text("Select groupe"),
        dropdownMenuEntries: widget.groupItems.map((e) {
          return DropdownMenuEntry(value: e.id, label: e.name);
        }).toList()
      ),
        IconButton(iconSize: 32, 
          icon: const Icon(Icons.add_task),
          onPressed:() {
            setState(() {
              addGroup();  
            });
            
          } ,) ,
      ],) ;
  }

  addGroup() {
    var textFieldController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("New Groupe"),
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

                DatabaseService.createGroup(
                        Group(name: textFieldController.text))
                    .then((value) {
                      widget.onListChange;
                      widget.onTodoChange;
                });

              Navigator.pop(context, 'ok');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
