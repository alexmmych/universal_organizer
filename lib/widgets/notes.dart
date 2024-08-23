import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'file.dart';

import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:animated_list_plus/transitions.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  Box<File> box = Hive.box<File>("notes");
  bool _creatingNewFile = false;

  // TextEditingControllers to manage input text
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    // Dispose the controllers when the widget is disposed
    _nameController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: Column(
        children: [
          // TextButton at the top, inside a Container with fixed height
          Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.topLeft,
            child: TextButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: themeProvider.themeData.highlightColor,
                foregroundColor: themeProvider.getOppositeColor(context),
              ),
              icon: const Icon(CupertinoIcons.add_circled, size: 20.0),
              label: const Text(
                "Create note",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                setState(() {
                  _creatingNewFile = !_creatingNewFile;
                });
              },
            ),
          ),
          // Expanded widget takes up the remaining space
          Expanded(
            child: _creatingNewFile
                ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: themeProvider.themeData.splashColor,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                hintText: "Name",
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: _contentController,
                                decoration: const InputDecoration(
                                  hintText: "Contents...",
                                  border: InputBorder.none,
                                ),
                                minLines: null,
                                maxLines: null,
                                expands: true,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: () {
                                    // Cancel the creation process
                                    setState(() {
                                      _creatingNewFile = false;
                                      _nameController.clear();
                                      _contentController.clear();
                                    });
                                  },
                                  child: const Text("Cancel"),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        themeProvider.themeData.primaryColor,
                                  ),
                                  onPressed: () {
                                    // Save the note and reset the form
                                    final String name = _nameController.text;
                                    final String content =
                                        _contentController.text;

                                    if (name.isNotEmpty && content.isNotEmpty) {
                                      File newFile =
                                          File(name: name, content: content);

                                      // Add the new file to the Hive box or perform any other saving operation
                                      box.add(newFile);

                                      setState(() {
                                        _creatingNewFile = false;
                                        _nameController.clear();
                                        _contentController.clear();
                                      });
                                    }
                                  },
                                  child: const Text("Save"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : ImplicitlyAnimatedReorderableList<File>(
                    items: box.values.toList(growable: true),
                    areItemsTheSame: (oldItem, newItem) =>
                        oldItem.name == newItem.name,
                    onReorderFinished: (item, from, to, newItems) {
                      setState(() {
                        final movedItem = box.getAt(from)!.copy;

                        if (from < to) {
                          // If moving down, shift other items up
                          for (int i = from; i < to; i++) {
                            final nextItem = box.getAt(i + 1)!.copy;
                            box.putAt(i, nextItem);
                          }
                        } else {
                          // If moving up, shift other items down
                          for (int i = from; i > to; i--) {
                            final prevItem = box.getAt(i - 1)!.copy;
                            box.putAt(i, prevItem);
                          }
                        }

                        // Finally, place the moved item in the target position
                        box.putAt(to, movedItem);
                      });
                    },
                    removeItemBuilder: (context, animation, oldItem) {
                      return Reorderable(
                        key: ValueKey(oldItem),
                        child: FadeTransition(
                          opacity: animation,
                          child: Text(oldItem.name),
                        ),
                      );
                    },
                    itemBuilder: (context, itemAnimation, item, index) {
                      // Each item must be wrapped in a Reorderable widget.
                      return Reorderable(
                        // Each item must have an unique key.
                        key: ValueKey(item),
                        builder: (context, dragAnimation, inDrag) {
                          final t = dragAnimation.value;
                          final elevation = lerpDouble(0, 8, t);
                          final color = Color.lerp(
                              themeProvider.themeData.splashColor,
                              themeProvider.themeData.splashColor
                                  .withOpacity(0.8),
                              t);

                          return SizeFadeTransition(
                            sizeFraction: 0.7,
                            curve: Curves.easeInOut,
                            animation: itemAnimation,
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(8.0, 2.5, 8.0, 2.5),
                              child: Material(
                                color: color,
                                borderRadius: BorderRadius.circular(12.0),
                                elevation: elevation!,
                                type: MaterialType.button,
                                child: ListTile(
                                  onTap: () {
                                    print("Open file");
                                  },
                                  title: Text(item.name),
                                  trailing: const Handle(
                                    delay: Duration(milliseconds: 50),
                                    child: Icon(
                                      Icons.list,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ), // Empty container when not creating a new file
          ),
        ],
      ),
    );
  }
}
