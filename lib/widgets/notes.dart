import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

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
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
        body: Wrap(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton.icon(
            style: TextButton.styleFrom(
              backgroundColor: themeProvider.themeData.highlightColor,
              foregroundColor: themeProvider.getOppositeColor(context),
            ),
            icon: const Icon(CupertinoIcons.add_circled, size: 20.0),
            label: const Text("Create note",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            onPressed: () {
              setState(() {
                _creatingNewFile = !_creatingNewFile;
              });
            }),
      ),
      _creatingNewFile
          ? Container(
              color: themeProvider.themeData.splashColor,
              child: Column(children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Name",
                  ),
                ),
                Container(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Contents...",
                    ),
                  ),
                ),
              ]),
            )
          : Column(),
    ]));
  }
}

class File {
  String name;
  String content;
  File(this.name, this.content);
}
