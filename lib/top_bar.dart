import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'globals.dart';

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
  var navRail = getNavRail();

  void changeNavRail() {
    setState(() {
      navRail = (getNavRail() ? false : true);
      setNavRail(navRail);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return SafeArea(
      child: AppBar(
        backgroundColor: themeProvider.themeData.scaffoldBackgroundColor,
        leading: Row(
          children: [
            Button(onPressed: changeNavRail, icon: CupertinoIcons.bars),
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
                  icon: CupertinoIcons.moon),
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
          color: themeProvider.themeData.disabledColor,
        ),
      ),
    );
  }
}
