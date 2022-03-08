import 'package:flutter/material.dart';
import 'package:flutter_app_stulish/helpers/sizes_helpers.dart';
import 'dart:math' as math;

class PrevButton extends StatelessWidget {
  const PrevButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(math.pi),
      child: Image(
        width: displayWidth(context) * 0.15,
        image: AssetImage("assets/images/next-icon.png"),
      ),
    );
  }
}
