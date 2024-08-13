import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../providers/nav_provider.dart';
import 'package:provider/provider.dart';

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
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavProvider>(context);
    Offset offset = const Offset(-2, 0);

    if (navProvider.isShown) {
      offset = const Offset(0, 0);
    } else {
      offset = const Offset(-2, 0);
    }

    return SafeArea(
      child: AnimatedSlide(
        offset: offset,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
        child: NavigationRail(
          backgroundColor: widget.theme.splashColor,
          selectedIndex: selectedIndex,
          extended: true,
          onDestinationSelected: (value) => {
            setState(() {
              selectedIndex = value;
            })
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
    );
  }
}
