import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:universal_organizer/providers/theme_provider.dart';

class TextButtonIcon extends StatelessWidget {
  const TextButtonIcon({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton.icon(
        style: TextButton.styleFrom(
          backgroundColor: themeProvider.themeData.highlightColor,
          foregroundColor: themeProvider.getOppositeColor(context),
        ),
        icon: Icon(icon, size: 20.0),
        label: Text(text,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        onPressed: () {
          onPressed;
        },
      ),
    );
  }
}
