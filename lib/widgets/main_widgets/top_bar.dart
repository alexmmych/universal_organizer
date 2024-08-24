import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';
import '../../providers/moving_provider/nav_provider.dart';
import '../../providers/moving_provider/settings_provider.dart';
import '../reusable_widgets/button.dart';

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
    final settingsProvider = Provider.of<SettingsProvider>(context);

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
              Button(
                  onPressed: () {
                    settingsProvider.toggle();
                  },
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
