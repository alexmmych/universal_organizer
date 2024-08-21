import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'text_button_icon.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  Box box = Hive.box("notes");

  bool _creatingNewFile = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Wrap(children: [
      TextButtonIcon(
          icon: CupertinoIcons.add_circled,
          text: "Create note",
          onPressed: () {
            newFile();
          }),
      const SizedBox(
        height: 50.0,
      ),
      _creatingNewFile
          ? Container(
              color: Colors.red,
              child: TextFormField(
                decoration: const InputDecoration(
                    labelText: "Name", fillColor: Colors.red),
              ),
            )
          : Column(),
    ]));
  }

  void newFile() {
    // var files;

    // if (box.isNotEmpty) {
    //   files = box.get('files');
    // } else {
    //   files = <File>[];
    // }

    setState(() {
      _creatingNewFile = !_creatingNewFile;
    });

    // File file = File("Test", "Ok");
    // files.add(file);

    // box.put('files', files);
  }
}

class File {
  String name;
  String content;
  File(this.name, this.content);
}
