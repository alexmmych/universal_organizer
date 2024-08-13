import 'package:flutter/material.dart';

import 'top_bar.dart';
import 'nav_rail.dart';

class BaseClass extends StatelessWidget {
  const BaseClass({
    super.key,
    required this.theme,
  });

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: Scaffold(
        appBar: const TopBar(),
        body: Row(children: [
          NavRail(theme: theme),
        ]),
      ),
    );
  }
}
