import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../providers/nav_provider.dart';

class NavRail extends StatefulWidget {
  const NavRail({
    super.key,
    required this.theme,
  });

  final ThemeData theme;

  @override
  State<NavRail> createState() => _NavRailState();
}

class _NavRailState extends State<NavRail> {
  late Widget mainPage;

  double animatedWidth = 175;

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavProvider>(context);

    if (navProvider.isShown) {
      animatedWidth = 175;
    } else {
      animatedWidth = 0;
    }

    return SafeArea(
      child: AnimatedContainer(
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
        width: animatedWidth,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: NavigationRail(
            backgroundColor: widget.theme.splashColor,
            selectedIndex: navProvider.selectedIndex,
            extended: true,
            onDestinationSelected: (value) {
              navProvider.setIndex(value);
            },
            destinations: const [
              NavigationRailDestination(
                  icon: Icon(CupertinoIcons.calendar), label: Text('Calendar')),
              NavigationRailDestination(
                  icon: Icon(CupertinoIcons.create), label: Text('Notes')),
              NavigationRailDestination(
                  icon: Icon(CupertinoIcons.list_bullet),
                  label: Text('Reminders')),
            ],
          ),
        ),
      ),
    );
  }
}
