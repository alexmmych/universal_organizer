import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/nav_provider.dart';

import 'top_bar.dart';
import 'nav_rail.dart';
import 'google_calendar.dart';

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
    final navProvider = Provider.of<NavProvider>(context);
    switch (navProvider.selectedIndex) {
      case 0:
        mainPage = const GoogleCalendar();
        break;
      case 1:
        mainPage = const Placeholder(color: Colors.green);
        break;
      case 2:
        mainPage = const Placeholder(color: Colors.yellow);
        break;
      default:
        throw UnimplementedError('no widget for $navProvider');
    }
    return MaterialApp(
      theme: widget.theme,
      home: Scaffold(
        appBar: const TopBar(),
        body: Row(children: [
          NavRail(theme: widget.theme),
          Expanded(child: mainPage ?? const Placeholder(color: Colors.purple)),
        ]),
      ),
    );
  }
}
