import 'package:flutter/material.dart';
import 'package:universal_organizer/color_theme.dart';

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
          home: TopBar(brightness: brightness),
        );
      },
    );
  }
}
