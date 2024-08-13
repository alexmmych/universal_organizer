import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../providers/nav_provider.dart';
import 'package:provider/provider.dart';

class NavRail extends StatefulWidget {
  const NavRail({
    super.key,
    required this.theme,
    required this.callback,
  });

  final ThemeData theme;
  final Function(Widget) callback;

  @override
  State<NavRail> createState() => _NavRailState();
}

class _NavRailState extends State<NavRail> {
  int selectedIndex = 0;
  late Widget mainPage;

  double animatedWidth = 175;

  @override
  Widget build(BuildContext context) {
    switch (selectedIndex) {
      case 0:
        mainPage = const Placeholder(color: Colors.red);
        break;
      case 1:
        mainPage = const Placeholder(color: Colors.green);
        break;
      case 2:
        mainPage = const Placeholder(color: Colors.yellow);
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    final navProvider = Provider.of<NavProvider>(context);

    if (navProvider.isShown) {
      animatedWidth = 175;
    } else {
      animatedWidth = 0;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => afterBuild());

    return SafeArea(
      child: AnimatedContainer(
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
        width: animatedWidth,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: NavigationRail(
            backgroundColor: widget.theme.splashColor,
            selectedIndex: selectedIndex,
            extended: true,
            onDestinationSelected: (value) {
              setState(() {
                selectedIndex = value;
              });
              widget.callback(mainPage);
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

  void afterBuild() {
    widget.callback(mainPage);
  }
}
