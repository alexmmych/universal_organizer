import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool useMaterial3 = true;
  ThemeMode themeMode = ThemeMode.system;
  Color colorSelected = Colors.blue;

  Color contrastColor = Colors.white;
  Color contrastColorLight = Colors.white54;

  Color oppositeColor = Colors.black;
  Color oppositeColorLight = Colors.black54;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: useMaterial3,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
            seedColor: colorSelected, brightness: Brightness.dark),
      ),
      home: TopBar(
        contrastColor: contrastColor,
        colorSelected: colorSelected,
        contrastColorLight: contrastColorLight,
        oppositeColor: oppositeColor,
        oppositeColorLight: oppositeColorLight,
      ),
      themeMode: themeMode,
    );
  }
}

class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
    required this.contrastColor,
    required this.colorSelected,
    required this.contrastColorLight,
    required this.oppositeColor,
    required this.oppositeColorLight,
  });

  final Color contrastColor;
  final Color colorSelected;
  final Color contrastColorLight;
  final Color oppositeColor;
  final Color oppositeColorLight;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      backgroundColor: contrastColorLight,
      title: const Text("Test"),
      actions: <Widget>[
        FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: contrastColor,
          hoverColor: colorSelected,
          splashColor: contrastColorLight,
          child: Icon(CupertinoIcons.moon,
              color: oppositeColor, size: 24.0, semanticLabel: "Night Mode"),
          onPressed: () => print("Button pressed"),
        ),
      ],
    ));
  }
}
