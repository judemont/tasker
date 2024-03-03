
import 'package:flutter/material.dart';
import 'package:tasker/models/group.dart';

import '../services/database.dart';

class GroupWidget extends StatefulWidget {
  final List<Group> groupItems ;
  const GroupWidget({super.key,required this.groupItems});

  @override
  State<GroupWidget> createState() => _GroupWidgetState();
}

class _GroupWidgetState extends State<GroupWidget> {
  final TextEditingController groupItemControler = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    print("COUNT-GROUP:"+widget.groupItems.length.toString());
    return Row(
      children: [
     DropdownMenu(
      
      controller: groupItemControler,
      enableFilter: true,
      requestFocusOnTap: true,
      label: Text("Select groupe"),
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
      Text("hidden")
    ],) ;
  }


  addGroup()
  {
    var _textFieldController = TextEditingController();
    showDialog(context: context, builder:  (context) => AlertDialog(
          title: const Text("New Groupe"),
          content: TextField(
            controller: _textFieldController,
            decoration:
                const InputDecoration(hintText: "Group name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                print(_textFieldController.text);

                DatabaseService.createGroup(
                        Group(name: _textFieldController.text))
                    .then((value) {
                 
                });

                Navigator.pop(context, 'ok');
              },
              child: const Text('OK'),
            ),
          ],
        ),);
  }
}