import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:universal_organizer/providers/theme_provider.dart';

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
