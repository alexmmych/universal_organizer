import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

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
                      settingsProvider.loggedIn
                          ? CircleAvatar(
                              radius: 50.0,
                              foregroundImage:
                                  NetworkImage(settingsProvider.pictureURI),
                              child:
                                  Text(settingsProvider.name[0].toUpperCase()))
                          : Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                color: widget.theme.highlightColor,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(50)),
                              ),
                              child: const Icon(CupertinoIcons.person),
                            ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      // Wrap Text in Flexible to handle different container sizes
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          settingsProvider.loggedIn
                              ? "Hello ${settingsProvider.name}!"
                              : "You aren't logged in",
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
                          icon: Icon(
                              settingsProvider.loggedIn
                                  ? CupertinoIcons.square_arrow_left
                                  : CupertinoIcons.square_arrow_right,
                              size: 20.0),
                          label: Text(
                              settingsProvider.loggedIn ? "Log Out" : "Log In",
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                          onPressed: () {
                            settingsProvider.loggedIn
                                ? settingsProvider.logout()
                                : settingsProvider.login();
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
