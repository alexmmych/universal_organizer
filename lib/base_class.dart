import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'globals.dart';

import 'top_bar.dart';

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
          SafeArea(
            child: Visibility(
              visible: getNavRail(),
              child: NavigationRail(
                backgroundColor: theme.scaffoldBackgroundColor,
                selectedIndex: 0,
                extended: false,
                destinations: const [
                  NavigationRailDestination(
                      icon: Icon(CupertinoIcons.home), label: Text('Home')),
                  NavigationRailDestination(
                      icon: Icon(CupertinoIcons.calendar),
                      label: Text('Calendar')),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
