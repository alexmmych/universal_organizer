import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'top_bar.dart';

import 'nav_provider.dart';
import 'package:provider/provider.dart';

class BaseClass extends StatelessWidget {
  const BaseClass({
    super.key,
    required this.theme,
  });

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavProvider>(context);
    Offset offset = const Offset(-2, 0);

    if (navProvider.isShown) {
      offset = const Offset(0, 0);
    } else {
      offset = const Offset(-2, 0);
    }

    return MaterialApp(
      theme: theme,
      home: Scaffold(
        appBar: const TopBar(),
        body: Row(children: [
          SafeArea(
            child: AnimatedSlide(
              offset: offset,
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
              child: NavigationRail(
                backgroundColor: theme.splashColor,
                selectedIndex: 0,
                extended: true,
                destinations: const [
                  NavigationRailDestination(
                      icon: Icon(CupertinoIcons.home), label: Text('Home')),
                  NavigationRailDestination(
                      icon: Icon(CupertinoIcons.calendar),
                      label: Text('Calendar')),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
