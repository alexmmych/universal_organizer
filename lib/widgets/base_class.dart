import 'package:flutter/material.dart';

import 'top_bar.dart';
import 'nav_rail.dart';

class BaseClass extends StatefulWidget {
  const BaseClass({
    super.key,
    required this.theme,
  });

  final ThemeData theme;

  @override
  State<BaseClass> createState() => _BaseClassState();
}

class _BaseClassState extends State<BaseClass> {
  Widget? mainPage;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: widget.theme,
      home: Scaffold(
        appBar: const TopBar(),
        body: Row(children: [
          NavRail(
            theme: widget.theme,
            callback: (p0) {
              setState(() {
                mainPage = p0;
              });
            },
          ),
          mainPage ?? const Placeholder(color: Colors.purple),
        ]),
      ),
    );
  }
}
