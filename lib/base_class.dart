import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'color_theme.dart';

import 'top_bar.dart';

class BaseClass extends StatelessWidget {
  final ValueNotifier<Brightness> brightness;

  const BaseClass({
    super.key,
    required this.brightness,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Brightness>(
      valueListenable: brightness,
      builder: (context, brightnessValue, child) {
        return MaterialApp(
          theme: ThemeData(
            useMaterial3: useMaterial3,
            brightness: brightnessValue,
            colorScheme: ColorScheme.fromSeed(
              seedColor: colorSelected,
              brightness: brightnessValue,
            ),
          ),
          home: Scaffold(
            appBar: TopBar(brightness: brightness),
            body: Row(children: [
              SafeArea(
                child: Visibility(
                  visible: getNavRail(),
                  child: NavigationRail(
                    backgroundColor: getNightMode().background.secondary,
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
      },
    );
  }
}
