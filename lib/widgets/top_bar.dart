import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../providers/nav_provider.dart';

class TopBar extends StatefulWidget implements PreferredSizeWidget {
  const TopBar({
    super.key,
  }) : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  final Size preferredSize; // default is 56.0

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final navProvider = Provider.of<NavProvider>(context);

    return SafeArea(
      child: AppBar(
        backgroundColor: themeProvider.themeData.dividerColor,
        leading: Row(
          children: [
            Button(
                onPressed: () {
                  navProvider.toggle();
                },
                icon: CupertinoIcons.bars),
          ],
        ),
        title: const Text("Universal Organizer",
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: <Widget>[
          Row(
            children: [
              Button(
                  onPressed: () {
                    themeProvider.toggleTheme();
                  },
                  icon: themeProvider.isDarkMode
                      ? CupertinoIcons.sun_max
                      : CupertinoIcons.moon),
              Button(onPressed: () => (), icon: CupertinoIcons.settings),
              // Small space between the buttons and the edge of the screen
              const SizedBox(width: 10.0),
            ],
          ),
        ],
      ),
    );
  }
}

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return SizedBox(
      height: 40.0,
      child: FloatingActionButton(
        onPressed: onPressed,
        shape: const CircleBorder(),
        backgroundColor: themeProvider.themeData.dialogBackgroundColor,
        hoverColor: themeProvider.themeData.hoverColor,
        splashColor: themeProvider.themeData.splashColor,
        child: Icon(
          icon,
          color: themeProvider.getOppositeColor(context),
        ),
      ),
    );
  }
}
