import 'package:flutter/material.dart';
import 'dart:math' as Math;

import 'clipper_Widget.dart';


class WaveAnimation extends StatefulWidget {
  final Size size;
  final Color color;
  final double yOffset;

  const WaveAnimation({
    super.key,
    required this.size,
    required this.color,
    required this.yOffset,
  });

  @override
  _WaveAnimationState createState() => _WaveAnimationState();
}

class _WaveAnimationState extends State<WaveAnimation>
    with TickerProviderStateMixin {
  List<Offset> wavePoints = [];
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 5000))
      ..addListener(() {
        wavePoints.clear();

        final double waveSpeed = animationController.value * 1080;
        final double fullSphere = animationController.value * Math.pi * 2;
        final double normalizer = Math.cos(fullSphere);
        double waveWidth = Math.pi / 270;
        double waveHeight = 20.0;

        for (int i = 0; i <= widget.size.width.toInt(); ++i) {
          double calc = Math.sin((waveSpeed - i) * waveWidth);
          wavePoints.add(Offset(
              i.toDouble(), calc * waveHeight * normalizer + widget.yOffset));
        }
      });
    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, _) {
        return ClipPath(
          clipper: ClipperWidget(
            waveList: wavePoints,
          ),
          child: Container(
            height: widget.size.height,
            width: widget.size.width,
            color: widget.color,
          ),
        );
      },
    );
  }
}
