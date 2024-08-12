import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class NavRail extends StatelessWidget {
  const NavRail({
    super.key,
    required this.offset,
    required this.theme,
  });

  final Offset offset;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
