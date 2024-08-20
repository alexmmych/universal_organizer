import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

import '../../providers/moving_provider/settings_provider.dart';
import '../../providers/theme_provider.dart';

class Settings extends StatefulWidget {
  const Settings({
    super.key,
    required this.theme,
  });

  final ThemeData theme;

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    // Code adapted with ChatGPT so the text doesn't overflow when the animation happens
    return Container(
      color: widget.theme.splashColor,
      child: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: constraints
                      .maxWidth, // Ensure the Column does not exceed maxWidth
                ),
                child: IntrinsicWidth(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(
                        height: 30.0,
                      ),
                      CircleAvatar(
                        radius: 50.0,
                        foregroundImage:
                            NetworkImage(settingsProvider.pictureURI),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      // Wrap Text in Flexible to handle different container sizes
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "Hello ${settingsProvider.name}!",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                            backgroundColor: widget.theme.highlightColor,
                            foregroundColor:
                                themeProvider.getOppositeColor(context),
                          ),
                          icon: const Icon(CupertinoIcons.square_arrow_left,
                              size: 20.0),
                          label: const Text("Log Out",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                          onPressed: () {
                            settingsProvider.logout();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
