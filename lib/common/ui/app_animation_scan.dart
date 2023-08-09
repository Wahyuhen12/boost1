import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class AnimationScanner extends AnimatedWidget {
  final double width;

  const AnimationScanner(
    this.width, {
    Key? key,
    required Animation<double> animation,
  }) : super(
          key: key,
          listenable: animation,
        );

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;
    final scorePosition = (animation.value * 440) + 16;

    Color color1 = Colors.blue.withOpacity(0.2);
    Color color2 = Colors.blue.withOpacity(0);

    if (animation.status == AnimationStatus.reverse) {
      color1 = Colors.blue.withOpacity(0);
      color2 = Colors.blue.withOpacity(0.2);
    }

    return Positioned(
      bottom: scorePosition,
      child: Opacity(
        opacity: 1.0,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.2,
          width: width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.1, 0.6],
              colors: [color1, color2],
            ),
          ),
        ),
      ),
    );
  }
}
