import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../providers/nav_provider.dart';
import '../../providers/moving_provider.dart';

class MovingContainer extends StatefulWidget {
  const MovingContainer({
    super.key,
    required this.childAnimatedContainer,
    required this.requestedProvider,
  });

  final Widget childAnimatedContainer;
  final MovingProvider requestedProvider;

  @override
  State<MovingContainer> createState() => _MovingContainerState();
}

class _MovingContainerState extends State<MovingContainer> {
  late Widget mainPage;

  double animatedWidth = 175;

  @override
  Widget build(BuildContext context) {
    if (widget.requestedProvider.isShown) {
      animatedWidth = 175;
    } else {
      animatedWidth = 0;
    }

    return SafeArea(
      child: AnimatedContainer(
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
        width: animatedWidth,
        child: widget.childAnimatedContainer,
      ),
    );
  }
}
