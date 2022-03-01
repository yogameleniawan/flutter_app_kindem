import 'package:flutter/material.dart';
import 'package:flutter_app_stulish/helpers/sizes_helpers.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: displayHeight(context) * 0.01,
          bottom: displayHeight(context) * 0.01),
      child: Container(
        width: displayWidth(context) * 1,
        height: displayHeight(context) * 0.1,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: displayWidth(context) * 0.05),
              child: Row(
                children: [
                  Image(
                    width: displayWidth(context) * 0.1,
                    image: AssetImage("assets/images/study.png"),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: displayWidth(context) * 0.03,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Level Beginner",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Padding(
                          padding: EdgeInsets.only(
                              top: displayHeight(context) * 0.01),
                          child: Text("Chapter Animal",
                              style: TextStyle(fontWeight: FontWeight.normal)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: displayWidth(context) * 0.03),
              child: CircularPercentIndicator(
                radius: 20.0,
                lineWidth: 3.0,
                percent: 0.6,
                center: new Text("60%"),
                progressColor: Color(0xFFF5A71F),
              ),
            )
          ],
        ),
      ),
    );
  }
}
