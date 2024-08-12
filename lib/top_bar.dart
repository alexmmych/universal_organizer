import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'color_theme.dart';

class TopBar extends StatefulWidget implements PreferredSizeWidget {
  final ValueNotifier<Brightness> brightness;

  const TopBar({
    super.key,
    required this.brightness,
  }) : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  final Size preferredSize; // default is 56.0

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  var theme = getNightMode();
  var navRail = getNavRail();

  void changeTheme() {
    setState(() {
      // Sets the theme for the app
      theme = (theme == BackgroundForeground.dayTheme
          ? BackgroundForeground.nightTheme
          : BackgroundForeground.dayTheme);

      // Changes the brightness type
      widget.brightness.value = (widget.brightness.value == Brightness.light
          ? Brightness.dark
          : Brightness.light);

      // Saves changes in hive settings box
      widget.brightness.value == Brightness.dark
          ? setNightMode(true)
          : setNightMode(false);
    });
  }

  void changeNavRail() {
    setState(() {
      navRail = (getNavRail() ? false : true);
      setNavRail(navRail);

      print(navRail);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppBar(
        backgroundColor: theme.background.secondary,
        leading: Row(
          children: [
            Button(
                theme: theme,
                onPressed: changeNavRail,
                icon: CupertinoIcons.bars),
          ],
        ),
        title: const Text("Universal Organizer",
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: <Widget>[
          Row(
            children: [
              Button(
                  theme: theme,
                  onPressed: changeTheme,
                  icon: widget.brightness.value == Brightness.dark
                      ? CupertinoIcons.sun_max
                      : CupertinoIcons.moon),
              Button(
                  theme: theme,
                  onPressed: () => (),
                  icon: CupertinoIcons.settings),
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
    required this.theme,
    required this.icon,
    required this.onPressed,
  });

  final VoidCallback onPressed;
  final BackgroundForeground theme;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.0,
      child: FloatingActionButton(
        onPressed: onPressed,
        shape: const CircleBorder(),
        backgroundColor: theme.foreground.secondary,
        hoverColor: colorSelected,
        splashColor: theme.foreground.secondary,
        child: Icon(
          icon,
          color: theme.background.primary,
        ),
      ),
    );
  }
}
