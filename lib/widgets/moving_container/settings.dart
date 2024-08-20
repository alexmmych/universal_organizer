import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/moving_provider/settings_provider.dart';

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
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: [
            CircleAvatar(
              foregroundImage: NetworkImage(settingsProvider.pictureURI),
            ),
            Text(
              "Hello ${settingsProvider.name}",
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
