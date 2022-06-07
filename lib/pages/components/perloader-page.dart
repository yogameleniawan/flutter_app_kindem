import 'package:flutter/material.dart';
import 'package:kindem_app/helpers/sizes_helpers.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class PreloaderPage extends StatelessWidget {
  const PreloaderPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF1F1F1),
        body: Container(
            child: Center(
                child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              width: displayWidth(context) * 0.5,
              image: AssetImage("assets/images/kindem-logo.png"),
            ),
            Padding(
              padding: EdgeInsets.only(top: displayHeight(context) * 0.1),
              child: LoadingAnimationWidget.discreteCircle(
                color: Color(0xFF0067B6),
                size: 40,
                secondRingColor: Color(0xFFF5A71F),
                thirdRingColor: Colors.white,
              ),
            ),
          ],
        ))));
  }
}
